package org.coinvent.web;

import java.util.Collections;

import org.coinvent.actor.IBlendActor;
import org.coinvent.actor.IModelActor;
import org.coinvent.data.BlendDiagram;
import org.coinvent.data.Concept;

import com.winterwell.utils.threads.ATask.QStatus;
import com.winterwell.utils.web.WebUtils2;

import winterwell.utils.containers.ArrayMap;
import winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;
import winterwell.web.fields.AField;

/**
 * Given a Concept, find examples

Default implementation: Manual   
Default end point: http://coinvent.soda.sh:8400/model/$user_name

Parameters:

 - lang: owl|casl
 - concept: {concept} 
 - cursor: {?url} For requesting follow-on results.
   
Response-cargo: 
	
	{
		models: {concept[]} 
	}
 * @author daniel
 *
 */
public class ModelServlet extends AServlet {

	static final AField<Concept> CONCEPT = new ConceptField("concept");
	
	public ModelServlet() {
//		defaultActorName = none possible :(;
	}
	
	@Override
	public void doPost(WebRequest req) throws Exception {
		init(req);						
		
		// A fast method? HETS?
		if (AgentRegistry.recognise(actorName)) {
			IModelActor codeActor = AgentRegistry.getActor(IModelActor.class, actorName);
			assert codeActor!=null : actorName;
			Concept concept = req.getRequired(CONCEPT);
			Object model = codeActor.doGenerateModel(concept);			
			
			JsonResponse jr = new JsonResponse(req, new ArrayMap(
					"models", Collections.singletonList(model)
					));
			jr.put("actor", actorName);
			jr.put("component", component);
			jr.put("status", QStatus.DONE);
					
			WebUtils2.sendJson(jr, req);
			return;
		}
		
		// Interactive/manual
		JsonResponse jr = doSlow(req);
				
		// send back json		
		WebUtils2.sendJson(jr, req);
	}

}
