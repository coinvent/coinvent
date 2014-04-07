package org.coinvent.web;

import java.util.Map;

import org.eclipse.jetty.util.ajax.JSON;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import winterwell.utils.Utils;
import winterwell.utils.containers.ArrayMap;
import winterwell.utils.time.TUnit;
import winterwell.web.FakeBrowser;

public class SlowHelloWorldServletTest {

	private static ServerMain server;

	@BeforeClass
	public static void setup() {
		// Spin up a web server
		ServerConfig config = new ServerConfig();
		config.port = 9447;
		server = new ServerMain(config);
		server.run();
	}
	
	@AfterClass
	public static void teardown() {
		server.stop();
	}
	
	@Test
	public void testHello() {
		FakeBrowser fb = new FakeBrowser();
		String _response1 = fb.getPage("http://localhost:9447/slowHelloWorld");
		Map response1 = (Map) JSON.parse(_response1);
		System.out.println(response1);
		assert response1.containsKey("jobid");
		Object jobid = response1.get("jobid"); 
		assert response1.get("success") == Boolean.TRUE : response1;
		
		// NB: since the test is not itself running a web server, we won't get the callback
		
		String _response2 = fb.getPage("http://localhost:9447/slowHelloWorld?jobid="+jobid);
		Map response2 = (Map) JSON.parse(_response2);
		System.out.println(response2);
		
		Utils.sleep(12, TUnit.SECOND);
		
		String _response3 = fb.getPage("http://localhost:9447/slowHelloWorld?jobid="+jobid);
		Map response3 = (Map) JSON.parse(_response3);
		System.out.println(response3);
		String result = (String) response3.get("cargo");
		assert result.contains("Hello");
	}
}
