package org.coinvent;

import java.io.File;
import java.util.concurrent.ConcurrentHashMap;

import org.coinvent.HdtpRequests.ActiveType;

import com.winterwell.utils.io.FileUtils;
import com.winterwell.utils.io.Option;


public class CoinventConfig {

	@Option
	public int port = 8200;
	
	@Option
	public File webAppDir = FileUtils.getWorkingDirectory();	

	@Option
	public String baseUrl = "http://localhost:"+port;
	
	private static int counter;
	private static ConcurrentHashMap<Integer,ProcessActivePair> processes;
	
	public CoinventConfig()
	{
		processes = new ConcurrentHashMap<Integer,ProcessActivePair>();
		counter = 1;
	}
	
	public static ProcessActivePair getProc(int id)
	{
		// could do something cleverer here 
		// throw an exception or something
		if (processes.containsKey(id))
		{
		  return processes.get(id);
		}
		else
			return null;
	}
	
	public static int setProc(Process process)
	{
		int id = counter;
		ProcessActivePair pa = new ProcessActivePair();
		pa.process = process;
	    pa.active = ActiveType.OPEN;
		counter++;
		processes.put(id,pa);
	    return id;
	}
	
	public static void setProcClosed(int id)
	{
	   if (processes.containsKey(id))
	   {
		   ProcessActivePair pa = processes.get(id);
		   pa.active = ActiveType.CLOSED;
		   processes.put(id,pa);
	   }
	
	}
}
