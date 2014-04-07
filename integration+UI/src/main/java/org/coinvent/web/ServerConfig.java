package org.coinvent.web;

import java.io.File;

import winterwell.utils.io.FileUtils;
import winterwell.utils.io.Option;

public class ServerConfig {

	@Option
	int port;
	
	@Option
	File webAppDir = new File(".").getAbsoluteFile();
	
}
