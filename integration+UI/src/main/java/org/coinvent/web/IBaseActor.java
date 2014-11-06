package org.coinvent.web;

import org.coinvent.data.BlendDiagram;

/**
 * Given 2 Concepts, compute a common base Concept
 * @author daniel
 *
 */
public interface IBaseActor {

	BlendDiagram doBase(BlendDiagram bd);

}
