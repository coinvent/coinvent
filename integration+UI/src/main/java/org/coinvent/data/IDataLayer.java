package org.coinvent.data;

import java.util.List;

import creole.data.XId;

public interface IDataLayer {

	User getUser(XId user);

	List<XId> getConcepts(XId user);

	List<XId> getUserJobs(XId user);

	List<XId> getConceptJobs(XId concept);

	Concept getConcept(XId theoryName);

	IJob getJob(XId id);

	User getCreateUser(XId xid);

	Concept getCreateConcept(User user, String conceptName);

}