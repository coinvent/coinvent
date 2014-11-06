package org.coinvent.web;

import static org.junit.Assert.*;

import java.util.Map;

import org.coinvent.Coinvent;
import org.coinvent.CoinventConfig;
import org.eclipse.jetty.util.ajax.JSON;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import winterwell.utils.containers.ArrayMap;
import winterwell.web.FakeBrowser;

public class BaseServletTest {
	private static Coinvent server;
	private static CoinventConfig config;

	@BeforeClass
	public static void setup() {
		// Spin up a web server
		config = new CoinventConfig();
		config.port = 9449;
		server = new Coinvent(config);
		server.run();
	}
	
	@AfterClass
	public static void teardown() {
		server.stop();
	}
	
	@Test
	public void testDefault() {
		FakeBrowser fb = new FakeBrowser();
		Map<String, String> vars = new ArrayMap(
				"lang", "owl",
				"input1", "Class: Human",
				"input2", "Class: Fish"
				);
		String _response1 = fb.post("http://localhost:"+config.port+"/base/default", vars);
		Map response1 = (Map) JSON.parse(_response1);
		System.out.println(response1);
	}

}
