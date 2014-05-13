package org.coinvent.data;

public class DataLayerFactory {

	public static ESDataLayer get() {
		return new ESDataLayer();
	}
}
