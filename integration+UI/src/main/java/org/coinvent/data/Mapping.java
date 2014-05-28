package org.coinvent.data;

import java.util.Map;

import winterwell.utils.Printer;

public class Mapping {

	private Map map;

	public Mapping(Map map) {
		this.map = map;
	}

	public String toDOLFragment() {
		return Printer.toString(map, ", ", " |-> ");
	}

}
