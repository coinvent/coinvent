package org.coinvent.web;

import org.coinvent.Coinvent;
import org.coinvent.data.Concept;

import winterwell.utils.Key;
import winterwell.utils.web.WebUtils;
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
		// Is it a url?
		if (WebUtils.URL_REGEX.matcher(v).matches()) {
			Concept concept = new Concept();
			concept.url = v;
			return concept;
		}
		if (WebUtils.RELATIVE_URL_REGEX.matcher(v).matches()) {
			Concept concept = new Concept();
			concept.url = Coinvent.app.getConfig().baseUrl+"/file/"+v;
			return concept;
		}
		// treat as the thing itself
		Concept concept = new Concept(v);
		return concept;
	}
	
	@Override
	public String toString(Concept c) {
		if (c.url!=null) return c.url;
		return c.getText();
	}

}
