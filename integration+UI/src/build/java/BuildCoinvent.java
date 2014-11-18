

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;

import com.winterwell.utils.io.FileUtils;

import winterwell.bob.BuildTask;
import winterwell.bob.tasks.CompileTask;
import winterwell.bob.tasks.EclipseClasspath;
import winterwell.bob.tasks.RSyncTask;
import winterwell.utils.FailureException;

/**
 * @author daniel
 *
 */
public class BuildCoinvent extends BuildTask {

	public static String[] requiredProjects = new String[]{
			"winterwell.utils",
			"winterwell.web",
//			"winterwell.base",
//			"winterwell.maths",
//			"winterwell.nlp",
//			"winterwell.depot",
			"winterwell.datalog",
//			"jtwitter",
//			"jgeoplanet", //handled as a special case
//			"j4square",
			"winterwell.bob",
//			"juice",
//			"pinpoint",
//			"babel",
//			"linkedin-j",
//			"gson-forked", The jar is used instead
//			"bigmachine"
	};

	@Override
	public void doTask() throws Exception {
		File winterwellCode = new File(FileUtils.getWinterwellDir(), "/code").getAbsoluteFile();
		assert winterwellCode.isDirectory() : winterwellCode;
		File cmDir = new File(winterwellCode, "creole");
		assert cmDir.isDirectory() : cmDir;
		// Copy Utils

		// copy in required classes
		// FIXME: This relies on eclipse's auto-build behaviour
		// - since we're not doing a compile here (why not??)
		File classes = new File(cmDir, "web/WEB-INF/classes");
		for(String project : requiredProjects) {
			File projectDir = getProjectDir(winterwellCode, project);
			String binDir = projectDir.getAbsolutePath() + "/bin/"; // The trailing slash is important
			// HACK: 3rd party project with maven structure
			if (project.equals("linkedin-j")) binDir = projectDir.getAbsolutePath() + "/linkedin-j/target/classes/";
			if ( ! new File(binDir).isDirectory()) {
				assert false : project+" \t "+binDir;
			}
			RSyncTask copy = new RSyncTask(binDir, classes.getAbsolutePath(), false);
			copy.run();
		}

//		CopyTask copy = new CopyTask(), classes);
//		copy.setIncludeHiddenFiles(false);
//		copy.setOverwrite(true);
//		copy.run();

		// Compile
		File src = new File(cmDir, "src");
		CompileTask compile = new CompileTask(src, classes);
//		WTF! FIXME this just started throwing errors
//		EclipseClasspath ec = new EclipseClasspath(cmDir);
//		ArrayList<File> cp = new ArrayList();
//		for(String p : ec.getReferencedProjects()) {
//			cp.add(new File(winterwellCode, p+"/bin"));
//		}
//		for(File lib : ec.getReferencedLibraries()) {
//			cp.add(lib);
//		}
//		compile.setClasspath(cp);
//		compile.run();
		
		// Make jar
		//		File jar = new File(cmDir, "web/WEB-INF/lib/creole.jar");
		//		JarTask jarrer = new JarTask(jar, classes);
		//		jarrer.run();
	}

	File getProjectDir(File winterwellCode, String project) {
		File dir = new File(winterwellCode, project);
		if (dir.isDirectory()) return dir;
		dir = new File(FileUtils.getWinterwellDir(), "forest-of-gits/"+project);
		if (dir.isDirectory()) return dir;
		dir = new File(FileUtils.getWinterwellDir(), project);
		if (dir.isDirectory()) return dir;
		throw new FailureException(project);
	}

	@Override
	public Collection<? extends BuildTask> getDependencies() {
		return
		null;
		//		Arrays.asList(new BuildUtils(), new BuildWeb(), new BuildMaths());
	}

}
