package ca2dblend;

import ca2dblend.Location;
import ca2dblend.Replication;
import java.util.LinkedList;
import java.util.List;




public class Field
{   
    private int depth, width;
    // Storage for the replication in the cells.
    private Replication[][] field;

    /**
     * Represent a field of the given dimensions.
     * @param depth The depth of the field.
     * @param width The width of the field.
     */
    public Field(int depth, int width)
    {
        this.depth = depth;
        this.width = width;
        field = new Replication[depth][width];
        for (int i=0;i<depth;i++)
         {for (int j=0;j<width;j++)
           { 
        	Location l = new Location(i,j);
        	field[i][j] = new Replication(this,l);
            }
          }
    }
    
    /**
     * Empty the field.
     */
    public void clear()
    {
        for(int row = 0; row < depth; row++) {
            for(int col = 0; col < width; col++) {
                field[row][col].setAlive(false);
            }
        }
    }
    
    public void copy_from(Field f_from)
    {
    	Location loc = new Location(0,0);
    	 for(int row = 0; row < depth; row++) {
             for(int col = 0; col < width; col++) {
            	 loc.setRow(row);
            	 loc.setCol(col);
            	 place(f_from.getObjectAt(loc),loc);
             }
         }
    }
    	
   
    
    
    /**
     * Clear the given location.
     * @param location The location to clear.
     */
    public void clear(Location location)
    {
        field[location.getRow()][location.getCol()].setAlive(false);
    }
    
  
    public void place(Replication repl, int row, int col)
    {
        place(repl, new Location(row, col));
    }
    
   
    public void place(Replication repl, Location location)
    {
    	field[location.getRow()][location.getCol()] = repl;
    }
    
  
    public Replication getObjectAt(Location location)
    {
        return getObjectAt(location.getRow(), location.getCol());
    }
    
  
    public Replication getObjectAt(int row, int col)
    {
        return field[row][col];
    }  
 
    
 

    /**
     * Return a  list of locations adjacent to the given one.
     * The list will not include the location itself.
     * All locations will lie within the grid.
     * @param location The location from which to generate adjacencies.
     * @return A list of locations adjacent to that given.
     */
    public List<Location> adjacentLocations(Location location)
    {
        assert location != null : "Null location passed to adjacentLocations";
        // The list of locations to be returned.
        List<Location> locations = new LinkedList<Location>();
        if(location != null) {
            int row = location.getRow();
            int col = location.getCol();
            for(int roffset = -1; roffset <= 1; roffset++) {
                int nextRow = row + roffset;
                if(nextRow >= 0 && nextRow < depth) {
                    for(int coffset = -1; coffset <= 1; coffset++) {
                        int nextCol = col + coffset;
                        // Exclude invalid locations and the original location.
                        if(nextCol >= 0 && nextCol < width && (roffset != 0 || coffset != 0)) {
                            locations.add(new Location(nextRow, nextCol));
                        }
                    }
                }
            }
           
           
        }
        return locations;
    }

    /**
     * Return the depth of the field.
     * @return The depth of the field.
     */
    public int getDepth()
    {
        return depth;
    }
    
    /**
     * Return the width of the field.
     * @return The width of the field.
     */
    public int getWidth()
    {
        return width;
    }
}
