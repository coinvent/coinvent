package org.coinvent.web;

import org.coinvent.data.Concept;

import winterwell.utils.Key;
import winterwell.web.fields.AField;

/**
 * Pass concepts around. By url (iri) if possible
 * @author daniel
 *
 */
public class ConceptField extends AField<Concept> {

	public ConceptField(String name) {
		super(name);
	}
	
	@Override
	public Concept fromString(String v) throws Exception {
		// TODO Auto-generated method stub
		return super.fromString(v);
	}
	
	@Override
	public String toString(Concept c) {
		if (c.iri!=null) return c.iri;
		return c.contents;
	}

}
