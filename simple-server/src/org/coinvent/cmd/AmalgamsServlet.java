package org.coinvent.cmd;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;

import org.coinvent.AmalgamsRequests.AmalgamsRequest;
import org.coinvent.CoinventConfig;
import org.coinvent.IServlet;
import org.coinvent.ProcessActiveTriple;
import org.coinvent.ProcessActiveTriple.ActiveType;
import org.coinvent.HdtpRequests.HdtpRequest;
import org.coinvent.HdtpRequests.ReadType;

import com.winterwell.utils.web.WebUtils2;

import winterwell.json.JSONArray;
import winterwell.json.JSONObject;
import winterwell.utils.Proc;
import winterwell.utils.containers.ArrayMap;
import winterwell.utils.time.Dt;
import winterwell.utils.time.TUnit;
import winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;

public class AmalgamsServlet implements IServlet {

	
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
	
	private String getRequestOutput(String request, BufferedReader tempreader, BufferedReader reader, BufferedWriter writer, ReadType r)
	{
		 try {
			 
				 writer.write(request);
				 writer.flush();
			  
				 
				 

					
					// "Other blend? (n)"
					// "Finished"
					
					
				
					
				 
				 
		  String output = "";
			
		  switch (r)
		  {
		  case READ:
			
			String outln = tempreader.readLine();
			
			while (outln != null)
			{
				System.out.println(outln);
				
				if (outln.trim().equals("Other blend? (n)"))
				{
					break;
					}
				else
				if (outln.trim().equals("Finished"))
				{
					output="{}";
					break;
					}
				/*else if (outln.trim().equals("SATISFIABLE"))
				{
					break;
				}*/
				else
				{
				outln = tempreader.readLine();
				}
			}
			
			
			outln="";
			
			if (output != "{}")
			{
			
			while ((outln = reader.readLine()) != null)
			{
				//System.out.println ("Stdout: " + outln);
				output += outln;
				outln = reader.readLine();
			  
			
				
					
								  	
				
			}}
			break;
		  
		  default:
			output = "{}";
			break;
		  }
		  return output;
		 } catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return "";
			}	
	}
	
	@Override
	public void doPost(WebRequest webRequest) throws Exception {
	    
		boolean exists_generic_space;
		JsonResponse out;
		String idString = webRequest.get("id");
		String content = webRequest.get("content");
		String space_name1 = webRequest.get("space_name1");
		String space_name2 = webRequest.get("space_name2");
		String exists_gen = webRequest.get("exists_generic_space");
		String generic_space = webRequest.get("generic_space");
		String request = webRequest.get("request");
		
		if (exists_gen != null)
		{
			if (exists_gen.trim().equals("true"))
			{
				exists_generic_space = true;
			}
			else
			{
				exists_generic_space = false;
			}
		} 
		else
		{
			exists_generic_space = false;
		}
		/// WORK (OUT ID STUFF HERE....
		AmalgamsRequest req;
		Process proc = null;
		ProcessActiveTriple pa = null;
		
		ActiveType active = ActiveType.PENDING;
		int id = 0;
		if (request == null)
		{request = "";}
		
		
		  if (request.trim().equals("next"))
		    {
		         req = AmalgamsRequest.NEXT;
		    }
		    else if (request.trim().equals("close"))
		    {	
		    	req = AmalgamsRequest.CLOSE;
		    }
		    else if (request.trim().equals("start"))
		    {
		         req = AmalgamsRequest.NEW;
		    }
		    else req = AmalgamsRequest.NOACTION;
		  
		  //work out order here....
		  
		  String procstr = "cd /home/ewen/Amalgamation;/usr/bin/python /home/ewen/Amalgamation/run-blending.py"; 
		
		if (!(idString != null))
		{
			if (req == AmalgamsRequest.NEW)
			{
				ProcessBuilder builder = new ProcessBuilder("/bin/bash");
				builder.redirectErrorStream(true);	
				proc = builder.start();
			
			    id = CoinventConfig.setProc(proc);
			// don't set active yet - only when retrieved....
			}
		}
		else
		{
		    try {
		        id = Integer.parseInt(idString);
		        
		    	pa = CoinventConfig.getProc(id);
		    	if (pa != null){
		    	proc = pa.process;
		    	active = pa.active;
			    procstr = "";}
		    	else
		    	 {	proc= null;
		    	  }
		    	}
		    	
		    	catch (NumberFormatException e){
		    		System.out.println("Id not valid");
		    	}
		  
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		String output ="";
		String error = "";
		
		//write input file
		PrintWriter pwriter = new PrintWriter("/home/ewen/Amalgamation/content.casl","UTF-8");
		pwriter.println(content);
		pwriter.close();
		//write settings file
		String file_post = "numModels = 1\nminIterationsGeneralize=1\nmaxIterationsGeneralize=20\n" +
				"eproverTimeLimit=4\ndarwinTimeLimit=0.1\nhetsExe=\'hets\'\nblendValuePercentageBelowHighestValueToKeep=0\nuseHetsAPI=0\nhetsUrl='http://localhost:8000/'";
		String file_content = "inputFile=\"/home/ewen/Amalgamation/content.casl\"\ninputSpaceNames = [\""+
		space_name1+"\",\""+space_name2+"\"]\n"+file_post;
		pwriter=  new PrintWriter("/home/ewen/Amalgamation/settings.py");
		pwriter.println(file_content);
		pwriter.close();
		
	
		
		
		
		
		
		
		if (content == null)
		{content = "";}
	
		
		if ((proc != null))
		{
			InputStream stdout = proc.getInputStream();
			OutputStream stdin = proc.getOutputStream();
		
			BufferedReader tempreader = new BufferedReader(new InputStreamReader(stdout));
			BufferedReader reader = new BufferedReader(new FileReader("/home/ewen/coinvent/Amalgamation/blend.json"));
			BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(stdin));
		
		
			System.out.println(procstr);
			    
			switch (req)
			{ 
			case NEW:  
		      if (active == ActiveType.OPEN)
		      {
		    	  output = "{}";
		    	  error = "restart_existing";
		      }else if (active == ActiveType.CLOSED)
		      {
		    	  output = "{}";
		    	  error = "restart_closed";
		      }
		      else
		    	  {
		    	  output = getRequestOutput(procstr+"\n",tempreader,reader,writer,ReadType.READ);
		    	  
		    	  }
			  break;
			
			case NEXT:
			    if (active == ActiveType.OPEN)
			    { 
				output = getRequestOutput("\n",tempreader,reader,writer,ReadType.READ);
				//this means Finished has been reached
				if (output.trim().equals("{}"))
				{CoinventConfig.setProcClosed(id);}
				
				
			    }
			    else if (active == ActiveType.PENDING)
			    {
			        output = "{}";
			        error="not_initialised";
			    }
			    else
			    {error = "invalid_id";
			    output="{}";
			    }
			     break;
			
			case CLOSE:
				if (active == ActiveType.OPEN)
				{
				    output = getRequestOutput(":",tempreader,reader,writer,ReadType.NOREAD);
				    proc.destroy();
				   CoinventConfig.setProcClosed(id);
				}
				else if (active == ActiveType.PENDING)
				{
					output = "{}";
					error = "not_initialised";
				}
				else
				{
					error = "close_non_active";
				    output ="{}";
				}
			    break;
			    
			case NOACTION:
				output="{}";
				error="empty_request";
				break;
			    
			default:
				
				output = "{}";
				error = "invalid_request";
				break;
			}
		
		
		
	
		
		
		    
	
	    
	    System.out.println(output);
		
	    
	    
	    ArrayMap cargo = appendAmalgamsCargo(output,error,id);
	    
		//ArrayMap cargo = new ArrayMap("output", output);
		out = new JsonResponse(webRequest,cargo);
	
	
	}
	else
	{
		
		ArrayMap cargo = appendAmalgamsCargo("{}","invalid_id",id);
		//ArrayMap cargo = new ArrayMap("output", "id not valid: id = "+Integer.toString(id));
		out = new JsonResponse(webRequest,cargo);
	}
		WebUtils2.sendJson(out,webRequest);
		System.out.println(out);
	
	
	
	
	}
}
