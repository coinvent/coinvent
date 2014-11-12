package org.coinvent.data;

import java.io.File;
import java.io.Serializable;

import org.eclipse.jetty.util.ajax.JSON;
/**
 * @testedby IdTest
 * @author daniel
 *
 */
public class Id implements Serializable {
	private static final long serialVersionUID = 1L;

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Id other = (Id) obj;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		return true;
	}

	public Id(KKind type, String name) {
		assert type==KKind.User : type;
		this.id = type+"::"+name;
	}
	
	public Id(Id parent, KKind type, String name) {
		assert type!=KKind.User : type;
		this.id = type+"::"+parent.getName()+"::"+name;
	}

	public Id(String id) {
		this.id = id;
	}

	String id;
	
	@Override
	public String toString() {
		return id;
	}

	public String getName() {
		Object[] arr = id.split("::");
		return (String) arr[arr.length-1];
	}

	public Id getParent() {
		Object[] arr = id.split("::");
		return arr.length==2? null : new Id((String)arr[1]);
	}

	public KKind getKind() {
		Object[] arr = id.split("::");
		return KKind.valueOf((String)arr[0]);
	}
	
}
