package org.coinvent.cmd;

import org.coinvent.ProcessActiveTriple.ActiveType;
import org.coinvent.HdtpRequests.HdtpRequest;
import org.coinvent.HdtpRequests.ReadType;
import org.coinvent.IServlet;
import org.coinvent.CoinventConfig;
import org.coinvent.ProcessActiveTriple;

import winterwell.utils.containers.ArrayMap;
import winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.BufferedReader;
import java.io.BufferedWriter;

import com.winterwell.utils.web.WebUtils2;

/**
 * A dummy servlet to demonstrate running a command.
 * 
 * Try: http://localhost:8300/cmd/ls.json?dir=web/static
 * 
 * @author daniel
 * 
 */
public class BlendServlet implements IServlet {

	@Override
	public void doPost(WebRequest webRequest) throws Exception {
		ArrayMap cargo = new ArrayMap();
		JsonResponse jr = new JsonResponse(webRequest, cargo);
	}

}
