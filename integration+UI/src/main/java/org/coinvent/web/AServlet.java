package org.coinvent.web;

import java.io.IOException;

import winterwell.web.app.WebRequest;

/**
 * Base class for servlets.
 * @author Daniel
 *
 */
public abstract class AServlet {


	public void doGet(WebRequest webRequest) throws Exception {
		doPost(webRequest);
	}
	
	public abstract void doPost(WebRequest webRequest) throws Exception;

}
