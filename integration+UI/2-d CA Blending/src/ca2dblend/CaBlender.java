package ca2dblend;

import ca2dblend.GridView;
import ca2dblend.Field;

public class CaBlender {

	
	public static void main( String[] args )
	{

		GridView view = new GridView(80, 120);
		Field field = new Field(80, 120);
		view.showStatus(0, field);
		
	}		

}
