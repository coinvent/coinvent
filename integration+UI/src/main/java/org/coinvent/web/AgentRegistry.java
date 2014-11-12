package org.coinvent.web;

import org.coinvent.Coinvent;
import org.coinvent.actor.IBaseActor;
import org.coinvent.actor.IBlendActor;
import org.coinvent.actor.ICoinvent;
import org.coinvent.actor.IModelActor;

import winterwell.utils.TodoException;
import winterwell.utils.Utils;

/**
 * TODO Recognise HETS, HDTP etc. and allow for others.
 * 
 * Any unrecognised system is treated a manual/interactive
 * @author daniel
 *
 */
public class AgentRegistry {

	/**
	 * 
	 * @param actorName
	 * @return true if this is a known system, such as HETS.
	 * false for user names.
	 */
	public static boolean recognise(String actorName) {
		if (actorName==null) return false;
		Class<? extends ICoinvent> klass = Coinvent.app.getConfig().actor2code.get(actorName);
		if (klass!=null) {
			return true;
		}
		return false;
	}

	public static <Role> Role getActor(Class<Role> klass, String actorName) {
		try {
			Class<? extends ICoinvent> aClass = Coinvent.app.getConfig().actor2code.get(actorName);
			if (aClass==null) {
				return null;
			}
			ICoinvent topActor = aClass.newInstance();
			if (klass==IBaseActor.class) {
				return (Role) topActor.getBaseActor();
			}
			if (klass==IBlendActor.class) {
				return (Role) topActor.getBlendActor();
			}
			if (klass==IModelActor.class) {
				return (Role) topActor.getModelActor();
			}
			throw new TodoException(klass);
		} catch(Exception ex) {
			throw Utils.runtime(ex);
		}
	}

}
