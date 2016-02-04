package org.coinvent.cmd;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.Arrays;

import org.coinvent.CoinventConfig;
import org.coinvent.ProcessActiveTriple;
import org.coinvent.HdtpRequests.HdtpRequest;
import org.coinvent.HdtpRequests.ReadType;
import org.coinvent.ProcessActiveTriple.ActiveType;

import com.winterwell.utils.io.FileUtils;
import com.winterwell.utils.Proc;
import com.winterwell.web.FakeBrowser;

import winterwell.utils.ShellScript;
import winterwell.utils.StrUtils;
import winterwell.utils.Utils;
import winterwell.utils.containers.ArrayMap;
import winterwell.utils.reporting.Log;
import org.apache.commons.lang3.StringEscapeUtils;

/**
 * Run HETS from within Java
 * 
 * @requires:
 *  - HETS installed at /usr/bin/hets and /usr/lib/hets
 * 
 * @author ewen
 * @testedby {@link HETSCommandTest}
 */

public class HETSCommand {

	 /* potential for local calling of HETS */
	private String localfile;
	private String localurl;
	
	public String getlocalfile()
	{
		return localfile;
	}
	
	void setlocalfile(String s)
	{
		localfile = s;
	}
	
	public String getlocalurl()
	{
		return localurl;
	}
	
	void setlocalurl(String s)
	{
		localurl = s;
	}
	
	public static String parseBlendFile(String blend) {
	    int start = blend.indexOf("</html>")+7;
	    String substr = blend.substring(start);
	    substr = substr.replaceAll("\n",";\n");
	    substr = substr.replaceAll("<br />","");
	    substr = substr.replaceAll("<small><em>","");
	    substr = substr.replaceAll("</em></small>","");
	    substr = StringEscapeUtils.unescapeHtml4(substr);
		return "spec blend = \n"+substr+";\nend";
	}
	
	public static ArrayMap parseHetsResponse(String output) {
		
		// look here for the response - then give back loads of urls as json....
		int start = output.indexOf("<title>")+7;
		int end = output.indexOf("</title>");
		String substr = output.substring(start,end);
		int startb = substr.indexOf("(")+1;
		int endb = substr.indexOf(")");
		String hetsident = substr.substring(startb,endb);
		String baseurl =  "http://pollux.informatik.uni-bremen.de:8000/"+hetsident;
		String svg = baseurl+"?svg";
		//wget from file again
		
		String blendfile = new FakeBrowser().getPage(baseurl+"?theory=3");
		String blend = parseBlendFile(blendfile);
		String theoryurl = baseurl+"?pp.het";
		String theory = new FakeBrowser().getPage(theoryurl);
		
		
		ArrayMap cargo = new ArrayMap(				
				"svg", svg				
				);
		
			cargo.put("blend", blend);
			cargo.put("theoryurl", theoryurl);
			cargo.put("theory", theory);
		
		
		return cargo;
		
	}
	
}



