package org.coinvent.impl.conceptnet;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.eclipse.jetty.util.ajax.JSON;

import winterwell.utils.Printer;
import winterwell.utils.containers.ArrayMap;
import winterwell.utils.containers.Containers;
import winterwell.web.FakeBrowser;

/**
 * Can we convert a concept into a simple OWL class? 
 * 
 * Exploration of ConceptNet: depressingly low quality :(
 * 
 * @author daniel
 *
 */
public class Concept2OWL {

	private String term;

	public Concept2OWL(String term) {
		this.term = "/c/en/"+term.toLowerCase();
	}

	FakeBrowser fb = new FakeBrowser()
//	.setDebug(true)
	;
	
	private double minWeight = 1.0;
	
	public static void main(String[] args) {
		String term = "zebra";
//		String json = new FakeBrowser().getPage("http://conceptnet5.media.mit.edu/data/5.1/c/en/"+term);
//		Map map = (Map) JSON.parse(json);
//		Object edges = map.get("edges");

		Concept2OWL concept = new Concept2OWL(term);
		List parts = concept.getX_rel_This("PartOf", 10);
		Printer.out("PartOf", parts);
		
		List partsb = concept.getThis_rel_X("HasA", 10);
		Printer.out("HasA", partsb);
		
		List parts2 = concept.getThis_rel_X("HasProperty", 10);
		System.out.println(parts2);
		
		List egs = concept.getX_rel_This("IsA", 10);
		System.out.println(egs);
		
		List isa2 = concept.getThis_rel_X("IsA", 10);
		System.out.println(isa2);
		
		List desire = concept.getThis_rel_X("Desires", 10);
		System.out.println(desire);
		
		List cap = concept.getThis_rel_X("CapableOf", 10);
		System.out.println(cap);
		
		List loc = concept.getThis_rel_X("AtLocation", 3);
		Printer.out("AtLocation", loc);
		
		// PartOf
		
		// CapableOf
		
		// NotCapableOf
		
		// Desires
		
		// AtLocation
	}

	private List getX_rel_This(String rel, int n) {
		return get2(false, rel, n);
	}
	
	private List getThis_rel_X(String rel, int n) {
		return get2(true, rel, n);
	}
	
	List get2(boolean termIsStart, String rel, int n) {
		String json = fb.getPage("http://conceptnet5.media.mit.edu/data/5.2/search?rel=/r/"+rel+"&"+(termIsStart?"start":"end")+"="+term+"&limit="+n
				+"&minWeight="+minWeight);
		Map map = (Map) JSON.parse(json);
		List edges = Containers.asList(map.get("edges"));
		List edges2 = new ArrayList();		
		for (Object object : edges) {
			Map m = (Map) object;
			// check it is a match
			Object me = m.get(termIsStart? "start" : "end");
			if ( ! term.equals(me)) {
				continue;
			}
			Object other = m.get(termIsStart? "end" : "start");
			
			ArrayMap m2 = new ArrayMap(
					"text", other
//					,"weight", m.get("weight"),
//					"surfaceText", m.get("surfaceText")
					);
			edges2.add(m2);
		}
		return edges2;
	}
	
	List keep = Arrays.asList("text");
}
