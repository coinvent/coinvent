package org.coinvent.web;

import java.io.IOException;
import java.util.Arrays;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.coinvent.data.Concept;
import org.coinvent.data.DataLayerFactory;
import org.coinvent.data.FileDataLayer;
import org.coinvent.data.IDataLayer;
import org.coinvent.data.IJob;
import org.coinvent.data.Mapping;

import com.winterwell.utils.threads.Actor;

import creole.data.XId;
import winterwell.utils.Key;
import winterwell.utils.TodoException;
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
public class BlenderServlet extends AServlet {

	private static final Key<String> LANG = new AField("lang");
	private static final AField<Concept> INPUT1 = new ConceptField("input1");
	private static final AField<Concept> INPUT2 = new ConceptField("input2");
	private static final AField<Concept> BASE = new ConceptField("base");
	private static final AField<Mapping> BASE_INPUT1 = new MappingField("base_input1");
	private static final AField<Mapping> BASE_INPUT2 = new MappingField("base_input2");
	
	private JsonResponse jr;
	private FileDataLayer dataLayer = (FileDataLayer) DataLayerFactory.get();

	@Override
	public void doPost(WebRequest req) throws Exception {
		init(req);						
		
		String lang = req.get(LANG);
		Concept input1 = req.getRequired(INPUT1);
		Concept input2 = req.getRequired(INPUT2);
		Concept base = req.get(BASE);
		Mapping base_input1 = req.get(BASE_INPUT1);
		Mapping base_input2 = req.get(BASE_INPUT2);
		
		// Which method? HETS?
		if (AgentRegistry.recognise(actorName)) {
			throw new TodoException("Call out to "+actorName);
		}
		
		// Interactive/manual
		// ...make a job 
		
		// ...use history?
		
		
		jr = new JsonResponse(req, null);
		
		if (req.getAction()!=null) {
			doAction(req);
		}
		
		// send back json		
		WebUtils2.sendJson(jr, req);
	}

	void doAction(WebRequest r) {
		
	}

}



