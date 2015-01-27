package org.coinvent.helloworld;

import java.io.IOException;

import org.coinvent.IServlet;

import com.winterwell.utils.web.WebUtils2;

import winterwell.utils.containers.ArrayMap;
import winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;

public class HelloDataServlet implements IServlet {

	@Override
	public void doPost(WebRequest webRequest) throws IOException {
		// send back some data
		ArrayMap cargo = new ArrayMap("greeting", "Salutations!");
		JsonResponse json = new JsonResponse(webRequest, cargo);
		WebUtils2.sendJson(json, webRequest);
	}

}
