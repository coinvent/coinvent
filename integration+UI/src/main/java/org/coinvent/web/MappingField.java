package org.coinvent.web;

import java.util.HashMap;
import java.util.Map;

import org.coinvent.data.Concept;
import org.coinvent.data.Mapping;
import org.eclipse.jetty.util.ajax.JSON;

import winterwell.utils.Key;
import winterwell.web.fields.AField;

public class MappingField extends AField<Mapping> {

	public MappingField(String name) {
		super(name);
	}
	
	@Override
	public String toString(Mapping value) {
		return value.toDOLFragment();
	}

	@Override
	public Mapping fromString(String v) throws Exception {
		// Is it JSON?
		if (v.startsWith("{")) {
			Map map = (Map) JSON.parse(v);
			return new Mapping(map);
		}
		// A crude DOL paser
		String[] bits = v.split("\\s*,\\s*");
		Map map = new HashMap();
		for (String bit : bits) {
			String[] kv = bit.split("\\s*|->\\s*");
			map.put(kv[0], kv[1]);
		}
		return new Mapping(map);
	}
}
