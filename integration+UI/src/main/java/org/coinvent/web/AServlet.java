package org.coinvent.web;

import java.io.IOException;
import java.util.Arrays;

import org.coinvent.data.DataLayerFactory;
import org.coinvent.data.User;


import winterwell.utils.StrUtils;
import winterwell.utils.io.FileUtils;
import winterwell.web.WebEx;
import winterwell.web.app.WebRequest;

/**
 * Base class for Coinvent servlets.
 * @author Daniel
 *
 */
public abstract class AServlet {

	protected String actorName;
	/**
	 * This should match up with the class, 
	 * e.g. opName="blender", class=BlenderServlet
	 */
	protected String opName;
	/**
	 * slug (after actor and op)
	 */
	protected String slug;
	protected User actor;
	protected String type;
	
	/**
	 * Call this to setup slug, actor, actorName
	 * @param req
	 */
	protected void init(WebRequest req) {
		String[] bits = req.getSlugBits();
		if (bits.length<2) {
			throw new WebEx.E40X(400, req.getRequestUrl());
		}
		// op (which we should know)
		opName = bits[0];		
		// actor
		actorName = bits[1];
		actor = DataLayerFactory.get().getUser(new Id(actorName,"coinvent"));
		// slug (after actor and op)
		StringBuilder sb = new StringBuilder();
		for(int i=2; i<bits.length; i++) {
			sb.append(bits[i]);
			sb.append("/");
		}
		if (sb.length() != 0) {
			StrUtils.pop(sb, 1);
			slug = sb.toString();
		}
		String path = req.getRequestPath();
		type = FileUtils.getType(path);		
	}

	public void doGet(WebRequest webRequest) throws Exception {
		doPost(webRequest);
	}
	
	public abstract void doPost(WebRequest webRequest) throws Exception;

}
