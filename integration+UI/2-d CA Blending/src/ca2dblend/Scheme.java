package ca2dblend;

import java.util.*;


public class Scheme {
	private int underpopulate;
	private int overpopulate;
	private int weight;
	private int reproduce_low;
	private int reproduce_high;
	
	
	
	public static int randInt(int min, int max) {

	    // Usually this can be a field rather than a method variable
	    Random rand = new Random();

	    if (max<min){max=min;}
	    // nextInt is normally exclusive of the top value,
	    // so add 1 to make it inclusive
	    int randomNum = rand.nextInt((max - min) + 1) + min;

	    return randomNum;
	}
	
	public int getWeight()
	{
		return weight;
		
	}
	
	public String getinfo()
	{
		return "Die if fewer than "+(Integer.toString(underpopulate+1))+"\nor greater than "+(Integer.toString(overpopulate-1)
				)+" sum neighbour weights.\nReproduce if between "+(Integer.toString(reproduce_low))+" and "+(Integer.toString(reproduce_high))+" neighbours weights\n"+
				"This cell has weight: "+(Integer.toString(weight));

	}
	
	public Scheme()
	{
				
		weight = randInt(1,100);
		underpopulate = randInt(1,50);
		overpopulate = randInt(underpopulate+100,200);
		reproduce_low = randInt(underpopulate+1,underpopulate+10);
		reproduce_high = randInt(overpopulate-10,overpopulate);		
	}
	
	public boolean act(boolean alive, int count, boolean conway)
	{
	   if (conway){
		   if (count <= 1)
		   {
			  return false;
		   }
		   else if (count >= 4)
		   {
			   return false;
		   }
		   else if (!alive && (3 == count))
		   {
		       return true;
		   }
		   else if (!alive && (3 != count))
		   {
			   return false;   
		   }
		   else return alive;
	   }
	   else
  {
		   

		   
	   
	   
	   if (count <= underpopulate)
	   {
		  return false;
	   }
	   else if (count >= overpopulate)
	   {
		   return false;
	   }
	   else if (!alive && (count >= reproduce_low) && (count <= reproduce_high))
	   {
	       return true;
	   }
	   else if (!alive && (count <reproduce_low || count < reproduce_high))
	   {
		   return false;   
	   }
	   else return alive;}
	}
	
	
	void blend(ArrayList<Scheme> neighbourschemes)
	{
      int t_under = underpopulate;
      int t_over = overpopulate;
      int t_reproduce_low = reproduce_low;
      int t_reproduce_high = reproduce_high;
      int t_weight = weight;
      int new_under,new_over,new_reproduce_low,new_reproduce_high,new_weight;
      
      Iterator<Scheme> itr = neighbourschemes.iterator();
      int s = neighbourschemes.size();
      if (s!=0)
      {
      
      
	  while(itr.hasNext()) {
	         Scheme element = itr.next();
	         t_under = element.underpopulate++;
	         t_over = element.overpopulate++;
	         t_reproduce_low = element.reproduce_low++;
	         t_reproduce_high = element.reproduce_high++;
	         t_weight = element.weight++;
	      }
	  
	  new_under = t_under / s;
	  new_over = t_over / s;
	  new_reproduce_low = t_reproduce_low/s;
	  new_reproduce_high = t_reproduce_high/s;
	  new_weight = t_weight/s;
	  
	  while ((new_over - new_under) < 2)
	  {
		  if (new_under > 1)
		  {
			  new_under--;
	      } else
	      {
	    	if (new_over < 2997)
	      	{
	    	  new_over ++;
	      	}
	      }
	  }
	  
	  while (new_reproduce_low<=new_under)
	  {new_reproduce_low++;}
	  
	  while (new_reproduce_high>=new_over)
	  {new_reproduce_high--;}
	  
	  underpopulate = new_under;
	  overpopulate = new_over;
	  reproduce_low = new_reproduce_low;
	  reproduce_high = new_reproduce_high;
	  weight = new_weight;
	}}

	void blendmax(ArrayList<Scheme> neighbourschemes)
	{
      int t_under = underpopulate;
      int t_over = overpopulate;
      int t_reproduce_low = reproduce_low;
      int t_reproduce_high = reproduce_high;
      int t_weight = weight;
      int new_under,new_over,new_reproduce_low,new_reproduce_high,new_weight;
      
      Iterator<Scheme> itr = neighbourschemes.iterator();
      int s = neighbourschemes.size();
      if (s!=0)
      {
      
      
	  while(itr.hasNext()) {
	         Scheme element = itr.next();
	         if ((element.underpopulate) < t_under) {t_under = element.underpopulate;}
	         if ((element.overpopulate) > t_over) {t_over = element.overpopulate;}
	         if ((element.reproduce_low) < t_reproduce_low) {t_reproduce_low = element.reproduce_low;}
	         if ((element.reproduce_high) > t_reproduce_high) {t_reproduce_high = element.reproduce_high;}
	         t_weight = element.weight++;
	  }
	  
	  new_under = t_under;
	  new_over = t_over;
	  new_reproduce_low = t_reproduce_low;
	  new_reproduce_high = t_reproduce_high;
	  new_weight = t_weight/s;
	  
	  while ((new_over - new_under) < 2)
	  {
		  if (new_under > 1)
		  {
			  new_under--;
	      } else
	      {
	    	if (new_over < 2997)
	      	{
	    	  new_over ++;
	      	}
	      }
	  }
	  
	  while (new_reproduce_low<=new_under)
	  {new_reproduce_low++;}
	  
	  while (new_reproduce_high>=new_over)
	  {new_reproduce_high--;}
	  
	  underpopulate = new_under;
	  overpopulate = new_over;
	  reproduce_low = new_reproduce_low;
	  reproduce_high = new_reproduce_high;
	  weight = new_weight;
	}}

	void blendmin(ArrayList<Scheme> neighbourschemes)
	{
      int t_under = underpopulate;
      int t_over = overpopulate;
      int t_reproduce_low = reproduce_low;
      int t_reproduce_high = reproduce_high;
      int t_weight = weight;
      int new_under,new_over,new_reproduce_low,new_reproduce_high,new_weight;
      
      Iterator<Scheme> itr = neighbourschemes.iterator();
      int s = neighbourschemes.size();
      if (s!=0)
      {
      
      
	  while(itr.hasNext()) {
	         Scheme element = itr.next();
	         if ((element.underpopulate) > t_under) {t_under = element.underpopulate;}
	         if ((element.overpopulate) < t_over) {t_over = element.overpopulate;}
	         if ((element.reproduce_low) > t_reproduce_low) {t_reproduce_low = element.reproduce_low;}
	         if ((element.reproduce_high) < t_reproduce_high) {t_reproduce_high = element.reproduce_high;}
	         t_weight = element.weight++;
	  }
	  
	  new_under = t_under;
	  new_over = t_over;
	  new_reproduce_low = t_reproduce_low;
	  new_reproduce_high = t_reproduce_high;
	  new_weight = t_weight/s;
	  
	  while ((new_over - new_under) < 2)
	  {
		  if (new_under > 1)
		  {
			  new_under--;
	      } else
	      {
	    	if (new_over < 2997)
	      	{
	    	  new_over ++;
	      	}
	      }
	  }
	  
	  while (new_reproduce_low<=new_under)
	  {new_reproduce_low++;}
	  
	  while (new_reproduce_high>=new_over)
	  {new_reproduce_high--;}
	  
	  underpopulate = new_under;
	  overpopulate = new_over;
	  reproduce_low = new_reproduce_low;
	  reproduce_high = new_reproduce_high;
	  weight = new_weight;
	}}

}
