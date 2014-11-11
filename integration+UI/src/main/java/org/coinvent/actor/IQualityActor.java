package org.coinvent.actor;

import java.util.List;

import org.coinvent.data.Concept;
import org.coinvent.data.Score;

public interface IQualityActor {

	Score doScore(Concept concept, List<Concept> models, String metric);
}
