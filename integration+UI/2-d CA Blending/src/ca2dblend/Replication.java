package ca2dblend;

import ca2dblend.Scheme;
import ca2dblend.Location;

import java.util.*;
import java.util.List;
import java.awt.*;


public class Replication {
	 private Scheme scheme;
	   private boolean alive;
	   private boolean nextalive;
	   private Field field;
	   private Location location;
	   
	   public String getScheme_message()
	   {
		     return scheme.getinfo();
	   }
	   
	   public Color getColour(boolean conway)
	   {
		   if (conway)
		   {return Color.black;}
		   else
		   {
			   int w=scheme.getWeight();
		       if (w>95)
		       {
		    	   return Color.red;
		       }
		       else if (w>90)
		       {
		    	   return Color.blue;
		       }
		       else if (w>80)
		       {
		    	   return Color.cyan;
		       }
		       else if (w>70)
		       {
		    	   return Color.gray;
		       }
		       else if (w>60)
		       {
		    	   return Color.green;
		       }
		       else if (w>50)
		       {
		    	   return Color.magenta;
		       }
		       else if (w>40)
		       {
		    	   return Color.orange;
		       }
		       else if (w>30)
		       {
		    	   return Color.yellow;
		       }
		       else if (w>20)
		       {
		    	   return Color.pink;
		       }
		       else if (w>10)
		       {
		    	   return Color.darkGray;
		       }
		       else if (w>5)
		       {
		    	   return Color.lightGray;
		       }
		       else return Color.black;
		   }
			   /*{return Color.getHSBColor(((float) (scheme.getWeight())/((float) 3)),
					   ((float) (scheme.getWeight())/((float) 5)),
					   ((float) (scheme.getWeight())/((float) 7)));
			   }*/
	   }
	   
	   public Replication(Field field, Location location)
	   {
	       alive = false;
	       this.field = field;
	       scheme = new Scheme();
	       setLocation(location);
	   }

	   public void setAlive(boolean b)
	   {
		   alive = b;
	   }

	   public void setallAlivenext()
	   {
		  nextalive = alive;   
	   }
	   
	   public boolean getAlive()
	   {
		   return alive;
	   }
	   
	   public void setLocation(Location newLocation)
	    {
	        if(location != null) {
	            field.clear(location);
	        }
	        location = newLocation;
	        if (field != null)
	        {	
	        	field.place(this, newLocation);
	        }
	    }
	   
	   public ArrayList<Replication> get_neighbours()
	   {
		   ArrayList<Replication> neighbourreplications  = new ArrayList<Replication>();
		   List<Location> ll = field.adjacentLocations(location);		   
		   Iterator<Location> i = ll.iterator();
		      while (i.hasNext()) {
			    neighbourreplications.add(field.getObjectAt(i.next()));
		      }
		      return neighbourreplications;
	   }
	   
	   public void act(boolean conway, boolean inherit, boolean aliveonly)
	    {
	       ArrayList<Replication> al = get_neighbours();
	       ArrayList<Scheme> schemes = new ArrayList<Scheme>();
	       Iterator<Replication> i = al.iterator();
	       int count = 0;
	       while (i.hasNext())
	    		   {
	    	            Replication r = i.next();
	    	   			if (!inherit) {schemes.add(r.scheme);}
	    	            
	    	            if (r.getAlive())
	    	   			{  if (conway)
	    	   			  {
	    	   				count++;
	    	   			   } else
	    	   			   {	
	    	   				   count =+ r.scheme.getWeight();
	    	   			   }
	    	   			if (inherit) {schemes.add(r.scheme);}
	    	   			}
	    		   }
	      
	       nextalive = scheme.act(alive,count,conway);
	       if ((!conway && nextalive && aliveonly) || (!conway && !aliveonly)) {scheme.blendmax(schemes);}
	       }
	   
	    public void actupdate()
	    {
	    	alive = nextalive;
	    }
	   
	   
}
	   
	 