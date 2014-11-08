package org.coinvent.dumb;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;

import org.coinvent.data.BlendDiagram;
import org.coinvent.data.Concept;
import org.coinvent.web.IBaseActor;
import org.coinvent.web.IBlendActor;
import org.coinvent.web.ICoinvent;

import winterwell.utils.StrUtils;
import winterwell.web.fields.MissingFieldException;

public class DumbActor implements ICoinvent, IBaseActor, IBlendActor {

	@Override
	public IBaseActor getBaseActor() {
		return this;
	}
	
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
	public IBlendActor getBlendActor() {
		return this;
	}

}
