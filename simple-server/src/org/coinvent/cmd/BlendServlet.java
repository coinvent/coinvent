package org.coinvent.cmd;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import org.coinvent.IServlet;
import org.eclipse.jetty.util.ajax.JSON;

import winterwell.json.JSONObject;
import winterwell.utils.StrUtils;
import winterwell.utils.Utils;
import com.winterwell.utils.containers.ArrayMap;
import winterwell.utils.containers.Cache;
import winterwell.utils.reporting.Log;
import winterwell.utils.time.TUnit;
import winterwell.utils.web.WebUtils;
import com.winterwell.web.ajax.AjaxMsg;
import com.winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;

import com.winterwell.utils.io.FileUtils;
import com.winterwell.utils.web.WebUtils2;
import com.winterwell.web.FakeBrowser;
import com.winterwell.web.WebEx;

/**
 * Calls HDTP.
 * 
 * Try: http://localhost:8300/static/blendui/index.html
 * 
 * <h2>API</h2>
 * 
 * <h3>Call HDTP</h3>
 * Endpoint: /cmd/blend<br>
 * 
 * Parameters:<br>
 *
 *  - action: hdtp or next, or close to close the HDTP process.<br>
 *  - input1: a JSON-format object with properties {name, url, text}.<br> 
 *  All properties are optional. If name and text are given, this defines a concept. If url is given, this is fetched.
 *  If just name is given, this must match a previously stored concept.<br>
 *  Tip: in javascript, use e.g. JSON.stringify({name:'MyConcept', text:'my concept spec'}) to make this.<br>
 *  - input2: a JSON-format object  with properties {name, url, text}. See input1 for details.<br>
 *  - pid: Process ID, as returned in the cargo from a action=hdtp call. Needed for action=next calls.
 * 
 * Returns: JSON-format object<br>
 * <pre>
 * {
 * 	success:boolean,
 *  cargo: {
 *  	output: string,
 *  	input1: {text: string},
 *  	input2: {text: string},
 *      theory: {text: string},
 *  	pid: string
 *  	}
 * }
 * </pre>
 * <p> 
 * It is not essential to close processes (there is a reaper thread which will do so, and the cache will evict if it reaches a limit).
 * However is is certainly good practice.
 * 
 * <h3>List Files</h3>
 * /cmd/blend?action=list-concepts
 * 
 * 
 * 
 * @author daniel
 * 
 */
public class BlendServlet implements IServlet {

	private HDTPAmalCommand cmd;	
	private HETSCommand hetscmd;
	
	

