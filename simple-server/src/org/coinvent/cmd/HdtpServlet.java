
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
	
	
	private ArrayMap<String,String> getHdtpCargo(int id,String output,String error)
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
				System.out.println ("FStdout: " + outln);
				outln = reader.readLine();
			  
				if (outln.trim().equals("FINISHED"))
				{
					output="";
					break;
				}
				else if (outln.trim().equals("NEXT"))
				{
					break;
				}
				else
				{
					output += outln;
					output += "\n";
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
		//String demo_type = webRequest.get("demo");
		
		if ((request != null) && (request.trim().equals("demo")))
		{
			String s= "spec Base = sort Artifact; sort Location; sort Agent; pred is_located_on: Artifact * Location; ops artifact: Artifact; agent: Agent; location: Location; end interpretation I1: Base to Boat = Artifact |-> Boat,Location |-> BodyofWater,Agent |-> Person,is_located_on |-> is_located_on,artifact |-> boat,agent |-> person,location |-> bodyofwater interpretation I2: Base to House = Artifact |-> House,Location |-> Plot,Agent |-> Person,is_located_on |-> is_located_on,artifact |-> house,agent |-> person, location |-> plot spec blend = combine I1, I2";
			ArrayMap<String,String> cargo = getHdtpCargo(0,s,"demo output");
			//ArrayMap cargo = new ArrayMap("output", "id not valid: id = "+Integer.toString(id));
			out = new JsonResponse(webRequest,cargo);
		    WebUtils2.sendJson(out,webRequest);
		}
		else
		{
		if (analogy_name == null)
		{
		   analogy_name="\"generated\"";
		}
		
		String output = "";
		String error = "";
		String cmd = "((parse_casl(\'"+input_file1+"\n"+input_file2+"\',Hdtp),gen_simple_casl(Hdtp),nl,print('NEXT'),nl,get_char(':'));(nl,print('FINISHED'),nl))";
		int id = 0;
		String procstr = "/usr/bin/swipl --quiet -G0K -T0K -L0K -s /home/ewen/HDTP_coinvent/hdtp.pro -t \""+cmd+"\"";
		//swipl --quiet -G0 -T0 -L0 -s hdtp.pro -t "parse_casl('spec source = . a end spec target = . b end',Hdtp),gen_simple_casl(Hdtp),get_char(':')"
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
			
			
			
			
			ArrayMap<String,String> cargo = getHdtpCargo(id,output,error);
			//arraymap output???
			//ArrayMap cargo = new ArrayMap("output", output+"\nid = "+Integer.toString(id));
		out = new JsonResponse(webRequest,cargo);
		} 
			
			
			
			
		else
		{	
			ArrayMap<String,String> cargo = getHdtpCargo(id,"","invalid_id");
			//ArrayMap cargo = new ArrayMap("output", "id not valid: id = "+Integer.toString(id));
			out = new JsonResponse(webRequest,cargo);
		}
		
		WebUtils2.sendJson(out,webRequest);}
	}
		
		
	
		
	
}

