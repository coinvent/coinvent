package org.coinvent.web;

import java.io.IOException;
import java.util.Arrays;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.coinvent.actor.IBlendActor;
import org.coinvent.data.BlendDiagram;
import org.coinvent.data.Concept;
import org.coinvent.data.DataLayerFactory;
import org.coinvent.data.FileDataLayer;
import org.coinvent.data.IDataLayer;
import org.coinvent.data.IJob;
import org.coinvent.data.Id;
import org.coinvent.data.Job;
import org.coinvent.data.Mapping;

import com.google.gson.Gson;
import com.winterwell.utils.threads.Actor;
import com.winterwell.utils.threads.ATask.QStatus;
import com.winterwell.utils.web.WebUtils2;

import winterwell.utils.Key;
import winterwell.utils.TodoException;
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
 * Blend stuff!
 * 
 * Parameters:

lang: owl|casl
input1: {concept}
input2: {concept}
base: {concept}
base_input1: {mapping} from base to input1
base_input2: {mapping} from base to input1
Response-cargo:

{
    blend: {concept} which is a blend of input1 and input2,
    input1_blend: {mapping} from input1 to blend,
    input2_blend: {mapping} from input2 to blend
}
 * 
 * @author daniel
 *
 */
public class BlendServlet extends AServlet {

	static final Key<String> LANG = new AField("lang");
	static final AField<Concept> INPUT1 = new ConceptField("input1");
	static final AField<Concept> INPUT2 = new ConceptField("input2");
	static final AField<Concept> BASE = new ConceptField("base");
	static final AField<Mapping> BASE_INPUT1 = new MappingField("base_input1");
	static final AField<Mapping> BASE_INPUT2 = new MappingField("base_input2");
	private static final String COMPONENT = "blend";
	
	private JsonResponse jr;
	private FileDataLayer dataLayer = (FileDataLayer) DataLayerFactory.get();

	public BlendServlet() {
		defaultActorName = "dumb";
	}
	
	@Override
	public void doPost(WebRequest req) throws Exception {
		init(req);						
		
		// A fast method? HETS?
		if (AgentRegistry.recognise(actorName)) {
			IBlendActor codeActor = AgentRegistry.getActor(IBlendActor.class, actorName);
			
			BlendDiagram based = codeActor.doBlend(bd);			
			
			JsonResponse jr = new JsonResponse(req, based);
			jr.put("actor", actorName);
			jr.put("component", component);
			jr.put("status", QStatus.DONE);
					
			WebUtils2.sendJson(jr, req);
			return;
		}
		
		// Interactive/manual
		jr = doSlow(req);
				
		// send back json		
		WebUtils2.sendJson(jr, req);
	}


}



