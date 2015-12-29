package org.coinvent.cmd;

import org.coinvent.ProcessActiveTriple.ActiveType;
import org.coinvent.HdtpRequests.HdtpRequest;
import org.coinvent.HdtpRequests.ReadType;
import org.coinvent.IServlet;
import org.coinvent.CoinventConfig;
import org.coinvent.ProcessActiveTriple;

import winterwell.utils.StrUtils;
import winterwell.utils.Utils;
import winterwell.utils.containers.ArrayMap;
import winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import com.winterwell.utils.io.FileUtils;
import com.winterwell.utils.web.WebUtils2;
import com.winterwell.web.FakeBrowser;
import com.winterwell.web.WebEx;

/**
 * Calls HDTP
 * 
 * @author daniel
 * 
 */
public class BlendServlet implements IServlet {

	private HDTPCommand cmd;	
	
	static Map<String,HDTPCommand> pid2process = new ConcurrentHashMap();
	
	@Override
	public void doPost(WebRequest webRequest) throws Exception {
		if (webRequest.actionIs("hdtp")) {
			File f1 = getFile(webRequest, "input1");
			File f2 = getFile(webRequest, "input2");
			cmd = new HDTPCommand(f1, f2);
			cmd.run();
		} else if (webRequest.actionIs("next")) {
			String pid = webRequest.get("pid");
			cmd = pid2process.get(pid);
			if (cmd==null) throw new WebEx.E404(webRequest.getRequestUrl(), "Cannot find process "+pid);
			cmd.next();
		} else if (webRequest.actionIs("close")) {
			String pid = webRequest.get("pid");
			cmd = pid2process.get(pid);
			if (cmd!=null) cmd.close();
		}
		String output = cmd==null? null : cmd.getOutput();
		
		ArrayMap cargo = new ArrayMap(
				"pid", cmd==null? null : cmd.getProc().getProcessId(),
				"output", output
				);
		
		JsonResponse jr = new JsonResponse(webRequest, cargo);
	}

	private File getFile(WebRequest webRequest, String string) {
		String v = webRequest.get(string);
		assert ! Utils.isBlank(v) : webRequest+" "+string;
		File f = new File(FileUtils.getWorkingDirectory(), "uploaded_concepts/"+FileUtils.safeFilename(v)); 
		if (f.isFile()) return f;
		String s;
		String name;
		// is it a url?
		if (WebUtils2.URL_REGEX.matcher(v).matches()) {
			s = new FakeBrowser().getPage(v);
			name = StrUtils.md5(v);
		} else {
			s = v;
			name = Utils.getRandomString(6)+".txt";
		} 		
		// save it
		f = new File(FileUtils.getWorkingDirectory(), "uploaded_concepts/"+name);
		FileUtils.write(f, s);
		
		return f;
	}

}
