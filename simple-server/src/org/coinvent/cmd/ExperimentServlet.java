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
import java.util.Random;
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


public class ExperimentServlet implements IServlet {

		private InputFiles[] inputfile;
		
		private void setupInputFiles() {
			inputfile=new InputFiles[2];
			inputfile[0] = new InputFiles("/web/static/experiment_files/1");
			inputfile[1] = new InputFiles("/web/static/experiment_files/2");
		}
		
		@Override
		public void doPost(WebRequest webRequest) throws Exception {		
			setupInputFiles();
			if (webRequest.actionIs("get"))
			{
				String numstr = (webRequest.get("current"));
				int num =Integer.parseInt(numstr.trim());
			    InputFiles i = inputfile[num];
			    String tlemma,result;
			    Random randomNum = new Random();
			    int res = randomNum.nextInt(2);
			    boolean random = (res == 1);
			    if (random)
			    {
			    	result="yes";
			    	tlemma = i.target_lemma;
			    }
			    else
			    {
			    	result="no";
			    	tlemma= "No viable analogy";
			    }
			    
			    
			try {
				ArrayMap cargo = new ArrayMap(				
						"stheorem", i.source_theorem				
						);
				
					
					cargo.put("slemma", i.source_lemma);
					cargo.put("ttheorem", i.target_theorem);
					cargo.put("tlemma", tlemma);
					cargo.put("stheory", i.source_location);
					cargo.put("ttheory", i.target_location);
				    cargo.put("result", result);
				
				JsonResponse jr = new JsonResponse(webRequest, cargo);
				WebUtils2.sendJson(jr, webRequest);
				
			}
		     catch (IOException e) {
				e.printStackTrace();
			 
			}
			}
			if (webRequest.actionIs("save"))
			{
				 //webRequest.get("their_suggestion");
				
			}
		}
	}
			
			    		
				
		

