

import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.logging.Level;

import com.winterwell.utils.Proc;
import com.winterwell.utils.io.FileUtils;

import winterwell.bob.BobSettings;
import winterwell.bob.BuildTask;
import winterwell.bob.tasks.EclipseClasspath;
import winterwell.bob.tasks.RSyncTask;
import winterwell.bob.tasks.RemoteTask;
import winterwell.bob.tasks.SCPTask;
import winterwell.utils.Environment;
import winterwell.utils.FailureException;
import winterwell.utils.Printer;
import winterwell.utils.StrUtils;
import winterwell.utils.Utils;
import winterwell.utils.containers.Containers;
import winterwell.utils.containers.Containers.Changes;
import winterwell.utils.gui.GuiUtils;
import winterwell.utils.reporting.Log;
import winterwell.utils.web.XStreamUtils;

/**
 * Assumes everything is built.
 * That we're publishing to /home/winterwell/siteName on winterwell.com
 * Assumes that "/etc/init.d/"+siteName+"-jetty restart" will (re)start the server
 *
 * <p>
 * Does NOT copy jar files by default!
 * You must separately ensure that these are copied or linked into place.
 *
 * @author daniel
 *
 */
public class PublishCoinvent extends BuildTask {

	/**
	 * Server used as a staging machine for sending updates acrossd the cluster.
	 * E.g. "egan"
	 * MUST be a hostname, not an IP address.
	 * TODO: Switch to huxley and remove the hardcoded huxley tests!
	 */
	public static final String DEFAULT_PUSHOUT_HOSTNAME = "haldeman";

	protected String branch;

	/**
	 * The lib dir is normally managed by egan.
	 * If true, this does an rsync instead.
	 * Note: true is a good idea!
	 */
	protected static boolean SEND_ALL_JARS = true;


	/**
	 * Try a default sort of {@link BuildCreoleSite}.
	 * Probably best to override this.
	 */
	@Override
	public Collection<? extends BuildTask> getDependencies() {
		return Arrays.asList(
				new BuildCoinvent()
				);
	};

	protected File remoteWebAppDir;
	protected String remoteUserHost;
	protected boolean rebootJetty = true;


	/** aka the Eclipse project folder */
	protected File localWebAppDir;

	private String siteName;

	/**
	 * true by default
	 * @param rebootJetty
	 */
	public void setRebootJetty(boolean rebootJetty) {
		this.rebootJetty = rebootJetty;
	}

	/**
	 * @param siteName the project slug
	 * @param remoteUserHost user@host specification for the production server. Can be null in which case will use "winterwell@winterwell.com"
	 * @param remoteWebAppDir Can be null in which case will use "/home/winterwell/"+siteName
	 */
	public PublishCoinvent(String remoteUserHost, File remoteWebAppDir) {
		this.siteName = "coinvent";
		this.remoteUserHost = remoteUserHost;
		if (this.remoteUserHost == null) {
			this.remoteUserHost = "winterwell@winterwell.com";
		}
		this.remoteWebAppDir = remoteWebAppDir;
		if (remoteWebAppDir==null) {
			this.remoteWebAppDir = new File("/home/winterwell/"+siteName);
		}
		// local
		localWebAppDir = FileUtils.getWorkingDirectory();
		assert localWebAppDir.isDirectory() && new File(localWebAppDir, "web").isDirectory() : localWebAppDir;
	}

