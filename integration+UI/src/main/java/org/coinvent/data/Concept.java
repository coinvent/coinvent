package org.coinvent.data;

public class Concept {

	public Id oxid;
	public Id xid;
	public String lang;
	public String iri;
	public String contents;

	public Concept(User owner, Id concept) {
		this.xid = concept;
		this.oxid = owner.getId();
	}

	public static Id getId(Id user, String conceptName) {
		return new Id(user, KKind.Concept, conceptName);
	}

}
