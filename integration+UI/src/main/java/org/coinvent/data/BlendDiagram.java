package org.coinvent.data;

import com.winterwell.utils.ReflectionUtils;

public class BlendDiagram {
	
	/**
	 * Optional: url for this object itself, e.g. as a DOL file.
	 */
	public String url;
	
	public BlendDiagram(BlendDiagram bd) {
		ReflectionUtils.shallowCopy(bd, this);
	}
	
	public BlendDiagram() {
	}
	/**
	 * owl (Manchester format) | casl | rdfs (Turtle triple format)
	 */
	public String format;
	/**
	 * The (normally computed) shared base for input1 and input2
	 */
	public Concept base;
	/**
	 * The shared common ontology -- providing "domain standard" axioms.
	 */
	public Concept commonBase;
	public Concept blend;
	public Mapping base_input1;
	public Mapping base_input2;
	public Mapping input1_blend;
	public Mapping input2_blend;
	public Concept input1;
	public Concept input2;
	
}
