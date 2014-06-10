package org.coinvent.web;

import java.io.File;

import org.coinvent.data.DataLayerFactory;

import com.winterwell.utils.containers.SharedStatic;


import winterwell.utils.StrUtils;
import winterwell.utils.io.FileUtils;
import winterwell.utils.web.WebUtils2;
import winterwell.web.WebEx;
import winterwell.web.app.WebRequest;

public class FileServlet extends AServlet {

	public static File BASE = new File(SharedStatic.get(ServerConfig.class).webAppDir, "files").getAbsoluteFile();
	
	@Override
	public void doPost(WebRequest req) throws Exception {
		init(req);
		// Does the file exist?
		String sslug = FileUtils.safeFilename(actorName+"/"+slug+"."+type, true);
		File f = new File(BASE, sslug);		
		
		// Support cross-browser
		WebUtils2.CORS(req, true);
		
		winterwell.web.app.FileServlet.serveFile(f, req);
	}

}
