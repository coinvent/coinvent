package org.coinvent;

import java.io.File;

import com.winterwell.utils.io.FileUtils;
import com.winterwell.utils.io.Option;

public class CoinventConfig {

	@Option
	public int port = 8200;
	
	@Option
	public File webAppDir = FileUtils.getWorkingDirectory();	

	@Option
	public String baseUrl = "http://localhost:"+port;
	
}
