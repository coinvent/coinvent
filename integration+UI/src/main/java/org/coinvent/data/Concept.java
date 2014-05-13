package org.coinvent.data;

import creole.data.XId;

public class Concept {

	private XId oxid;
	private XId xid;

	public Concept(User owner, XId concept) {
		this.xid = concept;
		this.oxid = owner.getXId();
	}

}
