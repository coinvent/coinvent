package org.coinvent;

import java.sql.Timestamp;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.coinvent.HdtpRequests.ActiveType;

public class ProcessActiveTriple {
	
	
	public enum ActiveType
	{PENDING, OPEN, CLOSED}
	
	public Process process;
	public ActiveType active;
	public Timestamp timestamp; 
	
	public static void killDead (ConcurrentHashMap<Integer,ProcessActiveTriple> processes)
	{
		for (Map.Entry<Integer,ProcessActiveTriple> e:processes.entrySet())
		{
			int i = e.getKey();
			ProcessActiveTriple pa = e.getValue();
			Date date = new Date();	
			Timestamp now = new Timestamp(date.getTime());
			Timestamp then = pa.timestamp;
			then.setTime(then.getTime()+(3600*1000));
			if (then.before(now))
			{
			  pa.active = ActiveType.CLOSED;	
			  processes.put(i,pa);
			}				
		}
		
		for (Map.Entry<Integer,ProcessActiveTriple> e:processes.entrySet())
		{
			int i = e.getKey();
			ProcessActiveTriple pa = e.getValue();
			if (pa.active == ActiveType.CLOSED)
			{
				Process p = pa.process;
				if (p !=null)
					{
					p.destroy();
					}
				processes.remove(i);
			}
		}
	}
	
}
