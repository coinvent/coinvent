package org.coinvent.data;

import java.io.File;

import org.eclipse.jetty.util.ajax.JSON;

public class Id {

	public Id(KKind type, String name) {
		assert type==KKind.User : type;
		this.id = JSON.toString(new Object[]{type, name});
	}
	
	public Id(Id parent, KKind type, String name) {
		assert type!=KKind.User : type;
		this.id = JSON.toString(new Object[]{parent, type, name});
	}

	String id;
	
	@Override
	public String toString() {
		return id;
	}

	public String getName() {
	}

	public Id getParent() {
	}

	public KKind getKind() {
	}
	
}
