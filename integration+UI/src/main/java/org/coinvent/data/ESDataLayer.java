package org.coinvent.data;

import com.google.gson.Gson;
import com.winterwell.utils.containers.SharedStatic;

import creole.data.XId;
import winterwell.utils.web.WebUtils2;
import winterwell.web.FakeBrowser;
import winterwell.web.WebEx;

/**
 * HACK: uses hard-coded urls to find ElasticSearch
 * @author daniel
 *
 */
public class ESDataLayer {

	Gson gson = SharedStatic.get(Gson.class);
	
	public User getUser(String actorName) {
		if (actorName==null) return null;
		try {
			FakeBrowser fb = new FakeBrowser();
			String json = fb.getPage("http://localhost:9200/coinvent/user/"+WebUtils2.urlEncode(actorName));
			User u = gson.fromJson(json, User.class);
			return u;
		} catch(WebEx.E404 e) {
			return null;
		}
	}

	public Object getConcept(String theoryName) {
		if (theoryName==null) return null;
		FakeBrowser fb = new FakeBrowser();
		String json = fb.getPage("http://localhost:9200/coinvent/concept/"+WebUtils2.urlEncode(theoryName));
		return json;
	}

	public IJob getJob(String id) {
		if (id==null) return null;
		FakeBrowser fb = new FakeBrowser();
		String json = fb.getPage("http://localhost:9200/coinvent/job/"+WebUtils2.urlEncode(id));
		IJob u = gson.fromJson(json, Job.class);
		return u;
	}

	public User getCreate(XId xid) {		
		// TODO Get
		// Create
		User u = new User(xid);
		FakeBrowser fb = new FakeBrowser();
		String ok = fb.post("http://localhost:9200/coinvent/user/"+WebUtils2.urlEncode(xid),
				null, gson.toJson(u));	
		return u;
	}

}