	private ArrayMap<String,String> appendAmalgamsCargo(String output, String error, int id)
	{
	  ArrayMap<String,String> result = new ArrayMap<String,String>();
	  JSONObject json = new JSONObject(output);
	 
	try
	{
	  String blend = json.getString("blend");
	 String input1 = json.getString("input1");
	 String input2 = json.getString("input2");
	 String genericSpace = json.getString("genericSpace");
	 String blendName = json.getString("blendName");
	 String blendId = json.getString("blendId");
	 String cost = json.getString("cost");
	 String idstring = Integer.toString(id);
	 
		
		result.put("id",Integer.toString(id));
		result.put("blend",blend);
		result.put("error",error);
		result.put("input1",input1);
		result.put("input2",input2);
		result.put("genericSpace",genericSpace);
		result.put("blendName",blendName);
		result.put("blendId",blendId);
		result.put("cost",cost);
		
		return result;
	}
	catch (winterwell.json.JSONException e)
	{
		ArrayMap<String,String>t = new ArrayMap<String,String>();
		t.put("blend","");
		t.put("id","");
		t.put("error","Error");
		return t;
	}
	 
	 // READ JSON INTO ARRAYMAP _ APPEND ID..... -
	 
	 
	 
  }
	
	
	static Map<String,HDTPAmalCommand> pid2process = new Cache<String,HDTPAmalCommand>(20) {
		protected void onRemove(String key, HDTPAmalCommand value) {
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
		
		if (webRequest.actionIs("save")) {
			String name = webRequest.get("blendname");
			if (name==null)
			{name = Utils.getRandomString(6)+".txt";}
			if (name.length() > 120) {
				name = StrUtils.ellipsize(name,80)+"_gen";
				}
			name = name.replaceAll("/", "_");
			if (name != "")
				{
					File f = getFile2(name);
					f.getParentFile().mkdirs();
					FileUtils.write(f, webRequest.get("blend"));
			}
			
		}
		
		
		if (webRequest.actionIs("hdtp")||webRequest.actionIs("hets")) {
			File f1 = getFile(webRequest, "input1");
			File f2 = getFile(webRequest, "input2");
			doNewHDTPProcess(f1, f2);
		} else if (webRequest.actionIs("amalgamscasl"))
		{  
			File f1 = getFile(webRequest, "content");
			String s1 = webRequest.get("space_name1");
			String s2 = webRequest.get("space_name2");
			doNewAmalgamsCASLProcess(f1, s1,s2);
		} else if (webRequest.actionIs("amalgamsowl"))
		{
			File f1 = getFile(webRequest, "content");
			String s1 = webRequest.get("space_name1");
			String s2 = webRequest.get("space_name2");
			doNewAmalgamsOWLProcess(f1, s1,s2);
		}
		else if (webRequest.actionIs("next")) {
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
		if (webRequest.actionIs("hets")) {
			String pid = Integer.toString((cmd.getProc().getProcessId()));
			hetscmd = new HETSCommand();
			hetscmd.setlocalfile("/web/static/hetsfile"+pid+".dol");
			// For testing
			//hetscmd.setlocalurl("http%3a%2f%2f148.251.85.37%3a8300%2fstatic%2fhetsfile"+"10581"+".dol");
			hetscmd.setlocalurl("http%3a%2f%2f148.251.85.37%3a8300%2fstatic%2fhetsfile"+pid+".dol");
			File file = new File(FileUtils.getWorkingDirectory(), hetscmd.getlocalfile());
			String i1 = FileUtils.read(cmd.getInput1());
			String i2 = FileUtils.read(cmd.getInput2());
			FileUtils.write(file, (i1+"\n\n"+i2+"\n\n"+output) );
			
			try {
				//InetAddress IP = InetAddress.getLocalHost();
				//System.out.println(IP.getHostAddress());
				String hetsurlstring = ("http://pollux.informatik.uni-bremen.de:8000/dg/"+(hetscmd.getlocalurl())+"/auto?format=dol");
				URL url = new URL(hetsurlstring);
				HttpURLConnection conn = (HttpURLConnection) url.openConnection();
				conn.setRequestMethod("GET");
				conn.setRequestProperty("Accept","application/json");
				
				if (conn.getResponseCode() != 200) {
				  throw new RuntimeException("Failed : HTTP error code : " 
						  + conn.getResponseCode());
			}
			 BufferedReader br = new BufferedReader(new InputStreamReader(
					 (conn.getInputStream())));
			 String line = "";
			 output = "";
			 while ((line = br.readLine()) != null) {
				 output += line;
			 }
			 
		
			//put into cargo response... 
			 conn.disconnect();
			 // parse output to get casl back...
		     ArrayMap cargo  = HETSCommand.parseHetsResponse(output,hetscmd.getlocalurl());
			 //do webrequestthing
			
				
				
				JsonResponse jr = new JsonResponse(webRequest, cargo);
				WebUtils2.sendJson(jr, webRequest);
			 
			 
			 
			} catch (MalformedURLException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
					
			
		} else {
		
		
		ArrayMap cargo;
		
        if (webRequest.actionIs("hdtp")||webRequest.actionIs("hets")) {
		cargo = new ArrayMap(				
				"output", output				
				);
		if (cmd!=null) {
			String i1 = FileUtils.read(cmd.getInput1());
			String i2 = FileUtils.read(cmd.getInput2());
			cargo.put("pid", cmd.getProc().getProcessId());
			cargo.put("input1", new ArrayMap("text", i1));
			cargo.put("input2", new ArrayMap("text", i2));
			cargo.put("theory",new ArrayMap("text",i1+"\n\n"+i2+"\n\n"+output));
		}} else if (webRequest.actionIs("amalgamscasl")||webRequest.actionIs("amalgamsowl")) {
			
			cargo = appendAmalgamsCargo(output,"",0);
			//ArrayMap cargo = new ArrayMap("output", "id not valid: id = "+Integer.toString(id));
			
			
		} else
		{
			 cargo = new ArrayMap(				
					"output", "Not yet implemented"				
					); 	
		}
		
		
		
		
		
		JsonResponse jr = new JsonResponse(webRequest, cargo);
		WebUtils2.sendJson(jr, webRequest);}
	}

	private void doNewHDTPProcess(File f1, File f2) throws IOException {
		cmd = new HDTPAmalCommand(HDTPAmalCommand.CMD.HDTP,f1, f2,"","");
		cmd.run();
		pid2process.put(""+cmd.getProc().getProcessId(), cmd);
		final HDTPAmalCommand fcmd = cmd;
		reaper.schedule(new TimerTask(){
			@Override
			public void run() {
				Log.d("reaper", "Close "+fcmd);
				fcmd.close();			
			}				
		}, TUnit.HOUR.millisecs);
	}
	
	private void doNewAmalgamsCASLProcess(File f1, String s1, String s2) throws IOException {
		cmd = new HDTPAmalCommand(HDTPAmalCommand.CMD.AMALCASL,f1, f1,s1,s2);
		cmd.run();
		//pid2process.put(""+cmd.getProc().getProcessId(), cmd);
		final HDTPAmalCommand fcmd = cmd;
		reaper.schedule(new TimerTask(){
			@Override
			public void run() {
				Log.d("reaper", "Close "+fcmd);
				fcmd.close();			
			}				
		}, TUnit.HOUR.millisecs);
	}

	private void doNewAmalgamsOWLProcess(File f1, String s1, String s2) throws IOException {
		cmd = new HDTPAmalCommand(HDTPAmalCommand.CMD.AMALOWL,f1, f1,s1,s2);
		cmd.run();
		pid2process.put(""+cmd.getProc().getProcessId(), cmd);
		final HDTPAmalCommand fcmd = cmd;
		reaper.schedule(new TimerTask(){
			@Override
			public void run() {
				Log.d("reaper", "Close "+fcmd);
				fcmd.close();			
			}				
		}, TUnit.HOUR.millisecs);
	}
	
	private void doListConcepts(WebRequest webRequest) throws IOException {
		File dir = getFile2("dummy").getParentFile();
		if ( ! dir.exists()) dir.mkdirs();
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
