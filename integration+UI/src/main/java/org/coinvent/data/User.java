package org.coinvent.data;

import java.io.File;

import creole.data.XId;

public class User {

	public User(XId xid) {
		this.xid = xid;
	}

	XId xid;

	public XId getXId() {
		return xid;
	}
	
}
