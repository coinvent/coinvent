//package org.coinvent.data;
//
//import java.util.List;
//
//import com.google.gson.Gson;
//import com.winterwell.utils.containers.SharedStatic;
//
//import creole.data.XId;
//import winterwell.utils.TodoException;
//import winterwell.utils.web.WebUtils2;
//import winterwell.web.FakeBrowser;
//import winterwell.web.WebEx;
//
///**
// * HACK: uses hard-coded urls to find ElasticSearch
// * @author daniel
// *
// */
//public class ESDataLayer implements IDataLayer {
//
//	Gson gson = SharedStatic.get(Gson.class);
//	
//	/* (non-Javadoc)
//	 * @see org.coinvent.data.IDataLayer#getUser(java.lang.String)
//	 */
//	@Override
//	public User getUser(XId actorName) {
//		if (actorName==null) return null;
//		try {
//			FakeBrowser fb = new FakeBrowser();
//			String json = fb.getPage("http://localhost:9200/coinvent/user/"+WebUtils2.urlEncode(actorName));
//			User u = gson.fromJson(json, User.class);
//			return u;
//		} catch(WebEx.E404 e) {
//			return null;
//		}
//	}
//	
//	/* (non-Javadoc)
//	 * @see org.coinvent.data.IDataLayer#getConcepts(creole.data.XId)
//	 */
//	@Override
//	public List<XId> getConcepts(XId user) {
//		throw new TodoException();
//	}
//	/* (non-Javadoc)
//	 * @see org.coinvent.data.IDataLayer#getUserJobs(creole.data.XId)
//	 */
//	@Override
//	public List<XId> getUserJobs(XId user) {
//		throw new TodoException();
//	}
//	/* (non-Javadoc)
//	 * @see org.coinvent.data.IDataLayer#getConceptJobs(creole.data.XId)
//	 */
//	@Override
//	public List<XId> getConceptJobs(XId concept) {
//		throw new TodoException();
//	}
//
//	/* (non-Javadoc)
//	 * @see org.coinvent.data.IDataLayer#getConcept(java.lang.String)
//	 */
//	@Override
//	public Concept getConcept(XId theoryName) {
//		if (theoryName==null) return null;
//		FakeBrowser fb = new FakeBrowser();
//		String json = fb.getPage("http://localhost:9200/coinvent/concept/"+WebUtils2.urlEncode(theoryName));
//		return gson.fromJson(json, Concept.class);
//	}
//
//	/* (non-Javadoc)
//	 * @see org.coinvent.data.IDataLayer#getJob(java.lang.String)
//	 */
//	@Override
//	public IJob getJob(XId id) {
//		if (id==null) return null;
//		FakeBrowser fb = new FakeBrowser();
//		String json = fb.getPage("http://localhost:9200/coinvent/job/"+WebUtils2.urlEncode(id));
//		IJob u = gson.fromJson(json, Job.class);
//		return u;
//	}
//
//	/* (non-Javadoc)
//	 * @see org.coinvent.data.IDataLayer#getCreateUser(creole.data.XId)
//	 */
//	@Override
//	public User getCreateUser(XId xid) {		
//		// TODO Get
//		// Create
//		User u = new User(xid);
//		FakeBrowser fb = new FakeBrowser();
//		String ok = fb.post("http://localhost:9200/coinvent/user/"+WebUtils2.urlEncode(xid),
//				null, gson.toJson(u));	
//		return u;
//	}
//
//	@Override
//	public Concept getCreateConcept(User user, String conceptName) {
//		// TODO Auto-generated method stub
//		return null;
//	}
//
//}
