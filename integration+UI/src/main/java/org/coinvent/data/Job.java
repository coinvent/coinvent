package org.coinvent.data;

import java.io.Serializable;
import java.util.Map;

import com.winterwell.depot.Desc;
import com.winterwell.utils.threads.ATask.QStatus;


import winterwell.web.app.WebRequest;

public class Job implements IJob {

	WebRequest request;
	Object result;
	Id actor;
	QStatus status = QStatus.WAITING;
	String opName;

	public Job(User actor, String opName, WebRequest req) {
		this.request = req;
		this.actor = actor.getId();
		this.opName = opName;
	}

	@Override
	public Object getResult() {
		return result;
	}

	public Id getId() {
		// hash the request setup & contents
		Desc desc = new Desc(opName, Job.class);
		desc.setTag(actor.getName());
		// NB: full slug
		desc.put("slug", request.getSlug());		
		Map<String, Object> pmap = request.getParameterMap();
		for(String k : pmap.keySet()) {
			desc.put(k, pmap.get(k));
		}
		
		return new Id(actor.toString()+"__"+desc.getId(), "@coinvent");
	}

	public Id getActor() {
		return actor;
	}
	
	@Override
	public QStatus getStatus() {
		return status;
	}

}
