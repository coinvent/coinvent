package org.coinvent.web;

import java.io.IOException;
import java.util.Arrays;

import org.coinvent.data.DataLayerFactory;
import org.coinvent.data.FileDataLayer;
import org.coinvent.data.IDataLayer;
import org.coinvent.data.IJob;
import org.coinvent.data.Id;
import org.coinvent.data.Job;
import org.coinvent.data.KKind;
import org.coinvent.data.User;

import com.winterwell.utils.io.FileUtils;
import com.winterwell.utils.threads.ATask.QStatus;

import winterwell.utils.StrUtils;
import winterwell.utils.Utils;
import winterwell.utils.containers.ArrayMap;
import winterwell.web.WebEx;
import winterwell.web.WebInputException;
import winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;

/**
 * Base class for Coinvent servlets.
 * @author Daniel
 *
 */
public abstract class AServlet {
	
	JsonResponse doSlow(WebRequest req) {
		assert actor != null;
		// ...make a job 
		IJob job = new Job(actor, component, req);
		
		// ...use history?
		Id jid = job.getId();
		IJob oldJob = dataLayer.getJob(jid);
		JsonResponse jr;
		if (oldJob!=null 
				&& oldJob.getStatus()!=QStatus.ERROR 
				&& oldJob.getStatus()!=QStatus.CANCELLED) {
			job = oldJob;
			
			// Done?
			if (job.getStatus()==QStatus.DONE) {
				Object r = oldJob.getResult();
				jr = new JsonResponse(req, r);
				return jr;			
			}
		} else {
			// Save this new job
			job = dataLayer.saveJob(job);			
		}
				
		// wait for it
		jr = new JsonResponse(req, new ArrayMap(
				"actor", actorName,
				"component", component,
				"id", job.getId(),
				"status", job.getStatus()
				));
		return jr;
	}
	
	protected String actorName;
	/**
	 * This should match up with the class, 
	 * e.g. component="blend", class=BlendServlet
	 */
	protected String component;
	/**
	 * slug (after actor and op)
	 */
	protected String slug;
	protected User actor;
	protected String type;
	protected IDataLayer dataLayer;
	protected String defaultActorName;
	
	/**
	 * Call this to setup slug, actor, actorName
	 * @param req
	 */
	protected void init(WebRequest req) {
		dataLayer = DataLayerFactory.get();
		String[] bits = req.getSlugBits();
		if (bits.length<2) {
			throw new WebEx.E40X(400, req.getRequestUrl());
		}
		// op (which we should know)
		component = bits[0];		
		// actor
		actorName = bits[1];
		if ("default".equals(actorName)) {
			assert defaultActorName != null : this;
			actorName = defaultActorName;
		}
		if (Utils.isBlank(actorName)) {
			throw new WebInputException("Missing actor-name -- use the path pattern /actor/method/other-stuff");
		}
		actor = dataLayer.getCreateUser(new Id(KKind.User, actorName));
		// slug (after actor and op)
		StringBuilder sb = new StringBuilder();
		for(int i=2; i<bits.length; i++) {
			sb.append(bits[i]);
			sb.append("/");
		}
		if (sb.length() != 0) {
			StrUtils.pop(sb, 1);
			slug = sb.toString();
		}
		String path = req.getRequestPath();
		type = FileUtils.getType(path);		
		
		
	}

	public void doGet(WebRequest webRequest) throws Exception {
		doPost(webRequest);
	}
	
	public abstract void doPost(WebRequest webRequest) throws Exception;

}
