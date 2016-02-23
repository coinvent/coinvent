package org.coinvent.cmd;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

import com.winterwell.utils.io.FileUtils;

public class InputFiles {
  public String source_theory;
  public String target_theory;
  public String source_theorem;
  public String source_lemma;
  public String target_theorem;
  public String target_lemma;
  public String file_id;
  
 private String read_file(String s){
	
	 		File l = FileUtils.getWorkingDirectory();
	 		s =  l.getAbsolutePath()+s;
			BufferedReader br = null;
			String result="";
			try {

				String sCurrentLine;
				
				br = new BufferedReader(new FileReader(s));

				while ((sCurrentLine = br.readLine()) != null) {
					result += (sCurrentLine+"\n");
				}

			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				try {
					if (br != null)br.close();
				} catch (IOException ex) {
					ex.printStackTrace();
				}
			}
			return result;

		}
	 
 
  
  
  
  public InputFiles(String filename){ 
	  try
	  {
		  
		  
	  for (String line : Files.readAllLines(Paths.get(filename))) {
		  String[] part = new String[6];
		  part = line.split("::");
		  switch (part[0])
		  {  
		  case "file_id":
		  	  file_id = part[1];
		       break;
		  case "source_location":
			  source_theory=read_file(part[1]);
			  break;
		  case "target_location":
			  target_theory=read_file(part[1]);
			  break;
		  case "source_theorem":
			  source_theorem=part[1];
			  break;
		  case "target_theorem":
			  target_theorem=part[1];
			  break;
		  case "source_lemma":
			  source_lemma=part[1];
		      break;
		  case "target_lemma":
			  target_lemma=part[1];
			  break;
		  default:
			  break;
		  }
	  	}
		
	  }
	  catch(IOException e) {
			e.printStackTrace();
			 
		
	  }
	  
	  
  }
  
}
