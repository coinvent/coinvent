package org.coinvent.cmd;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Writer;

import com.winterwell.utils.ShellScript;
import com.winterwell.utils.StrUtils;
import com.winterwell.utils.Utils;
import winterwell.utils.reporting.Log;
import winterwell.utils.time.Dt;
import winterwell.utils.time.TUnit;
import winterwell.utils.web.WebUtils;

import com.winterwell.utils.Proc;
import com.winterwell.utils.io.FileUtils;

/**
 * Run HDTP from within Java
 * 
 * @requires:
 *  - SWIProlog (swipl), which can be installed on Debian/Ubuntu/Mint via apt-get
 *  - HDTP installed at ../HDTP_coinvent
 * 
 * @author daniel, ewen
 * @testedby {@link HDTPCommandTest}
 */
public class HDTPAmalCommand {

	
	public enum CMD {HDTP,AMALCASL,AMALOWL};
	
	String SWIPL = "swipl";
	static File HDTP = new File(FileUtils.getWorkingDirectory(), "../HDTP_coinvent/hdtp.pro");
	static File AmalgamsCASL = new File(FileUtils.getWorkingDirectory(), "../HDTP_coinvent/hdtp.pro");
	
	File input1;
	File input2;
	
	String sn1;
	String sn2;
	
	CMD cmd;
	
	public File getInput1() {
		return input1;
	}
	public File getInput2() {
		return input2;
	}
	
	
	
	@Override
	public String toString() {
		return "HDTPAmalCommand[proc="+proc+"]";
	}



	Proc proc;
	private Writer input;
	private BufferedReader output;
	
	public HDTPAmalCommand(CMD cmd, File f1, File f2, String sn1, String sn2) {
		this.input1 = f1;
		this.input2 = f2;
		assert f1.isFile() : f1;
		assert f2.isFile() : f2;
		this.sn1 = sn1;
		this.sn2 = sn2;
		this.cmd = cmd;
	}

	/**
	 * Advance to the next solution
	 */
	public void next() {
		proc.clearOutput();
		// send a line-break to the process		
		try {
			getInput().write("\n");
			input.flush();			
		} catch (IOException e) {
			throw Utils.runtime(e);
		}		
	}
	
	public void close() {
		FileUtils.close(input);
		FileUtils.close(output);
		FileUtils.close(proc);
		Log.d("HDTPAmal", "closed "+proc);
		proc = null;
	}
	
	public void run() throws IOException {
		
		/*  need to distinguigh what we're running here */
		switch (cmd)
		{case HDTP :
			String hcmd = "trace,notrace,((read_casl(\\\""+input1.getAbsolutePath()+"\\\",\\\""+input2.getAbsolutePath()+"\\\",Hdtp),gen_simple_casl(Hdtp),nl,print('NEXT'),nl,get_char(':'));(nl,print('FINISHED'),nl))";
			String procstr = SWIPL+" --quiet -G0K -T0K -L0K -s "+HDTP.getCanonicalFile()+" -t \""+ hcmd + "\"";
			Log.d(getClass().getSimpleName(), procstr);
			proc = new ShellScript(procstr);		
			proc.redirectErrorStream(true);
			this.proc = proc.start();
			break;
		
		case AMALCASL :
			//write input file
			
			Proc proc = new Proc("cp "+ input1.getAbsolutePath() + " "+"/home/ewen/Amalgamation/content.casl");
			proc.run();
			proc.waitFor(new Dt(5, TUnit.SECOND));
			proc.close();
			//PrintWriter pwriter = new PrintWriter("/home/ewen/Amalgamation/content.casl","UTF-8");
			//pwriter.println(get_contents(input1.getAbsolutePath()));
			//pwriter.close();
			//write settings file
			String file_post = "numModels = 1\nminIterationsGeneralize=1\nmaxIterationsGeneralize=20\n" +
					"eproverTimeLimit=4\ndarwinTimeLimit=0.1\nhetsExe=\'hets\'\nblendValuePercentageBelowHighestValueToKeep=0\nuseHetsAPI=0\nhetsUrl='http://localhost:8000/'";
			String file_content = "inputFile=\"/home/ewen/Amalgamation/content.casl\"\ninputSpaceNames = [\""+
			sn1+"\",\""+sn2+"\"]\n"+file_post;
			PrintWriter pwriter=  new PrintWriter("/home/ewen/Amalgamation/settings.py");
			pwriter.println(file_content);
			pwriter.close();
			
		    procstr = "cd /home/ewen/Amalgamation;/usr/bin/python /home/ewen/Amalgamation/run-blending.py"; 
		    Log.d(getClass().getSimpleName(), procstr);
			proc = new ShellScript(procstr);		
			proc.redirectErrorStream(true);
			this.proc = proc.start();
			break;
			
	
		
		case AMALOWL:
		break;
		
		default:
		break;
			}
	}
	
	private Writer getInput() {
		if (input==null) {
			input = proc.getInput(); 
		}
		return input;
	}

	protected void finalize() throws Throwable {
		try {
			close();
		} catch(Throwable ex) {
			// ignore
		}
	}
	
	public String getOutput() throws IOException {
		while(true) {
			String outs = proc.getOutput().trim();
			if (outs.endsWith("\'NEXT\'") || outs.endsWith("\'FINISHED\'")) {
				// trim the end
				outs = StrUtils.pop(outs, "\'NEXT\'");
				outs = StrUtils.pop(outs, "\'FINISHED\'");
				return outs;
			}
			if ( ! proc.isOutputting()) return outs;
		}
	}

	public Proc getProc() {
		return proc;
	}

}
