package org.coinvent.actor;

public interface ICoinvent {

	IBaseActor getBaseActor();

	IBlendActor getBlendActor();
	
	IWeakenActor getWeakenActor();
	
	IModelActor getModelActor();
	
	IQualityActor getQualityActor();
	
	IConsistencyActor getConsistencyActor();
}
