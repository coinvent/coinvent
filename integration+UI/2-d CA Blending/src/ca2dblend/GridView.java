package ca2dblend;



import ca2dblend.Location;
import ca2dblend.Field;
import ca2dblend.Replication;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import java.awt.event.MouseEvent;
import javax.swing.JPopupMenu;
import java.awt.event.MouseListener;



public class GridView extends JFrame 
{
	
	private static final long serialVersionUID = 1L;

	// Colors used for dead locations.
    private static final Color DEAD_COLOUR = Color.white;

    private FieldView fieldView;
    private int step;
    private Field field;
    private JCheckBox inheritButton;	
    private JCheckBox aliveButton;	
    
    /**
     * Create a view of the given width and height.
     * @param height The simulation's height.
     * @param width  The simulation's width.
     */
    public GridView(int height, int width)
    {
        setTitle("2d Cellular Automata Blend");

        inheritButton = new JCheckBox("Inherit only from Alive Neighbours");
        inheritButton.setMnemonic(KeyEvent.VK_C); 
        inheritButton.setSelected(false);
        aliveButton = new JCheckBox("Inherit only if Alive.   "+"Step = "+Integer.toString(step));
        aliveButton.setMnemonic(KeyEvent.VK_C); 
        aliveButton.setSelected(false);
        setLocation(20, 50);
        fieldView = new FieldView(height, width);
        Container contents = getContentPane();
       
        contents.add(aliveButton, BorderLayout.NORTH);
        contents.add(fieldView, BorderLayout.CENTER);
        contents.add(inheritButton, BorderLayout.SOUTH);
        pack();
        setVisible(true);
    }
    
    
    
    public void showStatus(int step, Field field)
    {
        if(!isVisible()) {
            setVisible(true);
        }            
        fieldView.paint_field(field);
        fieldView.repaint();
    }

  
    /**
     * Provide a graphical view of a rectangular field. This is 
     * a nested class (a class defined inside a class) which
     * defines a custom component for the user interface. 
     */
    private class FieldView extends JPanel  implements MouseListener, ActionListener, ItemListener
    {

    	
    	
    	/**
		 * 
		 */
		private static final long serialVersionUID = 1L;
		private final int GRID_VIEW_SCALING_FACTOR = 6;
		private JPopupMenu popupMenu;
        private int gridWidth, gridHeight;
        private int xScale, yScale;
        Dimension size;
        private Graphics g;
        private Image fieldImage;
        private Location grid_location;
        private boolean animate;
        private boolean conway;
        private boolean inherit = false;
        private boolean aliveonly = false;
        private Replication global_repl;
       
        private Timer timer = new Timer(20, this);
        
        
        
        
        /**
         * Create a new FieldView component.
         */
        public FieldView(int height, int width)
        {
            gridHeight = height;
            gridWidth = width;
            size = new Dimension(0, 0);
            addMouseListener(this);
            grid_location = new Location(0,0);
            field = new Field(height,width);
            field.clear();
            animate = false;
            popupMenu = new JPopupMenu();
            inheritButton.addItemListener(this);
            aliveButton.addItemListener(this);
        }  
              
        public void itemStateChanged(ItemEvent e) {
           
            Object source = e.getItemSelectable();

            boolean b_aliveButton = false;
            boolean b_inheritButton = false;
            
            if (source == inheritButton) {
                  b_inheritButton = true;
            } else if (source == aliveButton)
            {
            	b_aliveButton = true;
            }
            
            if (e.getStateChange() == ItemEvent.DESELECTED)
            {
            	if (b_inheritButton)
            		{inherit = false;}
            	else if (b_aliveButton)
            	{aliveonly = false;}
            } 
            
            if (e.getStateChange() == ItemEvent.SELECTED)
            {
            	if (b_inheritButton)
            		{inherit = true;}
            	else if (b_aliveButton)
            	{aliveonly = true;}
            } 
        }
        
        
        public void actionPerformed(ActionEvent e) {
        	repaint();
        	String message = e.getActionCommand();
        	int i,j;
        	
        	if (message == "Show replication info")
        	{
        		if (global_repl != null)
        		{
        			
        			JOptionPane.showMessageDialog(null,(global_repl.getScheme_message()),
        					"Replication Scheme",JOptionPane.WARNING_MESSAGE);
        		}
        		
        	}
        	
        	
        	if (message == "Run as Conway") 
        	{
        		conway = true;
        		timer.start();
        		animate = true;
        	}
        	
        	if (message == "Run as Blend") 
        	{
        		conway = false;
        		timer.start();
        		animate = true;
        	}
        	
        	
        	if (animate && (step <300))
        	{
        	step++;
        	aliveButton.setText("Inherit only if Alive.   "+"Step = "+Integer.toString(step));
        	for (i = 0;i<field.getDepth();i++){
                	for (j = 0; j< field.getWidth();j++){
                		field.getObjectAt(i, j).act(conway,inherit,aliveonly);
                	}
        		}

        	for (i = 0;i<field.getDepth();i++){
                    	for (j = 0; j< field.getWidth();j++){
                    		field.getObjectAt(i, j).actupdate();
                    	}
        	}
                	paint_field(field);
                	repaint();
                
        	} 
        	else if (animate && (step >=300))
        			{
        		step =0;
        		animate = false;
        		conway = false;
        		timer.stop();
        			}
        }	
    
               
        
