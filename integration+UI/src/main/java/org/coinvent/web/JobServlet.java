package org.coinvent.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.coinvent.data.DataLayerFactory;
import org.coinvent.data.IJob;
import org.coinvent.data.Id;

import com.winterwell.utils.web.WebUtils2;

import winterwell.utils.TodoException;
import winterwell.utils.containers.ArrayMap;
import winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;

/**
 * 
 * @author daniel
 *
 */
public class JobServlet extends AServlet {

	@Override
	public void doPost(WebRequest req) throws Exception {
		init(req);			
		
		// A specific job?
		if (slug!=null) {
			IJob job = dataLayer.getJob(new Id(slug));
			
			// TODO cancel?!
			if (req.actionIs("delete") || "DELETE".equals(req.getRequest().getMethod())) {
				throw new TodoException("cancel "+job);
			}
			
			Map cargo = new ArrayMap(
					"job", new ArrayMap(
							"id", job.getId(),
							"status", job.getStatus().isFinished()? "closed":"open",
							"qstatus", job.getStatus()
			));
			JsonResponse jr = new JsonResponse(req, cargo);
			WebUtils2.sendJson(jr, req);	
		}
		
		// List open jobs
		List<Id> jobs = dataLayer.getUserJobs(actor.getId());		
		List<Map> jobs2 = new ArrayList();
		for (Id id : jobs) {
			jobs2.add(new ArrayMap("id", id, "status", "open"));
		}
		Map cargo = new ArrayMap(
			"jobs", jobs2
		);
		JsonResponse jr = new JsonResponse(req, cargo);
		WebUtils2.sendJson(jr, req);
	}

}
