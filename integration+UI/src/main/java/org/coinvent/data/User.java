package org.coinvent.data;

import java.io.File;



public class User {

	public User(Id xid) {
		this.xid = xid;
	}

	Id xid;

	public Id getId() {
		return xid;
	}
	
}
