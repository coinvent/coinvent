package org.coinvent.impl.chimera;

import java.util.List;

import org.coinvent.actor.ACoinvent;
import org.coinvent.actor.IBaseActor;
import org.coinvent.actor.IBlendActor;
import org.coinvent.actor.ICoinvent;
import org.coinvent.actor.IConsistencyActor;
import org.coinvent.data.BlendDiagram;
import org.coinvent.data.Concept;
import org.coinvent.data.ProofResults;
import org.coinvent.data.Score;
import org.coinvent.data.Sentence;

/**
 * Hack class to do Mouse-Fish, Octo-Zebra, etc.
 * @author daniel
 *
 */
public class ChimeraActor extends ACoinvent {

	@Override
	public BlendDiagram doBase(BlendDiagram bd) {
		// TODO common base animal. But not actually used
		return bd;
	}

	@Override
	public BlendDiagram doBlend(BlendDiagram bd) {
		// TODO head/tail depending on order!
		BlendDiagram blended = new BlendDiagram(bd);
		blended.blend = new Concept(bd.input1.getText()+" "+bd.input2.getText());
		return blended;
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
