package org.coinvent.web;

import static org.junit.Assert.*;

import org.junit.Test;

public class DynamicHttpServletTest {

	@Test
	public void testGetServlet() throws Exception {
		DynamicHttpServlet dhs = new DynamicHttpServlet();
		AServlet shw = dhs.getServlet("slowHelloWorld");
		assert shw instanceof SlowHelloWorldServlet : shw;
	}

}
