package org.coinvent.web;

import org.coinvent.data.BlendDiagram;
import org.coinvent.data.Concept;
import org.coinvent.data.DataLayerFactory;
import org.coinvent.data.FileDataLayer;
import org.coinvent.data.IJob;
import org.coinvent.data.Id;
import org.coinvent.data.Job;
import org.coinvent.data.Mapping;

import com.winterwell.utils.threads.ATask.QStatus;
import com.winterwell.utils.web.WebUtils2;

import winterwell.utils.Key;
import winterwell.utils.Printer;
import winterwell.utils.TodoException;
import winterwell.utils.containers.ArrayMap;
import winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;
import winterwell.web.fields.AField;

/**
 * Given 2 Concepts, compute a common base Concept

Default implementation: HDTP   
Default end point: http://coinvent.soda.sh:8400/base/hdtp

Parameters:

 - lang: owl|casl
 - input1: {concept} 
 - input2: {concept}
 - base: {?concept}
 - base_input1: {?mapping} from base to input1
 - base_input2: {?mapping} from base to input1
 - cursor: {?url} For requesting follow-on results.
 
Response-cargo: 
	
	{
		base: {concept} which is a common base for input1 and input2,
		base_input1: {mapping} from base to input1,
		base_input2: {mapping} from base to input2
	}
 * 
 * See https://github.com/coinvent/coinvent/blob/master/architecture.md#components
 * @author daniel
 * @testedby {@link BaseServletTest}
 */
public class BaseServlet extends AServlet {

	public BaseServlet() {
		super();
		defaultActorName = "dumb";
	}
	
	@Override
	public void doPost(WebRequest req) throws Exception {
		Printer.out(req);
		init(req);						
		
		String lang = req.get(BlendServlet.LANG);
		Concept input1 = req.getRequired(BlendServlet.INPUT1);
		Concept input2 = req.getRequired(BlendServlet.INPUT2);
		Concept base = req.get(BlendServlet.BASE);
		Mapping base_input1 = req.get(BlendServlet.BASE_INPUT1);
		Mapping base_input2 = req.get(BlendServlet.BASE_INPUT2);

		BlendDiagram bd = new BlendDiagram();
		bd.input1 = input1;
		bd.input2 = input2;
		bd.format = lang;
		bd.base = base;
		bd.base_input1 = base_input1;
		bd.base_input2 = base_input2;
		
		// A fast method? HETS?
		if (AgentRegistry.recognise(actorName)) {
			IBaseActor codeActor = AgentRegistry.getActor(IBaseActor.class, actorName);
			
			BlendDiagram based = codeActor.doBase(bd);			
			
			JsonResponse jr = new JsonResponse(req, new ArrayMap(
					"actor", actorName,
					"component", component,
					"status", QStatus.DONE,
					JsonResponse.JSON_CARGO, based
					));
			WebUtils2.sendJson(jr, req);
			return;
		}
		
		// Interactive/manual
		JsonResponse jr = doSlow(req);
				
		// send back json		
		WebUtils2.sendJson(jr, req);
	}

}
