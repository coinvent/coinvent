package org.coinvent.data;

import winterwell.web.app.WebRequest;

public class Job implements IJob {

	WebRequest request;
	private Object result;

	@Override
	public Object getResult() {
		return result;
	}

}
