package org.coinvent.data;

public class DataLayerFactory {

	public static FileDataLayer get() {
		return new FileDataLayer();
	}
}
