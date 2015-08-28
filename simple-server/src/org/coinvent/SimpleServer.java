package org.coinvent;

import java.io.File;
import java.util.logging.Level;

import winterwell.utils.Utils;
import winterwell.utils.gui.GuiUtils;
import winterwell.utils.reporting.Log;
import winterwell.utils.reporting.LogFile;
import winterwell.utils.time.Dt;
import winterwell.utils.time.TUnit;
import winterwell.utils.web.WebUtils;
import winterwell.web.app.FileServlet;
import winterwell.web.app.JettyLauncher;

import com.winterwell.utils.io.ArgsParser;

/**
 * Run this! It starts up a web-server.
 * @author Daniel
 *
 */
public class SimpleServer {

	private CoinventConfig config;
	private JettyLauncher jl;

	public SimpleServer(CoinventConfig config) {
		this.config = config;		
	}
	
	static LogFile logFile;
	
	public static SimpleServer app;
	
	public CoinventConfig getConfig() {
		return config;
	}

	
	
	public static void main(String[] args) {
		// Load config, if we have any
		CoinventConfig config = new CoinventConfig();
		File props = new File("config/ServerConfig.properties");		
		config = ArgsParser.parse(config, args, props, null);
		
		// Log file - if not already set by run()
		assert logFile==null;
		logFile = new LogFile(new File(config.webAppDir, "SimpleServer.log"));
		// keep 14 days of log files
		logFile.setLogRotation(new Dt(24, TUnit.HOUR), 14);
		
		// Run it!
		app = new SimpleServer(config);
		app.run();
		
		// Open test view?
		if (GuiUtils.isInteractive()) {
			Log.i("init", "Open links in local browser...");
			WebUtils.display(WebUtils.URI("http://localhost:"+config.port+"/static/helloworld/index.html"));
						
		}
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

