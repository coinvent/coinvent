package org.coinvent.dumb;

import java.util.Arrays;
import java.util.HashSet;

import org.coinvent.data.BlendDiagram;
import org.coinvent.data.Concept;
import org.coinvent.web.IBaseActor;
import org.coinvent.web.ICoinvent;

import winterwell.utils.StrUtils;

public class DumbActor implements ICoinvent, IBaseActor {

	@Override
	public IBaseActor getBaseActor() {
		return this;
	}
	
	@Override
	public BlendDiagram doBase(BlendDiagram bd) {
		// ID mapping
		// Keep common sentences
		String[] lines1 = StrUtils.splitLines(bd.input1.getContents());
		String[] lines2 = StrUtils.splitLines(bd.input2.getContents());
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

}
