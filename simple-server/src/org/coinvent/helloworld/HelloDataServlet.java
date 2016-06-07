package org.coinvent.helloworld;

import java.io.IOException;

import org.coinvent.IServlet;

import com.winterwell.utils.containers.ArrayMap;
import com.winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;

import com.winterwell.utils.web.WebUtils2;

/**
 * Say hello when called. Try it out at: http://localhost:8300/helloworld/helloData.json
 * @author daniel
 *
 */
public class HelloDataServlet implements IServlet {

	@Override
	public void doPost(WebRequest webRequest) throws IOException {
		// send back some data
		ArrayMap cargo = new ArrayMap("greeting", "Salutations!");
		JsonResponse json = new JsonResponse(webRequest, cargo);
		WebUtils2.sendJson(json, webRequest);
	}

}
