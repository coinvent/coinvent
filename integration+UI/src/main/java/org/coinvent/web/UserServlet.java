package org.coinvent.web;

import org.coinvent.data.DataLayerFactory;
import org.coinvent.data.User;

import com.google.gson.Gson;
import com.winterwell.utils.containers.SharedStatic;

import creole.data.XId;
import winterwell.utils.web.WebUtils2;
import winterwell.web.WebEx;
import winterwell.web.ajax.JsonResponse;
import winterwell.web.app.WebRequest;

public class UserServlet extends AServlet {

	private User user;
	private String userName;

	Gson gson = SharedStatic.get(Gson.class);
	
	@Override
	public void doPost(WebRequest state) throws Exception {
		String[] bits = state.getSlugBits();
		userName = bits[1];
		if ( ! userName.contains("@")) userName+="@coinvent";
		user = DataLayerFactory.get().getUser(userName);

		if (state.getAction()!=null) doAction(state);

		String json = gson.toJson(user);
		JsonResponse jr = new JsonResponse(state, null);
		jr.setCargoJson(json);
		// send back json		
		WebUtils2.sendJson(jr, state);
	}

	private void doAction(WebRequest state) {
		if (state.actionIs("create")) {
			if (user!=null) throw new WebEx.E40X(400, "Already exists", new Exception());
			user = DataLayerFactory.get().getCreate(new XId(userName));
		}
	}

}
