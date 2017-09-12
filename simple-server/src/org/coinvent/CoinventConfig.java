package org.coinvent;

import java.io.File;
import java.sql.Timestamp;
import java.util.Date;
import java.util.concurrent.ConcurrentHashMap;

import org.coinvent.ProcessActiveTriple.ActiveType;

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
	
	@Deprecated // This isn't config -- move it to be with the Servlet
	private static ConcurrentHashMap<Integer,ProcessActiveTriple> processes;
	
	public CoinventConfig()
	{
		processes = new ConcurrentHashMap<Integer,ProcessActiveTriple>();
		counter = 1;
	}
	
	public static ProcessActiveTriple getProc(int id)
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
		ProcessActiveTriple pa = new ProcessActiveTriple();
		pa.process = process;
	    pa.active = ActiveType.OPEN;
	    Date date = new Date();
	    pa.timestamp = new Timestamp(date.getTime());
		counter++;
		processes.put(id,pa);
		ProcessActiveTriple.killDead(processes);
	    return id;
	}
	
	public static void setProcClosed(int id)
	{
	   if (processes.containsKey(id))
	   {
		   ProcessActiveTriple pa = processes.get(id);
		   pa.active = ActiveType.CLOSED;
		   processes.put(id,pa);
	   }
	
	}
}
