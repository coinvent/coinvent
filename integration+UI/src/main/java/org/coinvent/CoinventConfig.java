package org.coinvent;

import java.io.File;
import java.util.Map;

import org.coinvent.actor.ICoinvent;
import org.coinvent.impl.chimera.ChimeraActor;
import org.coinvent.impl.chimera.ChimeraActorBuggy;
import org.coinvent.impl.dumb.DumbActor;
import org.coinvent.impl.hets.HETSActor;

import winterwell.utils.containers.ArrayMap;

import com.winterwell.utils.io.FileUtils;
import com.winterwell.utils.io.Option;

public class CoinventConfig {

	@Option
	public int port = 8200;
	
	@Option
	public File webAppDir = FileUtils.getWorkingDirectory();
	
	public Map<String,Class<? extends ICoinvent>> actor2code = new ArrayMap(
			"dumb", DumbActor.class,
			"hets", HETSActor.class,
			"chimera", ChimeraActor.class,
			"chimera.boggy", ChimeraActorBuggy.class
			);

	@Option
	public String baseUrl = "http://localhost:"+port;
	
}
