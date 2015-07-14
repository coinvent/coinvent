package org.coinvent.cmd;

import org.coinvent.IServlet;

import winterwell.utils.Proc;
import winterwell.utils.io.FileUtils;
import winterwell.utils.time.Dt;
import winterwell.utils.time.TUnit;
import winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;

import com.winterwell.utils.web.WebUtils2;

/**
 * A dummy servlet to demonstrate running a command.
 * 
 * Try: http://localhost:8300/cmd/ls.json?dir=web/static
 * @author daniel
 *
 */
public class LsServlet implements IServlet {

	@Override
	public void doPost(WebRequest webRequest) throws Exception {
		String dir = webRequest.get("dir");
		// a bit of security
		dir = FileUtils.safeFilename(dir);
		if (dir.startsWith("/")) throw new SecurityException("Naughty! "+dir);
		
		// Run the ls command
		Proc proc = new Proc("ls "+dir);
		proc.run();
		proc.waitFor(new Dt(5, TUnit.SECOND));
		proc.close();
		String output = proc.getOutput();
		
		JsonResponse out = new JsonResponse(webRequest, output);
		WebUtils2.sendJson(out, webRequest);
	}

}
