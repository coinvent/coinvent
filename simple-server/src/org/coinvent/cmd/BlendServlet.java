package org.coinvent.cmd;

import org.coinvent.ProcessActiveTriple.ActiveType;
import org.coinvent.HdtpRequests.HdtpRequest;
import org.coinvent.HdtpRequests.ReadType;
import org.coinvent.IServlet;
import org.coinvent.CoinventConfig;
import org.coinvent.ProcessActiveTriple;
import org.eclipse.jetty.io.BufferCache.CachedBuffer;
import org.eclipse.jetty.util.ajax.JSON;

import winterwell.utils.StrUtils;
import winterwell.utils.Utils;
import winterwell.utils.containers.ArrayMap;
import winterwell.utils.containers.Cache;
import winterwell.utils.time.TUnit;
import winterwell.utils.web.WebUtils;
import winterwell.web.ajax.AjaxMsg;
import winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URI;
import java.net.URISyntaxException;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.ConcurrentHashMap;

import com.google.common.cache.CacheBuilder;
import com.winterwell.utils.io.FileUtils;
import com.winterwell.utils.web.WebUtils2;
import com.winterwell.web.FakeBrowser;
import com.winterwell.web.WebEx;

/**
 * Calls HDTP.
 * 
 * Try: http://localhost:8300/static/blendui/index.html
 * 
 * @author daniel
 * 
 */
public class BlendServlet implements IServlet {

	private HDTPCommand cmd;	
	
	static Map<String,HDTPCommand> pid2process = new Cache<String,HDTPCommand>(20) {
		protected void onRemove(String key, HDTPCommand value) {
			if (value!=null) value.close();
		}
	};
	
	static Timer reaper = new Timer("reaper", true);
	
	@Override
	public void doPost(WebRequest webRequest) throws Exception {		
		if (webRequest.actionIs("list-concepts")) {
			doListConcepts(webRequest);
			return;
		}
		if (webRequest.actionIs("DELETE-ALL")) {
			File dir = getFile2("dummy").getParentFile();
			FileUtils.deleteDir(dir);
			dir.mkdirs();
			JsonResponse jr = new JsonResponse(webRequest, "DELETED");
			WebUtils2.sendJson(jr, webRequest);
			return;
		}
		
		if (webRequest.actionIs("hdtp")) {
			File f1 = getFile(webRequest, "input1");
			File f2 = getFile(webRequest, "input2");
			doNewHDTPProcess(f1, f2);
		} else if (webRequest.actionIs("next")) {
			String pid = webRequest.get("pid");
			cmd = pid2process.get(pid);
			if (cmd==null) {
				throw new WebEx.E404(webRequest.getRequestUrl(), "Cannot find process "+pid);
			}
			cmd.next();
		} else if (webRequest.actionIs("close")) {
			String pid = webRequest.get("pid");
			cmd = pid2process.remove(pid);
			if (cmd!=null) {
				cmd.close();
				webRequest.addMessage(new AjaxMsg("Closed process "+pid));
			} else {
				webRequest.addMessage(new AjaxMsg("Could not find process "+pid));
			}
		}
		String output = cmd==null? null : cmd.getOutput();
		
		ArrayMap cargo = new ArrayMap(
				"pid", cmd==null? null : cmd.getProc().getProcessId(),
				"output", output
				);
		
		JsonResponse jr = new JsonResponse(webRequest, cargo);
		WebUtils2.sendJson(jr, webRequest);
	}

	private void doNewHDTPProcess(File f1, File f2) throws IOException {
		cmd = new HDTPCommand(f1, f2);
		cmd.run();
		pid2process.put(""+cmd.getProc().getProcessId(), cmd);
		final HDTPCommand fcmd = cmd;
		reaper.schedule(new TimerTask(){
			@Override
			public void run() {
				fcmd.close();			
			}				
		}, TUnit.HOUR.millisecs);
	}

	private void doListConcepts(WebRequest webRequest) throws IOException {
		File dir = getFile2("dummy").getParentFile();
		String[] files = dir.list();
		List cargo = new ArrayList();
		for(String f : files) {
			cargo.add(WebUtils.urlDecode(f));		
		}
		JsonResponse jr = new JsonResponse(webRequest, cargo);
		WebUtils2.sendJson(jr, webRequest);

	}

	private File getFile(WebRequest webRequest, String string) throws URISyntaxException {
		String json = webRequest.get(string);
		assert ! Utils.isBlank(json) : webRequest+" "+string;
		Map map = (Map) JSON.parse(json);
		
		String name = (String) map.get("name");
		String url = (String) map.get("url");
		String text = (String) map.get("text");
		
		if (url != null) {
			text = new FakeBrowser().getPage(url);
			if (name==null) {
				URI uri = new URI(url);
				name = WebUtils.getDomain(url)+uri.getPath()+(uri.getQuery()==null?"":"_"+uri.getQuery());
				if (name.length() > 120) {
					name = StrUtils.ellipsize(name,80)+"_"+StrUtils.md5(url);
				}
				name = name.replaceAll("/", "_");
			}
		} else if (text==null) {
			assert name != null;
			File f = getFile2(name); 
			if (f.isFile()) return f;
			throw new WebEx.E404(name, "Could not find concept "+name);
		} else {
			if (name==null) {
				name = Utils.getRandomString(6)+".txt";	
			}
		}	
		
		// save it
		File f = getFile2(name);
		f.getParentFile().mkdirs();
		FileUtils.write(f, text);
		
		return f;
	}

	private File getFile2(String name) {
		return new File(FileUtils.getWorkingDirectory(), "uploaded_concepts/"+WebUtils.urlEncode(name));
	}

}
