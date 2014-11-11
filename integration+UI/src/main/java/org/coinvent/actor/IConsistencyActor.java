package org.coinvent.actor;

import org.coinvent.data.BlendDiagram;
import org.coinvent.data.Concept;
import org.coinvent.data.ProofResults;
import org.coinvent.data.Sentence;

public interface IConsistencyActor {

	ProofResults doTestConsistency(Concept concept, Sentence goal);
}
