package org.coinvent.web;

import java.io.IOException;
import java.util.Arrays;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.coinvent.data.DataLayerFactory;
import org.coinvent.data.IJob;

import com.winterwell.utils.threads.Actor;

import winterwell.utils.Utils;
import winterwell.utils.containers.ArrayMap;
import winterwell.utils.time.Dt;
import winterwell.utils.time.TUnit;
import winterwell.utils.web.WebUtils2;
import winterwell.web.FakeBrowser;
import winterwell.web.WebEx;
import winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;
import winterwell.web.fields.AField;

/**
 * Blend stuff!
 * @author daniel
 *
 */
public class BlenderServlet extends AServlet {

	private JsonResponse jr;

	@Override
	public void doPost(WebRequest r) throws Exception {
		String[] bits = r.getSlugBits();
		if (bits.length<2) {
			throw new WebEx.E40X(400, r.getRequestUrl());
		}
		// actor
		String actorName = bits[1];
		Object actor = DataLayerFactory.get().getUser(actorName);
		// concept / job
		String type = bits[1];
		
		
		// my theory
		String theoryName = bits.length>0? bits[1] : null; 
		Object theory = DataLayerFactory.get().getConcept(theoryName);
		// TODO someone else's theory

		jr = new JsonResponse(r, null);
		
		if (r.getAction()!=null) {
			doAction(r);
		}
		
		// send back json		
		WebUtils2.sendJson(jr, r);
	}

	private void doAction(WebRequest r) {
		
	}


	AField<String> JOB_ID = new AField("jobid");
	
	/**
	 * A url to call when the task is done (or fails).
	 * <p>
	 * NB: we don't use "callback" as the parameter because this would conflict with a common jsonp setup.
	 */
	AField<String> ON_COMPLETE = new AField("oncomplete");

	/**
	 * The caller has asked for this job's status and output (if its ready).
	 * @param jobId
	 * @param state
	 * @throws IOException
	 */
	private void doSendJobUpdate(String jobId, WebRequest state) throws IOException {
		IJob job = DataLayerFactory.get().getJob(jobId);
		if (job==null) throw new WebEx(404, "Unrecognised jobid: "+jobId);
		String cargo = job.getResult()==null? "Please wait longer..." : job.getResult().toString();
		JsonResponse jr = new JsonResponse(state, cargo);
		jr.put(JOB_ID, jobId);
		WebUtils2.sendJson(jr, state);
	}

}



