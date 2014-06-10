package org.coinvent.web;

import winterwell.web.app.WebRequest;

/**
 * Given 2 Concepts, compute a common base Concept

Default implementation: HDTP   
Default end point: http://coinvent.soda.sh:8400/base/hdtp

Parameters:

 - lang: owl|casl
 - input1: {concept} 
 - input2: {concept}
 - base: {?concept}
 - base_input1: {?mapping} from base to input1
 - base_input2: {?mapping} from base to input1
 - cursor: {?url} For requesting follow-on results.
 
Response-cargo: 
	
	{
		base: {concept} which is a common base for input1 and input2,
		base_input1: {mapping} from base to input1,
		base_input2: {mapping} from base to input2
	}
 * 
 * See https://github.com/coinvent/coinvent/blob/master/architecture.md#components
 * @author daniel
 *
 */
public class BaseServlet extends AServlet {

	@Override
	public void doPost(WebRequest webRequest) throws Exception {
		// TODO Auto-generated method stub
		
	}

}
