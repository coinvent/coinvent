package org.coinvent.data;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.TreeMap;

import winterwell.utils.Printer;
import winterwell.utils.containers.AbstractMap2;

public class Mapping extends AbstractMap2<String,String> {

	/**
	 * Apply a standard sorting, so that hashing (used for job ids) is predictable.
	 */
	private SortedMap<String,String> map;

	@Override
	public Set<String> keySet() throws UnsupportedOperationException {
		return map.keySet();
	}
	
	public Mapping(Map map) {
		this.map = new TreeMap(map);
	}

	public String toDOLFragment() {
		return Printer.toString(map, ", ", " |-> ");
	}

	@Override
	public String get(Object key) {
		return map.get(key);
	}

	@Override
	public String put(String key, String value) {
		return map.put(key, value);
	}

}
