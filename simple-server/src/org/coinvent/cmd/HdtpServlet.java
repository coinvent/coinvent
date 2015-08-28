
package org.coinvent.cmd;





import org.coinvent.IServlet;
import org.coinvent.CoinventConfig;
import winterwell.utils.Proc;
import winterwell.utils.io.FileUtils;
import winterwell.utils.time.Dt;
import winterwell.utils.time.TUnit;
import winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;
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

	
	
	@Override
	public void doPost(WebRequest webRequest) throws Exception {
	
		JsonResponse out;
		String idString = webRequest.get("id");
		String input_file1 = webRequest.get("input1");
		String input_file2 = webRequest.get("input2");
		
		
		
		String output = "";
		String cmd = "load_analogy(multipletest,A),gen_simple_casl(A),get_char(':')";
		int id = 0;
		String procstr = "/usr/bin/swipl --quiet -G0K -T0K -L0K -s /home/ewen/HDTP_coinvent/hdtp.pro -t \""+cmd+"\"";
		
		System.out.println(procstr);
		Process proc = null;
		if (!(idString != null))
		{
			ProcessBuilder builder = new ProcessBuilder("/bin/bash");
			builder.redirectErrorStream(true);	
			proc = builder.start();
			id = CoinventConfig.setProc(proc);
		}
		else
		{
		    try {
		        id = Integer.parseInt(idString);
		    	proc = CoinventConfig.getProc(id);
			    procstr = "";
		    	}
		    	catch (NumberFormatException e){
		    		System.out.println("Id not valid");
		    	}
		}
		
		
		
		if (proc != null)
		{
			InputStream stdout = proc.getInputStream();
			OutputStream stdin = proc.getOutputStream();
		
			BufferedReader reader = new BufferedReader(new InputStreamReader(stdout));
			BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(stdin));
		
			writer.write(procstr+"\n");
			writer.flush();
		
			
			
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
				out = new JsonResponse(webRequest,output+"\nid = "+Integer.toString(id));
		} 
		else
		{	
			out = new JsonResponse(webRequest,"invalid");
		}
		WebUtils2.sendJson(out,webRequest);
	}
		
		
		
		
	
}

