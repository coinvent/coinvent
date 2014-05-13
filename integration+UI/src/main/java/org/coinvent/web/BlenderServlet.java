package org.coinvent.web;

import java.io.IOException;
import java.util.Arrays;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.coinvent.data.DataLayerFactory;
import org.coinvent.data.IJob;

import com.winterwell.utils.threads.Actor;

import creole.data.XId;
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
		Object actor = DataLayerFactory.get().getUser(new XId(actorName,"coinvent"));
		// concept / job
		String type = bits[1];
		
		
		// my theory
		String theoryName = bits.length>0? bits[1] : null; 
		Object theory = DataLayerFactory.get().getConcept(new XId(actorName+"__"+theoryName+"@coinvent"));
		// TODO someone else's theory

		jr = new JsonResponse(r, null);
		
		if (r.getAction()!=null) {
			doAction(r);
		}
		
		// send back json		
		WebUtils2.sendJson(jr, r);
	}

	void doAction(WebRequest r) {
		
	}

}



