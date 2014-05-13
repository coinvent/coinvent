package org.coinvent.data;

public class DataLayerFactory {

	public static IDataLayer get() {
		return new FileDataLayer();
	}
}
