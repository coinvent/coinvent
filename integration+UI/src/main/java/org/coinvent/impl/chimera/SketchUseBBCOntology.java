package org.coinvent.impl.chimera;

import java.io.InputStream;

import org.apache.jena.riot.RDFDataMgr;

import uk.ac.ebi.brain.core.Brain;
import uk.ac.ebi.brain.error.BadPrefixException;
import uk.ac.ebi.brain.error.ExistingEntityException;
import uk.ac.ebi.brain.error.NewOntologyException;

import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.rdf.model.ResIterator;
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.util.FileManager;
import com.winterwell.utils.io.FileUtils;

/**
 * Status: doesn't work
 * @author daniel
 *
 */
public class SketchUseBBCOntology {
	
	public static void main(String[] args) throws NewOntologyException, BadPrefixException, ExistingEntityException {

//	 String inputFileName = FileUtils.getWorkingDirectory()+"/files/winterstein/chimera/bbc-animals.ttl";

	// Create a model and read into it from file 
	// "data.ttl" assumed to be Turtle.
	 String inputFileName = FileUtils.getWorkingDirectory()+"/files/chimera/Mallard.rdf";
	 
	 
//	Model model = RDFDataMgr.loadModel(inputFileName) ;
	// read the RDF ttl file
	 // create an empty model
//		// use the FileManager to find the input file
//	 InputStream in = FileManager.get().open( inputFileName );
//	if (in == null) {
//	    throw new IllegalArgumentException(
//	                                 "File: " + inputFileName + " not found");
//	}
//
//	Model model = ModelFactory.createDefaultModel();
//	model.read(in, null);

//	 Brain brain = new Brain();
//
//	 brain.learn(inputFileName);
	 
//	{
//		ResIterator iter = model.listSubjects(); //WithProperty(VCARD.FN);
//		while (iter.hasNext()) {
//		    Resource r = iter.nextResource();
//		    System.out.println(r.getLocalName()+"\t"+r.getURI());
//		}
//	}
	 
//	ResIterator iter = model.listResourcesWithProperty(); //Subjects(); //WithProperty(VCARD.FN);
//	while (iter.hasNext()) {
//	    Resource r = iter.nextResource();
//	    System.out.println(r.getLocalName()+"\t"+r.getURI());
//	}
//	// write it to standard out
//	model.write(System.out);
}

}
