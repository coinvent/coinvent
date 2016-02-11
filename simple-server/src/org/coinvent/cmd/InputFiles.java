package org.coinvent.cmd;

public class InputFiles {
  public String source_location;
  public String target_location;
  public String source_theorem;
  public String source_lemma;
  public String target_theorem;
  public String target_lemma;
  
  public InputFiles(String filename){
	  source_location="a";
	  target_location="b";
	  source_theorem="c";
	  source_lemma="d";
	  target_theorem="e";
	  if (filename.trim()=="/web/static/experiment_files/1")
	  {
	  target_lemma="f";
	  }
	  else
	  {
		  target_lemma="g";
	  }
  }
  
}