	@Override
	public void doTask() throws Exception {
		SCPTask._atomic = false; // wtf bug hunting

		// Setup file paths
		// Check that we are running from a plausible dir:
		if (! localWebAppDir.exists() || ! localWebAppDir.getPath().contains(siteName)
			|| !new File(localWebAppDir,"web").exists()) {
			throw new IOException("Not in the expected directory! dir="+FileUtils.getWorkingDirectory());
		}
		Log.i("publish", "Publishing "+siteName+" to "+remoteUserHost+":"+ remoteWebAppDir);
		// What's going on?
		Environment.get().push(BobSettings.VERBOSE, true);
		// Note the colon
        String remoteWebInfDir = new File(remoteWebAppDir, "web/WEB-INF/").getAbsolutePath();
		String remoteWebInf = remoteUserHost + ":" + remoteWebInfDir;

		// TIMESTAMP code to avoid caching issues: epoch-seconds, mod 10000 to shorten it
		String code = "" + ((System.currentTimeMillis()/1000) % 10000);

		{ // create remote WEB-INF directory and parent if needed
            RemoteTask mkdir = new RemoteTask(remoteUserHost, "mkdir -p " + remoteWebInfDir);
            mkdir.run();
			System.out.println(mkdir.getOutput());
		}

//		{	// TODO Compile Less
			Proc proc = new Proc("nodejs process less"); // TODO
//			proc.run();
//			proc.waitFor(TUnit.MINUTE.dt);
//			// The output should get rsync'd up
//
//			// TODO template surgery to replace dynamic less with static css
//			String template = FileUtils.read(file);
//			Object template2 = template.replace(dynamic, static);
//			// TODO send the edited file
//			// TODO put the file back afterwards
//		}

		{	// copy all the properties files
			doUploadProperties(code);
		}
		{	// jmx passwords
			File f = new File(localWebAppDir,"jmx-passwords.txt");
			if (f.exists()) {
				Log.report("publish","Sending jmx passwords...", Level.FINE);
				SCPTask task = new SCPTask(f, remoteUserHost, remoteWebAppDir.getAbsolutePath());
				task.run();
				// Paranoia
				new RemoteTask(remoteUserHost, "chmod 600 " + remoteWebAppDir.getAbsolutePath() + "/jmx-passwords.txt").run();
			} else {
				Log.report("publish","No jmx passwords file?!", Level.WARNING);
			}
		}

		// Copy up the code
		File puppetStringsDir = FileUtils.getWorkingDirectory();

		// NB The libs dir MUST be soft-linked manually on the server
		// Egan rsyncs it's lib dir across the cluster, so it's enough to update egan
		// This is ONLY a hack for sending jars en masse to dev.soda.sh
		if (SEND_ALL_JARS) {
			Log.w("publish","Sending all jars!");
			EclipseClasspath ec = new EclipseClasspath(localWebAppDir);
			Set<File> jars = ec.getCollectedLibs();

			// Create local lib dir
			File localLib = new File(localWebAppDir,"web/WEB-INF/lib");
			localLib.mkdirs();
			assert localLib.isDirectory();

			// Ensure desired jars are present
			for (File jar : jars) {
				File localJar = new File(localLib, jar.getName());
				// FIXME: Questionable
				if (localJar.lastModified() >= jar.lastModified()) {
					continue;
				}
				FileUtils.copy(jar, localJar);
			}
			
			// Remove unwanted jars
			for (File jar : localLib.listFiles()) {
				boolean found = false;
				for (File jar2 : jars) {
					if (jar.getName().equals(jar2.getName())) found = true;
				}
				if (!found) {
					// This was in the lib directory, but not in the classpath
					Log.w("publish", "Deleteing apparently unwanted file " + jar.getAbsolutePath());
					FileUtils.delete(jar);
				}
			}

			// Synchronize local with remote
			RSyncTask task = new RSyncTask(localLib.getAbsolutePath(), remoteWebInf, true);
			task.run();
			System.out.println(task.getOutput());
		}

		{   // Upload Creole's core classes
			Log.report("publish","Uploading Creole classes...", Level.INFO);
			// This copies the classes directory into remote WEB-INF/classes
			// BuildCreole has already copied classes from projects like winterwell.utils into here
			File puppetStringsClassesDir = new File(puppetStringsDir, "web/WEB-INF/classes");
			RSyncTask task = new RSyncTask(puppetStringsClassesDir.getAbsolutePath(), remoteWebInf, true);
			task.run();
		}

		{	// Upload this application's classes
			Log.report("publish","Uploading "+siteName+" classes...", Level.INFO);
			RSyncTask rsync2 = new RSyncTask(
					new File(localWebAppDir, "web/WEB-INF/classes").getAbsolutePath(),
					remoteWebInf,
					false);
			rsync2.run();
		}

		String[] templates = {
				"templates/simplepage.html",
				"templates/simplepage.min.html",
				"templates/login.html",
				"templates/login.min.html"
		};

		updateTemplates(code, templates);

		{	// The ignored exceptions file, and the skip-patches file
			File ie = new File(localWebAppDir, "ignored-exceptions.txt");
			if (ie.exists()) {
				SCPTask task = new SCPTask(ie, remoteUserHost, remoteWebAppDir.getAbsolutePath());
				task.run();
			}
			File sp = new File(localWebAppDir, "skip-patches.txt");
			if (sp.exists()) {
				SCPTask task = new SCPTask(sp, remoteUserHost, remoteWebAppDir.getAbsolutePath());
				task.run();
			}
		}

		{	// RSync static resources: css, javascript whatnot -- All of web/static
			Log.report("publish","Uploading static...", Level.INFO);
			String remoteStaticParent = remoteUserHost+":"+remoteWebAppDir.getAbsolutePath()+"/web/";
			// NB getAbsolutePath() strips trailing slashes, which are super significant for rsync
			// Hence we copy to the parent of intended destination
			RSyncTask rsync = new RSyncTask(new File(localWebAppDir,"web/static").getAbsolutePath(), remoteStaticParent, false);
			rsync.run();
			// Rsync code with delete=true, so we get rid of old html templates
			// ??This is a bit wasteful, but I'm afraid of what delete might do in the more general /web/static directory ^Dan
			RSyncTask rsyncCode = new RSyncTask(
					new File(localWebAppDir,"web/static/code").getAbsolutePath(),
					remoteStaticParent + "static/", true);
			rsyncCode.run();
			String out = rsyncCode.getOutput();
			rsyncCode.close();
		}

		if (rebootJetty ) {	// Reboot Jetty
			Log.i("publish", "Rebooting Jetty...");
			RemoteTask reboot = new RemoteTask(remoteUserHost,"/etc/init.d/"+siteName+"-jetty restart");
			reboot.run();
		}
		System.out.println("\n*** Upgraded: "+remoteUserHost+" (no pushout) ***\n");
		// Done

	}

