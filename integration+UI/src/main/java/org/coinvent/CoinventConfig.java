package org.coinvent;

import java.io.File;
import java.util.Map;

import org.coinvent.dumb.DumbActor;
import org.coinvent.web.ICoinvent;

import winterwell.utils.containers.ArrayMap;

import com.winterwell.utils.io.FileUtils;
import com.winterwell.utils.io.Option;

public class CoinventConfig {

	@Option
	public int port = 8200;
	
	@Option
	public File webAppDir = new File(".").getAbsoluteFile();
	
	public Map<String,Class<? extends ICoinvent>> actor2code = new ArrayMap(
			"dumb", DumbActor.class
			);

	@Option
	public String baseUrl = "http://localhost:"+port;
	
}
