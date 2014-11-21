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

import com.winterwell.utils.io.CSVReader;
import com.winterwell.utils.io.CSVWriter;
import com.winterwell.utils.io.FileUtils;

/**
 * Hack class to do Mouse-Fish, Octo-Zebra, etc.
 * Uses files/chimera/animals.csv for its facts
 * @author daniel
 *
 */
public class ChimeraActorBuggy extends ACoinvent {

	
	public static void main(String[] args) {
	}
	@Override
	public BlendDiagram doBase(BlendDiagram bd) {
		// common base animal? But not actually used
		return bd;
	}

	@Override
	public BlendDiagram doBlend(BlendDiagram bd) {
		// NB weaken will lose the name info for one of the animals, so grab it now.
		String animal1 = getAnimal(bd.input1);
		String animal2 = getAnimal(bd.input2);
		String chimera = animal1+'-'+animal2;
		
		bd = doWeaken(bd);
		
		Mapping map1 = new Mapping(new ArrayMap(animal1, chimera));
		Mapping map2 = new Mapping(new ArrayMap(animal2, chimera));
		Concept input1b = applyMap(map1, bd.input1);
		Concept input2b = applyMap(map2, bd.input2);

		String both = input1b.getText()+"\n"+input2b.getText();
		List<String> blend = new ArrayList();
		for(String line : StrUtils.splitLines(both)) {
			if (line.contains(chimera)) blend.add(line);
		}

		String csv = StrUtils.join(blend, "\n");
		CSVReader csvr = new CSVReader(new StringReader(csv), ',', '"', '#');
		Map<String,String> verb2value = new HashMap();
		for (String[] triple : csvr) {
			if (triple.length<3) continue;
			String verb = triple[1];
			String value = triple[2];
			verb2value.put(verb, value);			
		}
		// name the beast
		verb2value.put("name", StrUtils.toTitleCase(animal1)+'-'+StrUtils.toTitleCase(animal2));
		
		BlendDiagram blended = new BlendDiagram(bd);
		blended.input1_blend = map1;
		blended.input2_blend = map2;
		// HACK send back the concept in json 'cos that's a bit easier to use in the browser
		blended.blend = new Concept(JSON.toString(verb2value));
		return blended;
	}

	private String getText(Concept input2) {
		return input2.getText();
	}
	
	/**
	 * Assumes the file?conceptname url format (as suggested by DOL)
	 * @param input1
	 * @return name of animal from input1 url
	 */
	private String getAnimal(Concept input1) {
		int i = input1.getUrl().indexOf('?');
		if (i==-1) {
			// oh dear -- look for X name Y ??
			throw new TodoException(input1);
		}
		return input1.getUrl().substring(i+1);
	}
	private Concept applyMap(Mapping map, Concept concept) {
		String[] lines = StrUtils.splitLines(concept.getText());
		for (int i = 0; i < lines.length; i++) {
			for(String key : map.keySet()) {
				lines[i] = lines[i].replace(key, key);
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
		try {
			Map jobj = (Map) JSON.parse(concept.getText());
			String name = (String) jobj.get("name");
			if (name!=null) return name;
		} catch(Exception ex) {
			// oh well
			System.out.println(ex);
		}
		try {
			CSVReader csvr = new CSVReader(new StringReader(concept.getText()), ',', '"', '#');
			for (String[] line : csvr) {
				if (line.length<3) continue;
				if (line[1].equals("name")) return line[2];
			}
		} catch(Exception ex) {
			// oh well
			System.out.println(ex);
		}
		return "";
	}
	@Override
	public Score doScore(Concept concept, List<Concept> models, String metric) {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * This performs a dumb algorithm: assume same-verb (aka predicate) => conflict.
	 * So where we have conflict, pick a line at random to discard. 
	 */
	@Override
	public BlendDiagram doWeaken(BlendDiagram bd) {
		// Randomly drop conflicting sentences
		BlendDiagram weakened = null; // new BlendDiagram(bd);
				
		String animal1 = getAnimal(bd.input1);
		String animal2 = getAnimal(bd.input2);
		// Remove conflicts
		// ...collect verbs
		CSVReader csvr1 = new CSVReader(new StringReader(bd.input1.getText()), '	', '"', '#');
		Map<String,String[]> verb2row1 = new HashMap();
		for (String[] triple : csvr1) {
			if (triple.length<3) continue;
			if ( ! animal1.equals(triple[0])) continue;
			String verb = triple[1];
			verb2row1.put(verb, triple);
		}
		CSVReader csvr2 = new CSVReader(new StringReader(bd.input2.getText()), ',', '"', '#');
		Map<String,String[]> verb2row2 = new HashMap();
		for (String[] triple : csvr2) {
			if (triple.length<3) continue;
			if (animal2.equals(triple[0])) continue;
			String verb = triple[1];
			verb2row2.put(verb, triple);
		}
		
		// same verb in both concepts? pick one to keep
		for (Object verb : verb2row1.keySet().toArray()) {
			if ( ! verb2row2.containsKey(verb)) continue;
			if (Utils.getRandomChoice(0.5)) {
				verb2row1.remove(verb);				
			} else {
				verb2row2.remove(verb);				
			}
		}
		// weaker now
		String c1 = CSVWriter.writeToString(verb2row1.values());
		weakened.input1 = new Concept(c1);
		String c2 = CSVWriter.writeToString(verb2row2.values());
		weakened.input2 = new Concept(c2);
		
		return weakened;
	}

	
}
