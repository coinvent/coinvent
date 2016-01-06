import java.io.File;

import winterwell.bob.BuildTask;
import winterwell.bob.tasks.GitTask;
import winterwell.bob.tasks.JarTask;
import winterwell.bob.tasks.RSyncTask;
import winterwell.utils.io.FileUtils;
import winterwell.utils.time.Time;


public class PublishCoinventSimpleServer extends BuildTask {

	@Override
	protected void doTask() throws Exception {
		File projectDir = FileUtils.getWorkingDirectory();
		assert new File(projectDir, "web/static").isDirectory() : projectDir.getAbsolutePath();
		// Jar
		File jarFile = new File(projectDir, "simple-server.jar");
		JarTask jar = new JarTask(jarFile, new File(projectDir, "web/WEB-INF/classes"));
		jar.setAppend(false);
		// Version = date Is this good or bogus?
		Time vt = new Time();
		jar.setManifestProperty(JarTask.MANIFEST_IMPLEMENTATION_VERSION, vt.ddMMyyyy());
		jar.run();
		
		// rsync to Ewen's server
		// ssh -p 3022 -i ~/.ssh/ewen@Coinvent-Ewen ewen@frank.soda.sh
		// scp -r -P 3022 -i ~/.ssh/ewen@Coinvent-Ewen web/static/ ewen@frank.soda.sh:~/simple-server
		// scp -r -P 3022 -i ~/.ssh/ewen@Coinvent-Ewen my-local-dir/simple-server ewen@frank.soda.sh:~/simple-server
		
		// NB: use tmux on the server to go into a persistent screen
		
		RSyncTask rsync = new RSyncTask(projectDir.getAbsolutePath(), "ewen@frank.soda.sh:~/simple-server", true);
//		rsync.addArg("-e 'ssh -p 3022 -i ~/.ssh/ewen@Coinvent-Ewen'");
		rsync.run();
	}
}