        public void paint_field(Field field)
        {
        	preparePaint();
        	for(int row = 0; row < field.getDepth(); row++) {
        		for(int col = 0; col < field.getWidth(); col++) {
        			Replication repl = field.getObjectAt(row, col);
        			if(repl.getAlive()) {
        				drawMark(col, row, repl.getColour(conway));
        			}
        			else {
        				drawMark(col, row, DEAD_COLOUR);
        			}
        		}
        	}
        }
      
        /**
         * Tell the GUI manager how big we would like to be.
         */
        public Dimension getPreferredSize()
        {
            return new Dimension(gridWidth * GRID_VIEW_SCALING_FACTOR,
                                 gridHeight * GRID_VIEW_SCALING_FACTOR);
        }

        /**
         * Prepare for a new round of painting. Since the component
         * may be resized, compute the scaling factor again.
         */
        public void preparePaint()
        {
            if(! size.equals(getSize())) 
        	{  // if the size has changed...
                size = getSize();
                fieldImage = fieldView.createImage(size.width, size.height);
                g = fieldImage.getGraphics();

                xScale = size.width / gridWidth;
                if(xScale < 1) {
                    xScale = GRID_VIEW_SCALING_FACTOR;
                }
                yScale = size.height / gridHeight;
                if(yScale < 1) {
                    yScale = GRID_VIEW_SCALING_FACTOR;
                }
            }
        }
        
        /**
         * Paint on grid location on this field in a given color.
         */
        public void drawMark(int x, int y, Color color)
        {
            g.setColor(color);
            g.fillRect(x * xScale, y * yScale, xScale-1, yScale-1);
        }

        /**
         * The field view component needs to be redisplayed. Copy the
         * internal image to screen.
         */
        public void paintComponent(Graphics g)
        {
            if(fieldImage != null) {
                Dimension currentSize = getSize();
                if(! size.equals(currentSize)) {
                    // Rescale the previous image.
                    paint_field(field);	
                }
                g.drawImage(fieldImage, 0, 0, null);
            }
            
        }
        
        public void mouseClicked(MouseEvent e) {
        	
        	JMenuItem item;

        	if ((e.getModifiers() == MouseEvent.BUTTON1_MASK))
        	{
        		int col = e.getX()/xScale;
         	    int row = e.getY()/yScale;
         	
         		grid_location.setRow(row);
         		grid_location.setCol(col);
         		Replication repl = field.getObjectAt(grid_location);
         		
        		if (repl != null)
        		{
        		
        			repl.setAlive(!repl.getAlive());
        			repl.setallAlivenext();
        			if (repl.getAlive()){
        				drawMark(col,row,repl.getColour(conway)); 
        			} else
        			{
        				drawMark(col,row,DEAD_COLOUR);
        			}
        			repaint();
        			
        			
        		}
        	}
        	if ((e.getModifiers() == MouseEvent.BUTTON3_MASK))
        	{
        		int col = e.getX()/xScale;
         	    int row = e.getY()/yScale;
         	
         	    grid_location.setRow(row);
        		grid_location.setCol(col);
        		global_repl = field.getObjectAt(grid_location);	
        			
         	   popupMenu.removeAll();
   			popupMenu.add(item = new JMenuItem("Run as Conway"));
   			item.setHorizontalTextPosition(JMenuItem.RIGHT);
   			item.addActionListener(this);
   			
   			
			popupMenu.add(item = new JMenuItem("Run as Blend"));
			item.setHorizontalTextPosition(JMenuItem.RIGHT);
			item.addActionListener(this);
        		


			popupMenu.add(item = new JMenuItem("Show replication info"));
			item.setHorizontalTextPosition(JMenuItem.RIGHT);
			item.addActionListener(this);
			
        			popupMenu.show(e.getComponent(), e.getX(), e.getY());
        		
        	}
        	
        	
        }		
    	
     	
         public void mousePressed(MouseEvent e) {
        	
         }
          
         public void mouseReleased(MouseEvent e) {
        		
         }
         
         public void mouseEntered(MouseEvent e) {
        	         }
         
         public void mouseExited(MouseEvent e) {
         }
          
          
        
    }
    

   

    
}

