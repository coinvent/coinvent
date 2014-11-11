/**
 * 
 */
package org.coinvent.web;

import static org.junit.Assert.*;

import java.util.Map;

import org.coinvent.CoinventConfig;
import org.coinvent.Coinvent;
import org.eclipse.jetty.util.ajax.JSON;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import winterwell.utils.web.WebUtils;
import winterwell.web.FakeBrowser;

/**
 * @author daniel
 *
 */
public class FileServletTest {

	private static Coinvent server;
	private static CoinventConfig config;

	@BeforeClass
	public static void setup() {
		// Spin up a web server
		config = new CoinventConfig();
		config.port = 9448;
		server = new Coinvent(config);
		server.run();
	}
	
	@AfterClass
	public static void teardown() {
		server.stop();
	}
	
	@Test
	public void testList() {
		FakeBrowser fb = new FakeBrowser();
		String _response1 = fb.getPage("http://localhost:"+config.port+"/file/winterstein");
		Map response1 = (Map) JSON.parse(_response1);
		System.out.println(response1);
	}

	@Test
	public void testGet() {
		FakeBrowser fb = new FakeBrowser();
		String _response1 = fb.getPage("http://localhost:"+config.port+"/file/test/hello.txt");
		System.out.println(_response1);
	}
	
	@Test
	public void testPut() {
		FakeBrowser fb = new FakeBrowser();
		String _response1 = fb.post("http://localhost:"+config.port+"/file/test/foo.txt?action=save&dummy=&d2=2",
				fb.MIME_TYPE_URLENCODED_FORM, 
				WebUtils.urlEncode("Foo Bar Text :)"));
		System.out.println(_response1);
	}
}
