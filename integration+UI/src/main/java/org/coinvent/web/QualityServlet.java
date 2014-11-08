package org.coinvent.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.coinvent.data.Concept;
import org.coinvent.data.DataLayerFactory;
import org.coinvent.data.IJob;
import org.coinvent.data.Id;
import org.coinvent.data.Job;

import com.winterwell.utils.web.WebUtils2;

import winterwell.utils.TodoException;
import winterwell.utils.containers.ArrayMap;
import winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;
import winterwell.web.fields.AField;
import winterwell.web.fields.ListField;

/**
 * 
 * @author daniel
 *
 */
public class QualityServlet extends AServlet {

	static ConceptField CONCEPT = new ConceptField("concept");
	static ListField<Concept> MODELS = new ListField("models", new ConceptField("model"));
	
	@Override
	public void doPost(WebRequest req) throws Exception {
		init(req);			
//		Parameters:
//		    lang: owl|casl
//		    concept: {concept}
//		    models: {concept[]}
//		    metric: {?string} Optional name of a metric to score against.
		Concept concept = req.getRequired(CONCEPT);
		List<Concept> models = req.get(MODELS);
		
		String metric = (String) req.get(new AField("metric"));
		if (metric==null && ! AgentRegistry.recognise(actorName)) metric = "opinion";
		
		Job job = new Job(actor, component, req);
		IJob stored = dataLayer.getJob(job.getId());
		
		// It's a new request
		if (stored==null) {
			dataLayer.saveJob(job);
		}
		if (stored==null || ! job.getStatus().isFinished()) {
			// slow response
			req.getResponse().setStatus(202);
			ArrayMap cargo = new ArrayMap("job", 
						new ArrayMap(
								"id", job.getId()),
								"status", job.getStatus().isFinished()? "closed":"open",
								"qstatus", job.getStatus()
								);	
			JsonResponse jr = new JsonResponse(req, cargo);
			WebUtils2.sendJson(jr, req);
			return;
		}
		
		// Do we have an answer?
		Object result = job.getResult();
		
		Map cargo = new ArrayMap(
			"metric", metric,
			"score", Double.valueOf(result.toString())
		);
		JsonResponse jr = new JsonResponse(req, cargo);
		WebUtils2.sendJson(jr, req);
	}

}
