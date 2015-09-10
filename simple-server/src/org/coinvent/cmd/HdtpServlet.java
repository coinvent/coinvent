
package org.coinvent.cmd;






import org.coinvent.ProcessActiveTriple.ActiveType;
import org.coinvent.HdtpRequests.HdtpRequest;
import org.coinvent.HdtpRequests.ReadType;
import org.coinvent.IServlet;
import org.coinvent.CoinventConfig;
import org.coinvent.ProcessActiveTriple;

import winterwell.utils.Proc;
import winterwell.utils.containers.ArrayMap;
import winterwell.utils.io.FileUtils;
import winterwell.utils.time.Dt;
import winterwell.utils.time.TUnit;
import winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.OutputStream;

import java.io.BufferedReader;
import java.io.BufferedWriter;

import com.winterwell.utils.web.WebUtils2;

/**
 * A dummy servlet to demonstrate running a command.
 * 
 * Try: http://localhost:8300/cmd/ls.json?dir=web/static
 * @author daniel
 *
 */
public class HdtpServlet implements IServlet {
	
	
	private ArrayMap getHdtpCargo(int id,String output,String error)
	{
		
		//HashMap map = new HashMap();
		
		
		ArrayMap<String,String> result = new ArrayMap<String,String>();
		result.put("id",Integer.toString(id));
		result.put("output",output);
		result.put("error",error);
		return result;
		
	}
	
	private String getRequestOutput(String request, BufferedReader reader, BufferedWriter writer, ReadType r)
	{
		 try {
			 writer.write(request);
			 writer.flush();
		  String output = "";
			
		  switch (r)
		  {
		  case READ:
			String outln = reader.readLine();
		
			while (outln != null)
			{
				System.out.println ("Stdout: " + outln);
				outln = reader.readLine();
			  
				if (outln.trim().equals(""))
				{
					break;
				}
				else	
				{
					output += outln;
				}				  	
				
			}
			break;
		  
		  default:
			output = "Process Closed";
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
	
		JsonResponse out;
		String idString = webRequest.get("id");
		String request = webRequest.get("request");
		String input_file1 = webRequest.get("input1");
		String input_file2 = webRequest.get("input2");
		String analogy_name = webRequest.get("name");
		
		if (analogy_name == null)
		{
		   analogy_name="\"generated\"";
		}
		
		String output = "";
		String error = "";
		String cmd = "gen_simple_casl(analogy("+analogy_name+","+input_file1+","+input_file2+")),get_char(':')";
		int id = 0;
		String procstr = "/usr/bin/swipl --quiet -G0K -T0K -L0K -s /home/ewen/HDTP_coinvent/hdtp.pro -t \""+cmd+"\"";
		
		System.out.println(procstr);
		ProcessActiveTriple pa = null;
		Process proc = null;
		ActiveType active = ActiveType.PENDING;
		
		HdtpRequest req;
		if (request == null)
		{request = "";}
		
		
		  if (request.trim().equals("next"))
		    {
		         req = HdtpRequest.NEXT;
		    }
		    else if (request.trim().equals("close"))
		    {	
		    	req = HdtpRequest.CLOSE;
		    }
		    else if (request.trim().equals("start"))
		    {
		         req = HdtpRequest.NEW;
		    }
		    else req = HdtpRequest.NOACTION;
		
		
		if (!(idString != null))
		{
			if (req == HdtpRequest.NEW)
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
		
		
		
		
		
		
		  
		if ((proc != null))
		{
			InputStream stdout = proc.getInputStream();
			OutputStream stdin = proc.getOutputStream();
		
			BufferedReader reader = new BufferedReader(new InputStreamReader(stdout));
			BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(stdin));
		
			
			    
			switch (req)
			{ 
			case NEW:  
		      if (active == ActiveType.OPEN)
		      {
		    	  output = "";
		    	  error = "restart_existing";
		      }else if (active == ActiveType.CLOSED)
		      {
		    	  output = "";
		    	  error = "restart_closed";
		      }
		      else
		    	  {
		    	  output = getRequestOutput(procstr+"\n",reader,writer,ReadType.READ);
		    	  
		    	  }
			  break;
			
			case NEXT:
			    if (active == ActiveType.OPEN)
			    { 
				output = getRequestOutput("\n",reader,writer,ReadType.READ);
			    }
			    else if (active == ActiveType.PENDING)
			    {
			        output = "";
			        error="not_initialised";
			    }
			    else
			    {error = "invalid_id";
			    output="";
			    }
			     break;
			
			case CLOSE:
				if (active == ActiveType.OPEN)
				{
				    output = getRequestOutput("n\n",reader,writer,ReadType.NOREAD);
				    proc.destroy();
				   CoinventConfig.setProcClosed(id);
				}
				else if (active == ActiveType.PENDING)
				{
					output = "";
					error = "not_initialised";
				}
				else
				{
					error = "close_non_active";
				    output ="";
				}
			    break;
			    
			case NOACTION:
				output="";
				error="empty_request";
				break;
			    
			default:
				
				output = "";
				error = "invalid_request";
				break;
			}
			
			ArrayMap cargo = getHdtpCargo(id,output,error);
			//arraymap output???
			//ArrayMap cargo = new ArrayMap("output", output+"\nid = "+Integer.toString(id));
		out = new JsonResponse(webRequest,cargo);
		} 
			
			
			
			
		else
		{	
			ArrayMap cargo = getHdtpCargo(id,"","invalid_id");
			//ArrayMap cargo = new ArrayMap("output", "id not valid: id = "+Integer.toString(id));
			out = new JsonResponse(webRequest,cargo);
		}
		WebUtils2.sendJson(out,webRequest);
	}
		
		
	
		
	
}

