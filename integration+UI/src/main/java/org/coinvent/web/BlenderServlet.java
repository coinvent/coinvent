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

	private static final Key<String> LANG = new AField("lang");
	private static final Key<Concept> INPUT1 = new ConceptField("input1");
	private static final Key<Concept> INPUT2 = new ConceptField("input2");
	private static final Key<Concept> BASE = new ConceptField("base");
	private static final Key<Mapping> BASE_INPUT1 = new MappingField("base_input1");
	private static final Key<Mapping> BASE_INPUT2 = new MappingField("base_input2");
	
	private JsonResponse jr;
	private FileDataLayer dataLayer = (FileDataLayer) DataLayerFactory.get();

	@Override
	public void doPost(WebRequest req) throws Exception {
		init(req);						
		
		String lang = req.get(LANG);
		Object theory = dataLayer.getConcept(new XId(actorName+"__"+slug+"."+type+"@coinvent"));
		// TODO someone else's theory

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



