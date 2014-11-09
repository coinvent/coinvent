package org.coinvent.impl.dumb;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;

import org.coinvent.actor.ACoinvent;
import org.coinvent.actor.IBaseActor;
import org.coinvent.actor.IBlendActor;
import org.coinvent.actor.ICoinvent;
import org.coinvent.data.BlendDiagram;
import org.coinvent.data.Concept;
import org.coinvent.data.ProofResults;
import org.coinvent.data.Score;
import org.coinvent.data.Sentence;

import winterwell.utils.StrUtils;
import winterwell.web.fields.MissingFieldException;

public class DumbActor extends ACoinvent {
	
	@Override
	public BlendDiagram doBase(BlendDiagram bd) {
		if (bd.input1==null || bd.input2==null) throw new MissingFieldException("input1","input2");
		// Identity mapping
		// Keep common sentences
		String[] lines1 = StrUtils.splitLines(bd.input1.getText());
		String[] lines2 = StrUtils.splitLines(bd.input2.getText());
		HashSet set2 = new HashSet(Arrays.asList(lines2));
		StringBuilder contents = new StringBuilder();
		for(String line : lines1) {
			if (set2.contains(line)) {
				contents.append(line);
				contents.append("\n");
			}
		}
		Concept base = new Concept(contents.toString());
		
		BlendDiagram based = new BlendDiagram(bd);
		based.base = base;
		return based;
	}

	@Override
	public BlendDiagram doBlend(BlendDiagram bd) {
		if (bd.input1==null || bd.input2==null) throw new MissingFieldException("input1","input2");
		// Identity mapping
		// Union of sentences
		String[] lines1 = StrUtils.splitLines(bd.input1.getText());
		String[] lines2 = StrUtils.splitLines(bd.input2.getText());
		ArrayList<String> union = new ArrayList(Arrays.asList(lines1));
		for(String line : lines2) {
			if ( ! union.contains(line)) {
				union.add(line);
			}
		}
		Concept blend = new Concept(StrUtils.join(union, "\n"));
		
		BlendDiagram based = new BlendDiagram(bd);
		based.blend = blend;
		return based;		
	}

	@Override
	public ProofResults doTestConsistency(Concept concept, Sentence goal) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Object doGenerateModel(Concept concept) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Score doScore(Concept concept, List<Concept> models, String metric) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public BlendDiagram doWeaken(BlendDiagram diagram) {
		// TODO Auto-generated method stub
		return null;
	}

}
