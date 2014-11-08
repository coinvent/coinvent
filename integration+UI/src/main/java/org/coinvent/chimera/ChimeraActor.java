package org.coinvent.chimera;

import org.coinvent.data.BlendDiagram;
import org.coinvent.web.IBaseActor;
import org.coinvent.web.IBlendActor;
import org.coinvent.web.ICoinvent;

/**
 * Hack class to do Mouse-Fish, Octo-Zebra, etc.
 * @author daniel
 *
 */
public class ChimeraActor implements ICoinvent, IBlendActor, IBaseActor {

	@Override
	public BlendDiagram doBase(BlendDiagram bd) {
		// TODO common base animal. But not actually used
		return bd;
	}

	@Override
	public BlendDiagram doBlend(BlendDiagram bd) {
		// TODO head/tail depending on order!
		return null;
	}

	@Override
	public IBaseActor getBaseActor() {
		return this;
	}

	@Override
	public IBlendActor getBlendActor() {
		return this;
	}
	
}
