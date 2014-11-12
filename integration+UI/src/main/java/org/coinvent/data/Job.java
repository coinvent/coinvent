package org.coinvent.data;

import java.io.Serializable;
import java.util.Map;

import com.winterwell.depot.Desc;
import com.winterwell.utils.threads.ATask.QStatus;

import winterwell.utils.StrUtils;
import winterwell.utils.Utils;
import winterwell.web.app.WebRequest;

public class Job implements IJob {

	Object result;
	Id actor;
	QStatus status = QStatus.WAITING;
	String component;
	Map<String, Object> pmap;
	String slug;
	private BlendDiagram diagram;
	
	public BlendDiagram getDiagram() {
		return diagram;
	}
	
	@Override
	public void setResult(Object jobj) {
		this.result = jobj;
	}
	
	public void setStatus(QStatus status) {
		this.status = status;
	}
	
	@Override
	public String getComponent() {
		return component;
	}

	public Job(User actor, String component, BlendDiagram diagram, WebRequest req) {
		Utils.check4null(actor, component, req);
		this.pmap = req.getParameterMap();
		this.slug = req.getSlug();
		this.actor = actor.getId();
		this.component = component;
		this.diagram = diagram;
	}
	
	@Override
	public Object getResult() {
		return result;
	}
	
	@Override
	public String toString() {
		return "Job["+getId().toString()+"]";
	}

	public Id getId() {
		// hash the request setup & contents
		Desc desc = new Desc(component, Job.class);
		desc.setTag("coinvent");
		desc.put("actor", actor.id);
		// NB: full slug
		desc.put("slug", slug);		
		for(String k : pmap.keySet()) {
			desc.put(k, pmap.get(k));
		}
		
		return new Id(actor, KKind.Job, StrUtils.md5(desc.getId()));
	}

	public Id getActor() {
		return actor;
	}
	
	@Override
	public QStatus getStatus() {
		return status;
	}

}
