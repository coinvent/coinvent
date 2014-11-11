package org.coinvent.data;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.coinvent.web.FileServlet;

import com.winterwell.utils.io.FileUtils;

import winterwell.utils.web.XStreamUtils;

/**
 * A crude save-to-file data layer.
 * @author daniel
 *
 */
public class FileDataLayer implements IDataLayer {

	File base = FileServlet.BASE;
	
	@Override
	public User getUser(Id user) {
		File f = new File(base, s(user.getName())+"/user.xml");
		if (f.isFile()) {
			return FileUtils.load(f);
		}		
		return null;
	}

	String s(Object id) {
		String s = id.toString();
		s = FileUtils.safeFilename(s);
		return s;
	}

	@Override
	public List<Id> getConcepts(Id user) {
		File dir = new File(base, user.getName());		
		List<Id> cs = new ArrayList();
		for(File f : dir.listFiles()) {
			if (f.getName().equals("user.xml")) continue;
			cs.add(Concept.getId(user, f.getName()));
		}
		return cs;
	}

	@Override
	public List<Id> getUserJobs(Id user) {		
		File f = getFile(new Id(user, KKind.Job, "dummy"));
		List<File> fs = FileUtils.find(f.getParentFile(), ".+");
		List<Id> list = new ArrayList();
		for (File file : fs) {
			if (file.isDirectory()) continue;
			Id id = new Id(user, KKind.Job, file.getName());
			list.add(id);
		}		
		return list;
	}

	@Override
	public List<Id> getConceptJobs(Id concept) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Concept getConcept(Id concept) {
		String[] bits = concept.getName().split("__");
		File f = new File(base, bits[0]+"/"+bits[1]);
		if (f.isFile()) return FileUtils.load(f);
		return null;
	}

	@Override
	public IJob getJob(Id xid) {
		File f = getFile(xid);
		if ( ! f.isFile()) return null;
		return XStreamUtils.serialiseFromXml(FileUtils.read(f));
	}

	private File getFile(Id xid) {
		assert xid != null;
		return new File(base, s(xid.getParent().getName())
							+"/_"+xid.getKind().toString()
							+"/"+s(xid.getName()));
	}

	@Override
	public User getCreateUser(Id xid) {
		assert xid.getName() != null : xid;
		File f = new File(base, s(xid.getName())+"/user.xml");
		if (f.isFile()) return FileUtils.load(f);
		User u = new User(xid);
		f.getParentFile().mkdirs();
		FileUtils.save(u, f);
		return u;
	}

	@Override
	public Concept getCreateConcept(User user, String conceptName) {
		Id concept = Concept.getId(user.getId(), conceptName);
		String[] bits = concept.getName().split("__");
		assert bits[0].equals(user.getId().getName()) : concept;
		File f = new File(base, s(user.getId().getName())+"/"+bits[1]);
		if (f.isFile()) return FileUtils.load(f);
		Concept u = new Concept(user, concept);
		f.getParentFile().mkdirs();
		FileUtils.save(u, f);
		return u;
	}

	@Override
	public IJob saveJob(IJob job) {
		File f = getFile(job.getId());
		f.getParentFile().mkdirs();
		FileUtils.save(job, f);
		return job;
	}

}
