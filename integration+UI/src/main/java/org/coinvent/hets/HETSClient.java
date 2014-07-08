package org.coinvent.hets;

import java.io.File;

import org.w3c.dom.Document;

import winterwell.utils.containers.Tree;
import winterwell.utils.web.WebUtils;
import winterwell.utils.web.XMLNode;
import winterwell.web.FakeBrowser;

/**
 * Status: emailed Qs to Christian and Mihai.
 * 
 * Big Q: Use the restful API, or the console mode?
 * 
 * https://github.com/spechub/Hets/wiki/RESTful-Interface
 * @author daniel
 *
 */
public class HETSClient {

	String server = "http://pollux.informatik.uni-bremen.de:8000";
	
	public static void main(String[] args) {
		HETSClient hc = new HETSClient();
		String url = "https://raw.githubusercontent.com/coinvent/coinvent/master/examples/houseboat/houseboat_simple.dol";

		hc.dg(url);
		
		hc.consistencyCheck(url);		
	}
	
	void dg(String url) {
		String xml = fb.getPage(server+"/dg/"+WebUtils.urlEncode(url));
		System.out.println(xml);
	}

	FakeBrowser fb = new FakeBrowser().setDebug(true);
	

	void consistencyCheck(String url) {
		String cc = fb.getPage(server+"/consistency-check/"+WebUtils.urlEncode(url));
		Tree<XMLNode> doc = WebUtils.parseXmlToTree(cc);
		System.out.println(doc);		
	}
	
//	http://pollux.informatik.uni-bremen.de:8000/dg/https%3A%2F%2Fraw.githubusercontent.com%2Fcoinvent%2Fcoinvent%2Fmaster%2Fexamples%2Fhouseboat%2Fhouseboat.dol
		
}
