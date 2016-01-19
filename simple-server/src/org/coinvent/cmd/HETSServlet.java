
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
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.InetAddress;
/**
* Calls HETS via HETS API.
* 
* Try: http://localhost:8300/static/blendui/index.html
* 
* <h2>API</h2>
* 
* <h3>Call HETS</h3>
* Endpoint: /cmd/HETS<br>
* 
* Parameters:<br>
*
*  - action: full-theories returns output file from hets after doing an auto-dg  <br>
             consistency-check returns result of consistency check with eprover via HETS <br>
   - pid: pid of current HDTP process - uniquely defined file to be put on localhost url for HETS API
*  - contents: the contents of the file to be sent to HETS 
*  
* Returns: JSON-format object<br>
* <pre>
* {
* 	success:boolean,
*  cargo: {
*  	fulloutput: {text: string},
*  	blendoutput: {text: string},
*  	consistency: {text: string}
*  	}
* }
* </pre>
* 
* @author ewen
* 
*/


public class HETSServlet implements IServlet {

		private HETSCommand cmd;
		
		@Override
		public void doPost(WebRequest webRequest) throws Exception {		
			
				cmd = new HETSCommand();
			
				if (webRequest.actionIs("full-theories")) {
					String contents = webRequest.get("contents");
					String pid = webRequest.get("pid");
					cmd.setlocalfile("/web/static/hetsfile"+pid+".dol");
					// For testing
					//cmd.setlocalurl("http%3a%2f%2f148.251.85.37%3a8300%2fstatic%2fhetsfile"+"6253"+".dol");
					cmd.setlocalurl("http%3a%2f%2f148.251.85.37%3a8300%2fstatic%2fhetsfile"+pid+".dol");
					File file = new File(FileUtils.getWorkingDirectory(), cmd.getlocalfile());
					FileUtils.write(file, contents);
					
					try {
						//InetAddress IP = InetAddress.getLocalHost();
						//System.out.println(IP.getHostAddress());
						String hetsurlstring = ("http://pollux.informatik.uni-bremen.de:8000/dg/"+(cmd.getlocalurl())+"/auto?format=dol");
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
					 String output = "";
					 while ((line = br.readLine()) != null) {
						 output += line;
					 }
					 
				
					//put into cargo response... 
					 conn.disconnect();
					 // parse output to get casl back...
				     ArrayMap cargo  = HETSCommand.parseHetsResponse(output);
					 //do webrequestthing
					
						
						
						JsonResponse jr = new JsonResponse(webRequest, cargo);
						WebUtils2.sendJson(jr, webRequest);
					 
					 
					 
					} catch (MalformedURLException e) {
						e.printStackTrace();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
					
				
					
					
				/*	ArrayMap cargo = new ArrayMap(				
							"address", ("localhost:8300/static/hetsfile"+pid+".dol")				
							);
					JsonResponse jr = new JsonResponse(webRequest, cargo);
					WebUtils2.sendJson(jr, webRequest);	
					return;*/
				
				if (webRequest.actionIs("consistency-check")) {
					String contents = webRequest.get("contents");
					ArrayMap cargo = new ArrayMap(				
							"const-check", ("")				
							);
					JsonResponse jr = new JsonResponse(webRequest, cargo);
					WebUtils2.sendJson(jr, webRequest);
					return;
				}
			    
				
				
		}
}

	
	

	
