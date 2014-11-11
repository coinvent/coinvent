package org.coinvent.actor;

public abstract class ACoinvent implements ICoinvent, 
IBaseActor, IBlendActor, IConsistencyActor, IModelActor, IQualityActor, IWeakenActor {
	
	@Override
	public IBaseActor getBaseActor() {
		return this;
	}
	@Override
	public IBlendActor getBlendActor() {
		return this;
	}
	@Override
	public IModelActor getModelActor() {
		return this;
	}
	@Override
	public IQualityActor getQualityActor() {
		return this;
	}
	@Override
	public IWeakenActor getWeakenActor() {
		return this;
	}

	@Override
	public IConsistencyActor getConsistencyActor() {
		return this;
	}

}
