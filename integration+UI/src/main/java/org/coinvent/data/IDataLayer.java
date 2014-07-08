package org.coinvent.data;

import java.util.List;


/**
 * All data-layer access is mediated via this interface
 * @author daniel
 *
 */
public interface IDataLayer {

	User getUser(Id user);

	List<Id> getConcepts(Id user);

	List<Id> getUserJobs(Id user);

	List<Id> getConceptJobs(Id concept);

	Concept getConcept(Id theoryName);

	IJob getJob(Id id);

	User getCreateUser(Id xid);

	Concept getCreateConcept(User user, String conceptName);

	IJob saveJob(IJob job);

}