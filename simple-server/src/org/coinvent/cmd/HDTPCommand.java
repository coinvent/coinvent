package org.coinvent.cmd;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.Writer;

import com.winterwell.utils.ShellScript;
import com.winterwell.utils.StrUtils;
import com.winterwell.utils.Utils;
import winterwell.utils.reporting.Log;

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
public class HDTPCommand {

	String SWIPL = "swipl";
	static File HDTP = new File(FileUtils.getWorkingDirectory(), "../HDTP_coinvent/hdtp.pro");
	
	File input1;
	File input2;
	
	public File getInput1() {
		return input1;
	}
	public File getInput2() {
		return input2;
	}
	
	
	
	@Override
	public String toString() {
		return "HDTPCommand[proc="+proc+"]";
	}



	Proc proc;
	private Writer input;
	private BufferedReader output;
	
	public HDTPCommand(File f1, File f2) {
		this.input1 = f1;
		this.input2 = f2;
		assert f1.isFile() : f1;
		assert f2.isFile() : f2;
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
		Log.d("HDTP", "closed "+proc);
		proc = null;
	}
	
	public void run() throws IOException {
		String cmd = "trace,notrace,((read_casl(\\\""+input1.getAbsolutePath()+"\\\",\\\""+input2.getAbsolutePath()+"\\\",Hdtp),gen_simple_casl(Hdtp),nl,print('NEXT'),nl,get_char(':'));(nl,print('FINISHED'),nl))";
		String procstr = SWIPL+" --quiet -G0K -T0K -L0K -s "+HDTP.getCanonicalFile()+" -t \""+ cmd + "\"";
		Log.d(getClass().getSimpleName(), procstr);
		proc = new ShellScript(procstr);		
		proc.redirectErrorStream(true);
		this.proc = proc.start();
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
