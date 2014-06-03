package org.coinvent.web;

import winterwell.web.app.WebRequest;

/**
 * Given a Concept, find examples

Default implementation: Manual   
Default end point: http://coinvent.soda.sh:8400/model/$user_name

Parameters:

 - lang: owl|casl
 - concept: {concept} 
 - cursor: {?url} For requesting follow-on results.
   
Response-cargo: 
	
	{
		models: {concept[]} 
	}
 * @author daniel
 *
 */
public class ModelServlet extends AServlet {

	@Override
	public void doPost(WebRequest webRequest) throws Exception {
		// TODO Auto-generated method stub
		
	}

}
