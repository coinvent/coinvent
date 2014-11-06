package org.coinvent.data;

import org.coinvent.Coinvent;

import winterwell.utils.StrUtils;
import winterwell.utils.web.WebUtils;
import winterwell.web.FakeBrowser;

public class Concept {

	public Id oxid;
	public Id xid;
	public String lang;
	public String iri;
	private String contents;

	public String getContents() {
		if (contents==null) {
			if (iri==null) return null;
			if (WebUtils.RELATIVE_URL_REGEX.matcher(iri).matches()) {
				// lookup the file
				
			}
			FakeBrowser fb = new FakeBrowser();
			contents = fb.getPage(iri);
		}
		return contents;
	}
	@Override
	public String toString() {
		return "Concept [xid=" + xid + ", lang=" + lang + ", iri=" + iri
				+ ", contents=" + contents + "]";
	}

	public Concept() {		
	}
	
	public Concept(String contents) {
		this.oxid = new Id(KKind.User, "unknown");
		this.xid = getId(oxid, StrUtils.md5(contents));
		setContents(contents);
	}
	
	public Concept(User owner, Id concept) {
		this.xid = concept;
		this.oxid = owner.getId();
	}

	public static Id getId(Id user, String conceptName) {
		return new Id(user, KKind.Concept, conceptName);
	}
	
	public void setContents(String contents) {
		this.contents = contents;
	}

}
