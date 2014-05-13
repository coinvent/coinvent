package org.coinvent.data;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import winterwell.utils.io.FileUtils;
import winterwell.utils.web.XStreamUtils;
import creole.data.XId;

public class FileDataLayer implements IDataLayer {

	File base = new File("data");
	
	@Override
	public User getUser(XId user) {
		File f = new File(base, user.getName()+"/user.xml");
		if (f.isFile()) {
			return FileUtils.load(f);
		}
		return null;
	}

	@Override
	public List<XId> getConcepts(XId user) {
		File dir = new File(base, user.getName());		
		List<XId> cs = new ArrayList();
		for(File f : dir.listFiles()) {
			if (f.getName().equals("user.xml")) continue;
			cs.add(new XId(user.getName()+"__"+f.getName()+"@coinvent"));
		}
		return cs;
	}

	@Override
	public List<XId> getUserJobs(XId user) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<XId> getConceptJobs(XId concept) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Concept getConcept(XId concept) {
		String[] bits = concept.getName().split("__");
		File f = new File(base, bits[0]+"/"+bits[1]);
		if (f.isFile()) return FileUtils.load(f);
		return null;
	}

	@Override
	public IJob getJob(XId xid) {
		String[] bits = xid.getName().split("__");		
		File f = new File(base, bits[0]+"/"+bits[1]);		
		if ( ! f.isFile()) return null;
		return XStreamUtils.serialiseFromXml(FileUtils.read(f));
	}

	@Override
	public User getCreateUser(XId xid) {
		File f = new File(base, xid.getName()+"/user.xml");
		if (f.isFile()) return FileUtils.load(f);
		User u = new User(xid);
		f.getParentFile().mkdirs();
		FileUtils.save(u, f);
		return u;
	}

	@Override
	public Concept getCreateConcept(User user, String conceptName) {
		XId concept = new XId(user.getXId().getName()+"__"+conceptName+"@coinvent");
		String[] bits = concept.getName().split("__");
		assert bits[0].equals(user.getXId().getName()) : concept;
		File f = new File(base, user.getXId().getName()+"/"+bits[1]);
		if (f.isFile()) return FileUtils.load(f);
		Concept u = new Concept(user, concept);
		f.getParentFile().mkdirs();
		FileUtils.save(u, f);
		return u;
	}

}
