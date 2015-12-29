package org.coinvent.cmd;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;

import org.coinvent.CoinventConfig;
import org.coinvent.ProcessActiveTriple;
import org.coinvent.HdtpRequests.HdtpRequest;
import org.coinvent.HdtpRequests.ReadType;
import org.coinvent.ProcessActiveTriple.ActiveType;

import com.winterwell.utils.io.FileUtils;
import com.winterwell.utils.Proc;

import winterwell.utils.Utils;
import winterwell.utils.reporting.Log;

/**
 * Run HDTP
 * Status: Sketch! Waiting on getting the hdtp code!
 * 
 * @requires:
 *  - SWIProlog (swipl) installed at /usr/bin/swipl
 *  - HDTP installed at /home/ewen
 * 
 * @author daniel
 *
 */
public class HDTPCommand {

	String SWIPL = "/usr/bin/swipl";
	File HDTP = new File("/home/ewen/HDTP_coinvent/hdtp.pro");
	
	File input1;
	File input2;
	
	Proc proc;
	
	void next() {
		// send a line-break to the process
		Writer input = proc.getInput();
		try {
			input.write("\n");
			input.flush();			
		} catch (IOException e) {
			throw Utils.runtime(e);
		}		
	}
	
	public void close() {
		FileUtils.close(proc);
		proc = null;
	}
	
	void run() {
		String cmd = "((read_casl(\\\""+input1.getAbsolutePath()+"\\\",\\\""+input2.getAbsolutePath()+"\\\",Hdtp),gen_simple_casl(Hdtp),nl,print('NEXT'),nl,get_char(':'));(nl,print('FINISHED'),nl))";
		String procstr = SWIPL+" --quiet -G0K -T0K -L0K -s "+HDTP.getAbsolutePath()+" -t \""+ cmd + "\"";
		proc = new Proc(procstr);
		proc.setRedirectErrorStream(true); // why??
		proc.run();
	}
	
	public String getOutput() {
		// wait??
		String output = proc.getOutput();
		return output;
	}

}
