package org.coinvent.impl.chimera;

import java.io.InputStream;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.coinvent.actor.ACoinvent;
import org.coinvent.actor.IBaseActor;
import org.coinvent.actor.IBlendActor;
import org.coinvent.actor.ICoinvent;
import org.coinvent.actor.IConsistencyActor;
import org.coinvent.data.BlendDiagram;
import org.coinvent.data.Concept;
import org.coinvent.data.Mapping;
import org.coinvent.data.ProofResults;
import org.coinvent.data.Score;
import org.coinvent.data.Sentence;
import org.coinvent.impl.dumb.DumbActor;
import org.eclipse.jetty.util.ajax.JSON;

import winterwell.utils.Printer;
import winterwell.utils.StrUtils;
import winterwell.utils.TodoException;
import winterwell.utils.Utils;
import winterwell.utils.containers.ArrayMap;
import winterwell.utils.containers.Pair;

import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.rdf.model.ResIterator;
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.util.FileManager;
import com.winterwell.utils.io.CSVReader;
import com.winterwell.utils.io.FileUtils;

/**
 * Hack class to do Mouse-Fish, Octo-Zebra, etc.
 * @author daniel
 *
 */
public class ChimeraActor extends ACoinvent {

	
	public static void main(String[] args) {
	}
	@Override
	public BlendDiagram doBase(BlendDiagram bd) {
		// common base animal? But not actually used
		return bd;
	}

	@Override
	public BlendDiagram doBlend(BlendDiagram bd) {
		String animal1 = getAnimal(bd.input1);
		String animal2 = getAnimal(bd.input2);
		String chimera = animal1+'-'+animal2;
		Mapping map1 = new Mapping(new ArrayMap(animal1, chimera));
		Mapping map2 = new Mapping(new ArrayMap(animal2, chimera));
		Concept input1b = applyMap(map1, bd.input1);
		Concept input2b = applyMap(map2, bd.input2);

		String both = input1b.getText()+"\n"+input2b.getText();
		List<String> blend = new ArrayList();
		for(String line : StrUtils.splitLines(both)) {
			if (line.contains(chimera)) blend.add(line);
		}

		// TODO handle conflicts
		String csv = StrUtils.join(blend, "\n");
		CSVReader csvr = new CSVReader(new StringReader(csv), ',', '"', '#');
		Map<String,String> verb2value = new HashMap();
		for (String[] triple : csvr) {
			if (triple.length<3) continue;
			String verb = triple[1];
			String value = triple[2];
			String old = verb2value.put(verb, value);
			if (old!=null) {
				if (Utils.getRandomChoice(0.5)) {
					verb2value.put(verb, old);
				}
			}
		}
		verb2value.put("name", StrUtils.toTitleCase(animal1)+'-'+StrUtils.toTitleCase(animal2));
		
		BlendDiagram blended = new BlendDiagram(bd);
		blended.input1_blend = map1;
		blended.input2_blend = map2;
		// HACK send back json instead of .csv
		blended.blend = new Concept(JSON.toString(verb2value));
		return blended;
	}

	private String getText(Concept input2) {
		return input2.getText();
	}
	private String getAnimal(Concept input1) {
		int i = input1.getUrl().indexOf('?');
		return input1.getUrl().substring(i+1);
	}
	private Concept applyMap(Mapping map, Concept concept) {
		String[] lines = StrUtils.splitLines(concept.getText());
		for (int i = 0; i < lines.length; i++) {
			for(String key : map.keySet()) {
				lines[i] = lines[i].replace(key, map.get(key));
				lines[i] = lines[i].replace(StrUtils.toTitleCase(key), StrUtils.toTitleCase(map.get(key)));
			}
		}
		String text = StrUtils.join(lines, "\n");
		return new Concept(text);
	}
	@Override
	public ProofResults doTestConsistency(Concept concept, Sentence goal) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Object doGenerateModel(Concept concept) {
		List<String> facts = new ArrayList();
		// name
		String name = Utils.getRandomMember(Arrays.asList("Alice Andrew Betty Boris Cleo Colin Debbie David Emily Eric".split(" ")));
		boolean female = Arrays.asList("Alice Betty Cleo Debbie Emily".split(" ")).contains(name);
		String pronoun = female? "She" : "He"; 
		// age
		int age = 1 + Utils.getRandom().nextInt(10);
		String juvy = age<3? "juvenile" : "adult";
		facts.add(name+" is a "+age+" year old "+juvy+" "+getName(concept)+".");
		// cute fact
		String cf = Utils.getRandomMember(Arrays.asList(new String[]{
			pronoun+" likes to eat marshmallows.",
			pronoun+" can often be found basking in the early morning sun."
		}));
		facts.add(cf);
		
		// HACK send back plain text instead of .csv
		String text = StrUtils.join(facts, " ");
		return new Concept(text);
	}

	private String getName(Concept concept) {
		// HACK role with the json hack from blend
		Map jobj = (Map) JSON.parse(concept.getText());
		String name = (String) jobj.get("name");
		if (name!=null) return name;
//		CSVReader csvr = new CSVReader(new StringReader(concept.getText()), ',', '"', '#');
//		for (String[] line : csvr) {
//			if (line.length<3) continue;
//			if (line[1].equals("name")) return line[2];
//		}
		return "";
	}
	@Override
	public Score doScore(Concept concept, List<Concept> models, String metric) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public BlendDiagram doWeaken(BlendDiagram diagram) {
		// Randomly drop conflicting sentences
		BlendDiagram weakened = new BlendDiagram(diagram);
		Set<Pair<Integer>> confictSetLines = new HashSet();
		return null;
	}

	
}
