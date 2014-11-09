package org.coinvent.impl.hets;

import java.io.File;
import java.util.List;
import java.util.Map;

import org.coinvent.actor.ACoinvent;
import org.coinvent.data.BlendDiagram;
import org.coinvent.data.Concept;
import org.coinvent.data.ProofResults;
import org.coinvent.data.Score;
import org.coinvent.data.Sentence;
import org.w3c.dom.Node;

public class HETSActor extends ACoinvent {

	@Override
	public BlendDiagram doBase(BlendDiagram bd) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public BlendDiagram doBlend(BlendDiagram bd) {
		HETSClient hc = new HETSClient();
		// TODO make a DOL file
		if (bd.url==null) {
			DOLIO dolio = new DOLIO();
//			File dolFile;
//			dolio.write(bd, dolFile);
			// upload it to be web-visible
		}
		Map<String, Node> name2theory = hc.processDOL(bd.url);
		// Create a new BlendDiagram
		return null;
	}

	@Override
	public ProofResults doTestConsistency(Concept concept, Sentence goal) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Object doGenerateModel(Concept concept) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Score doScore(Concept concept, List<Concept> models, String metric) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public BlendDiagram doWeaken(BlendDiagram diagram) {
		// TODO Auto-generated method stub
		return null;
	}

}
