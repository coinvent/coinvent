package org.coinvent.impl.hets;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.w3c.dom.Document;
import org.w3c.dom.Node;

import com.winterwell.utils.web.WebUtils2;

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

//		Map<String,Node> out = hc.doCommand(url, "compute-colimit");
		
		Map<String, Node> map = hc.processDOL(url);
		Node hb = map.get("house_boat");
//		assert hb!=null : map.keySet();
		List<Node> texts = WebUtils2.xpathQuery("//Text", hb);
		for (Node node : texts) {
			String text = node.getTextContent();
			System.out.println(text);
		}
		
//		hc.consistencyCheck(url);		
	}
	
	private Map doCommand(String url, String command) {
		String xml = fb.getPage(server+"/dg/"+WebUtils.urlEncode(url)+"/"+command);
		Document doc = WebUtils.parseXml(xml);
//		System.out.println(fb.getLocation());
		System.out.println(xml);
		List<Node> nodes = WebUtils2.xpathQuery("//DGNode", xml);		
		Map name2theory = new HashMap();
		for (Node node : nodes) {
			String name = WebUtils.getAttribute("name", node);
//			Node name = node.getAttributes().getNamedItem("name");
//			String sname = name.getTextContent();
			name2theory.put(name, node);
		}
		return name2theory;
	}

	Map<String,Node> processDOL(String url) {
		String xml = fb.getPage(server+"/dg/"+WebUtils.urlEncode(url)+"/auto/full-theories");
		System.out.println(xml);
		Document doc = WebUtils.parseXml(xml);		
		System.out.println(fb.getLocation());
		List<Node> nodes = WebUtils2.xpathQuery("//DGNode", xml);		
		Map name2theory = new HashMap();
		for (Node node : nodes) {
			String name = WebUtils.getAttribute("name", node);
//			Node name = node.getAttributes().getNamedItem("name");
//			String sname = name.getTextContent();
			name2theory.put(name, node);
		}
		return name2theory;
	}

	FakeBrowser fb = new FakeBrowser().setDebug(true);
	

	void consistencyCheck(String url) {
		String cc = fb.getPage(server+"/consistency-check/"+WebUtils.urlEncode(url));
		Tree<XMLNode> doc = WebUtils.parseXmlToTree(cc);
		System.out.println(doc);		
	}
	
//	http://pollux.informatik.uni-bremen.de:8000/dg/https%3A%2F%2Fraw.githubusercontent.com%2Fcoinvent%2Fcoinvent%2Fmaster%2Fexamples%2Fhouseboat%2Fhouseboat.dol
		
}
