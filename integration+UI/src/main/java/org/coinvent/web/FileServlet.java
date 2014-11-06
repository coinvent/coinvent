package org.coinvent.web;

import java.io.File;
import java.util.Arrays;

import org.coinvent.CoinventConfig;
import org.coinvent.data.DataLayerFactory;

import com.winterwell.utils.containers.SharedStatic;
import com.winterwell.utils.io.FileUtils;
import com.winterwell.utils.web.WebUtils2;

import winterwell.utils.StrUtils;
import winterwell.utils.containers.Containers;
import winterwell.web.WebEx;
import winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;

/**
 * Simple file interface. WEBDAV lite
 * @author daniel
 *
 */
public class FileServlet extends AServlet {

	public static File BASE = new File(SharedStatic.get(CoinventConfig.class).webAppDir, "files").getAbsoluteFile();
	
	@Override
	public void doPost(WebRequest req) throws Exception {
		init(req);

		if (slug==null) {
			// List files
			String sslug = FileUtils.safeFilename(actorName, false);
			File f = new File(BASE, sslug);
			String[] files = f.list();
			Object cargo = Arrays.asList(files);
			JsonResponse output = new JsonResponse(req, cargo);
			WebUtils2.sendJson(output, req);
			return;
		}

		// NB: This does defend against using .. in the file name to try and access deeper files.
		String sslug = FileUtils.safeFilename(actorName+"/"+slug+"."+type, true);
		File f = new File(BASE, sslug);		

		// Save?
		if ("PUT".equals(req.getRequest().getMethod()) || req.actionIs("save")) {
			f.getParentFile().mkdirs();
			FileUtils.write(f, req.getPostBody());
		}
		
		// Send it (or a 404)
		winterwell.web.app.FileServlet.serveFile(f, req);
	}

}
