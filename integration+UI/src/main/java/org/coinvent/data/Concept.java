package org.coinvent.data;

import creole.data.XId;

public class Concept {

	public XId oxid;
	public XId xid;
	public String lang;
	public String iri;
	public String contents;

	public Concept(User owner, XId concept) {
		this.xid = concept;
		this.oxid = owner.getXId();
	}

}
