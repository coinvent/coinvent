package org.coinvent.web;

import java.io.File;
import java.util.logging.Level;

import javax.servlet.http.HttpServlet;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.eclipse.jetty.servlet.ServletHolder;

import com.winterwell.utils.containers.SharedStatic;

import winterwell.utils.Printer;
import winterwell.utils.Utils;
import winterwell.utils.io.ArgsParser;
import winterwell.utils.reporting.Log;
import winterwell.web.app.FileServlet;
import winterwell.web.app.JettyLauncher;

/**
 * Run this! It starts up a web-server.
 * @author Daniel
 *
 */
public class ServerMain {

	private ServerConfig config;
	private JettyLauncher jl;

	public ServerMain(ServerConfig config) {
		this.config = config;		
	}

	public static void main(String[] args) {
		// Load config, if we have any
		ServerConfig config = new ServerConfig();
		File props = new File("src/main/config/ServerConfig.properties");		
		config = ArgsParser.parse(config, args, props, null);
		SharedStatic.put(ServerConfig.class, config);
		
		// Run it!
		ServerMain sm = new ServerMain(config);
		sm.run();
	}

	public void run() {
		// Spin up a Jetty server with reflection-based routing to servlets
		Log.d("web", "Setting up web server...");
		jl = new JettyLauncher(config.webAppDir, config.port);
		jl.setWebXmlFile(null);
		jl.setCanShutdown(false);
		jl.setup();
		DynamicHttpServlet dynamicRouter = new DynamicHttpServlet();
		jl.addServlet("/*", dynamicRouter);
		jl.addServlet("/static/*", new FileServlet());
		Log.report("web", "...Launching Jetty web server on port "+config.port, Level.INFO);
		jl.run();
		
		// Put in an index file
		dynamicRouter.putSpecialStaticFile("/", new File("web/index.html"));
	}

	public void stop() {
		try {
			jl.getServer().stop();
		} catch (Exception e) {
			throw Utils.runtime(e);
		}
	}
	
}

