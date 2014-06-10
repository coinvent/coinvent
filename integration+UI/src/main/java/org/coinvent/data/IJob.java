package org.coinvent.data;

import java.io.File;

import com.winterwell.utils.threads.ATask.QStatus;



public interface IJob {

	Object getResult();

	QStatus getStatus();

	Id getId();

	Id getActor();

}
