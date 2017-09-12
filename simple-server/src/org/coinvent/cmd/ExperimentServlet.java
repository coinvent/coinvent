package org.coinvent.cmd;


import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.Random;

import org.apache.commons.lang3.ArrayUtils;
import org.coinvent.IServlet;

import com.winterwell.utils.containers.ArrayMap;
import com.winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;

import com.winterwell.utils.io.FileUtils;
import com.winterwell.utils.web.WebUtils2;



public class ExperimentServlet implements IServlet {

    	private static final int NUM_EXPERIMENTS = 6;
		private InputFiles[] inputfile;
	    Random randomNum;
		private void setupInputFiles() {
			
			File l = FileUtils.getWorkingDirectory();
			String path = l.getAbsolutePath();
			inputfile=new InputFiles[NUM_EXPERIMENTS];
			inputfile[0] = new InputFiles(path+"/web/static/experiment_files/0");
			inputfile[1] = new InputFiles(path+"/web/static/experiment_files/1");
			inputfile[2] = new InputFiles(path+"/web/static/experiment_files/2");
			inputfile[3] = new InputFiles(path+"/web/static/experiment_files/3");
			inputfile[4] = new InputFiles(path+"/web/static/experiment_files/4");
			inputfile[5] = new InputFiles(path+"/web/static/experiment_files/5");
		/*	inputfile[6] = new InputFiles(path+"/web/static/experiment_files/6");
			inputfile[7] = new InputFiles(path+"/web/static/experiment_files/7");
			inputfile[8] = new InputFiles(path+"/web/static/experiment_files/8");
			inputfile[9] = new InputFiles(path+"/web/static/experiment_files/9");*/
			
		}
		
		private int get_new_integer(Integer[] used,String s){
			randomNum=new Random();
			if (s == null)
			{
			    return randomNum.nextInt(NUM_EXPERIMENTS);
			}
			
		    Integer[] stat_inps = new Integer[NUM_EXPERIMENTS];
		    for (int i=0;i<NUM_EXPERIMENTS;i++){
		    	stat_inps[i] = i;
		    }
			for (String n : s.split(" ")) {
				  int num=0;
				  try
				  {
				    num = Integer.parseInt(n);
				  }
				  catch (NumberFormatException e)
				  {}
				  finally
				  {
					  int ind=0;
					  for (int i=0;i<stat_inps.length;i++)
					  {
						  if (stat_inps[i]==num)
						  {
							  ind = i;
							  break;
						  }
					  }
					  stat_inps = ArrayUtils.remove(stat_inps, ind);
				  }
			}
			
			
		    int res = randomNum.nextInt(stat_inps.length);
			
			return stat_inps[res];
			
		}
		
		@Override
		public void doPost(WebRequest webRequest) throws Exception {
			randomNum = new Random();
			setupInputFiles();
			
			if (webRequest.actionIs("example"))
			{
				File l = FileUtils.getWorkingDirectory();
				String path = l.getAbsolutePath();
				InputFiles i = new InputFiles(path+"/web/static/experiment_files/example");
				try {
					ArrayMap cargo = new ArrayMap(				
							"stheorem", i.source_theorem				
							);
					
						
						cargo.put("slemma", i.source_lemma);
						cargo.put("ttheorem", i.target_theorem);
						cargo.put("tlemma", i.target_lemma);
						cargo.put("stheory", i.source_theory);
						cargo.put("ttheory", i.target_theory);
					    cargo.put("result", "yes");
					    cargo.put("file_id",i.file_id);
					
					JsonResponse jr = new JsonResponse(webRequest, cargo);
					WebUtils2.sendJson(jr, webRequest);
					
				}
			     catch (IOException e) {
					e.printStackTrace();
				 
				}
				
			}
			
			
			if (webRequest.actionIs("get"))
			{
				
				
				
				//Put file ids in here - sending them too....
				//under key "used"
				String numstr = (webRequest.get("used"));
				//int num =Integer.parseInt(numstr.trim());
				Integer[] used = new Integer[5];
				int num = get_new_integer(used,numstr);
			    InputFiles i = inputfile[num];
			    String tlemma,result;
			    
			    int res = randomNum.nextInt(2);
			    boolean random = (res == 1);
			    if (random)
			    {
			    	result="yes";
			    	tlemma = i.target_lemma;
			    }
			    else
			    {
			    	result="no";
			    	tlemma= "No viable analogy";
			    }
			    
			    
			try {
				ArrayMap cargo = new ArrayMap(				
						"stheorem", i.source_theorem				
						);
				
					
					cargo.put("slemma", i.source_lemma);
					cargo.put("ttheorem", i.target_theorem);
					cargo.put("tlemma", tlemma);
					cargo.put("stheory", i.source_theory);
					cargo.put("ttheory", i.target_theory);
				    cargo.put("result", result);
				    cargo.put("file_id",i.file_id);
				
				JsonResponse jr = new JsonResponse(webRequest, cargo);
				WebUtils2.sendJson(jr, webRequest);
				
			}
		     catch (IOException e) {
				e.printStackTrace();
			 
			}
			}
			if (webRequest.actionIs("save"))
			{
				 String timestamp = webRequest.get("timestamp");
				 String result = webRequest.get("result");
				 String file_id = webRequest.get("file_id");
				 String their_suggestion = webRequest.get("their_suggestion");
				 String correctness = webRequest.get("correctness");
				 String proveability = webRequest.get("proveability");
				 String amended_suggestion = webRequest.get("amended_suggestion");
				 String helpful = webRequest.get("helpful");
				 String creative = webRequest.get("creative");
				 
				 String all = "file_id = "+file_id+"\nresult = "+result+"\ntheir_suggestion = "+
						 "\ncorrectness = "+correctness+"\nproveability = "+proveability+"\namdended_suggestion = "+
						 amended_suggestion + "\nhelpful = "+helpful+"\ncreative = "+creative+"\n\n\n------------------------\n\n\n";
				 
				 try {
					 
					    File l = FileUtils.getWorkingDirectory();
						String path = l.getAbsolutePath();
						
						File m = new File(path+"/web/static/experiment_results/"+timestamp);
						if (!m.exists())
						{
							m.createNewFile();
						}
						
						
					    Files.write(Paths.get( path+"/web/static/experiment_results/"+timestamp), all.getBytes(), StandardOpenOption.APPEND);
					}catch (IOException e) {
						e.printStackTrace();
						
					}
				 
				 
			}
		}
	}
			
			    		
				
		

