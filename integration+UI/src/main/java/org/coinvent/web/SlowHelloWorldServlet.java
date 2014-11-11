package org.coinvent.web;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Queue;
import java.util.concurrent.ConcurrentHashMap;

import com.winterwell.utils.threads.Actor;
import com.winterwell.utils.threads.Actor.Packet;
import com.winterwell.utils.web.WebUtils2;

import winterwell.utils.Utils;
import winterwell.utils.containers.ArrayMap;
import winterwell.utils.time.Dt;
import winterwell.utils.time.TUnit;
import winterwell.web.FakeBrowser;
import winterwell.web.WebEx;
import winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;
import winterwell.web.fields.AField;

/**
 * Say hello -- slowly. Example of the actor/queue approach.
 * @author Daniel
 *
 */
public class SlowHelloWorldServlet extends AServlet{

	AField<String> JOB_ID = new AField("jobid");
	/**
	 * A url to call when the task is done (or fails).
	 * <p>
	 * NB: we don't use "callback" as the parameter because this would conflict with a common jsonp setup.
	 */
	AField<String> ON_COMPLETE = new AField("oncomplete");
	
	/**
	 * To simulate a slow process, this will sit on requests for a bit before processing them.
	 */
	static Actor<HelloJob> slowHelloActor = new SlowHelloActor();
	
	@Override
	public void doPost(WebRequest state) throws IOException {
		// Is this a fresh request, or a job query?
		String jobId = state.get(JOB_ID);
		if (jobId!=null) {
			// send them an update on the job
			doSendJobUpdate(jobId, state);
			return;
		}
		
		// A fresh request!
		HelloJob job = new HelloJob();
		// ...but because it takes some time, instead of sending it now, we're going to put
		// it in a separate thread.
		slowHelloActor.send(job);
		jobs.put(job.id, job);
		
		// Send json output about the job. This will output:
//			{	success: true,
//				jobid: {string}
//			}
		JsonResponse jr = new JsonResponse(state, null);
		jr.put(JOB_ID, job.id);
		WebUtils2.sendJson(jr, state);
	}

	/**
	 * Store jobs. Obviously a real system would not store jobs like this.
	 */
	static Map<String,HelloJob> jobs = new ConcurrentHashMap();
	
	/**
	 * The caller has asked for this job's status and output (if its ready).
	 * @param jobId
	 * @param state
	 * @throws IOException
	 */
	private void doSendJobUpdate(String jobId, WebRequest state) throws IOException {
		HelloJob job = jobs.get(jobId);
		if (job==null) throw new WebEx(404, "Unrecognised jobid: "+jobId);
		String cargo = job.result==null? "Please wait longer..." : job.result;
		JsonResponse jr = new JsonResponse(state, cargo);
		jr.put(JOB_ID, jobId);
		WebUtils2.sendJson(jr, state);
	}
	
}


/** Someone has requested a hello
 */
class HelloJob {
	String result;
	String callback;
	String id = Utils.getRandomString(8);
}

/**
 * An Actor which runs in its own thread, and just says "Hello World!"
 * -- but not until it's though about it for a while. 
 * @author Daniel
 */
class SlowHelloActor extends Actor<HelloJob> {
	 
	@Override
	protected void receive(HelloJob job, Actor sender) {
		// Pause a bit
		Utils.sleep(new Dt(10, TUnit.SECOND));
		// Do the job
		job.result = "Hello World!";
		// Make the callback
		if (job.callback==null) return; 
		// The response envelope
		ArrayMap response = new ArrayMap(
			"jobid", job.id,
			"success", true,
			"cursor", null, // No next value
			"cargo", job.result,
			"messages", Arrays.asList(
					new ArrayMap("type", "info", "text", "The HelloJob has finished :)"))
		);
		FakeBrowser fb = new FakeBrowser();
		fb.getPage(job.callback, response);
	}
			
}