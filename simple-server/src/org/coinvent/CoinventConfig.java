package org.coinvent;

import java.io.File;

import com.winterwell.utils.io.FileUtils;
import com.winterwell.utils.io.Option;
import java.util.Hashtable;

public class CoinventConfig {

	@Option
	public int port = 8200;
	
	@Option
	public File webAppDir = FileUtils.getWorkingDirectory();	

	@Option
	public String baseUrl = "http://localhost:"+port;
	
	private static int counter;
	private static Hashtable<Integer,Process> processes;
	
	public CoinventConfig()
	{
		processes = new Hashtable<Integer,Process>();
		counter = 1;
	}
	
	public synchronized static Process getProc(int id)
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
	
	public synchronized static int setProc(Process proc)
	{
		int id = counter;
		counter++;
		processes.put(id,proc);
	    return id;
	}
}
