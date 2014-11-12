package org.coinvent.web;

import java.net.URI;

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
	private static final long serialVersionUID = 1L;

	public ConceptField(String name) {
		super(name);
	}
	
	@Override
	public Concept fromString(String v) throws Exception {
		// Is it a url?
		if (WebUtils.URL_REGEX.matcher(v).matches()) {
			Concept concept = new Concept();
			concept.setUrl(v);
			return concept;
		}
		if (WebUtils.RELATIVE_URL_REGEX.matcher(v).matches()) {
			Concept concept = new Concept();
			URI url = WebUtils.resolveUri(Coinvent.app.getConfig().baseUrl, v);
			concept.setUrl(url.toString());
			return concept;
		}
		// treat as the thing itself
		Concept concept = new Concept(v);
		return concept;
	}
	
	@Override
	public String toString(Concept c) {
		if (c.getUrl()!=null) return c.getUrl();
		return c.getText();
	}

}