	/**
	 * In the supplied templates, replaces any matches of the string "TIMESTAMP"
	 * with the value specified in code.
	 *
	 * @param code The code to use in the update.
	 * @param templatePaths Paths to the files that are to be updated.
	 */
	private void updateTemplates(String code, String[] templatePaths) {
		File[] headers = new File[templatePaths.length];
		File[] originals = new File[templatePaths.length];

		int index = 0;

		for (String templatePath : templatePaths) {
			File header = new File(localWebAppDir, templatePath);
			File original = FileUtils.changeType(header, "clean");

			headers[index] = header;
			originals[index] = original;

			if (header.exists()) {
				String html = FileUtils.read(header);
				assert ! Utils.isBlank(html) : header;
				FileUtils.move(header, original);
				assert ! Utils.isBlank(FileUtils.read(original)) : header;
				html = html.replaceAll("TIMESTAMP", code);
				FileUtils.write(header, html);
			} else {
				Log.e("publish", "NO TEMPLATE?! "+header);
			}

			index++;
		}

		try {
			Log.report("publish","Uploading "+siteName+" templates...", Level.INFO);
			String remoteTemplates = remoteUserHost+":"+remoteWebAppDir.getAbsolutePath()+"/";
			RSyncTask rsync3 = new RSyncTask(
					new File(localWebAppDir,"templates").getAbsolutePath(),
					remoteTemplates, false);
			rsync3.run();

		} finally {
			index = 0;

			for (File original : originals) {
				File header = headers[index];

				// reset header.html
				if (original.exists()) {
					FileUtils.move(original, header);
					assert ! Utils.isBlank(FileUtils.read(header));
				}

				index++;
			}
		}
	}

	private void doUploadProperties(Object code) throws IOException {
		// Copy up creole.properties and version.properties
		Log.report("publish","Uploading .properties...", Level.INFO);
		{	// create the version properties
			File creolePropertiesForSite = new File(localWebAppDir, "config/version.properties");
			Properties props = creolePropertiesForSite.exists()? FileUtils.loadProperties(creolePropertiesForSite)
								: new Properties();
//			// set the publish time
//			props.setProperty(Creole.PROPERTY_PUBLISH_DATE, ""+System.currentTimeMillis());
//			// set info on the git branch
//			String branch = GitTask.getGitBranch(null);
//			props.setProperty(Creole.PROPERTY_GIT_BRANCH, branch);
//			// ...and commit IDs
//			for(String repo : new String[]{"sodash","code","juice","jtwitter","business"}) {
//				try {
//					Map<String, Object> info = GitTask.getLastCommitInfo(new File(FileUtils.getWinterwellDir(), repo));
//					props.setProperty(Creole.PROPERTY_GIT_COMMIT_ID+"."+repo, (String)info.get("hash"));
//					props.setProperty(Creole.PROPERTY_GIT_COMMIT_INFO+"."+repo, StrUtils.compactWhitespace(XStreamUtils.serialiseToXml(info)));
//				} catch(Exception ex) {
//					// oh well;
//				}
//			}

//			// the timestamp code
//			props.setProperty(Creole.PROPERTY_VERSION_TIMECODE, ""+code);
//
//			// Who did the push?
//			try {
//				props.setProperty("origin", Creole.hostname());
//			} catch(Exception ex) {
//				// oh well
//			}

			// save
			BufferedWriter w = FileUtils.getWriter(creolePropertiesForSite);
			props.store(w, null);
			FileUtils.close(w);
		}
		
		{	// config (e.g. Pinpoint)
			File f = new File(localWebAppDir, "config");
			assert f.isDirectory() : f;
			Log.d("publish","Sending config dir files: "+Printer.toString(f.list()));
			String remoteConfig = remoteUserHost+":"+remoteWebAppDir.getAbsolutePath()+"/config/";
			RSyncTask task = new RSyncTask(f.getAbsolutePath()+"/", remoteConfig, true);
			task.run();			
		}
	}



}
