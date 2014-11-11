package org.coinvent.impl.cyc;

import java.io.File;
import java.util.Set;

import org.coode.owlapi.manchesterowlsyntax.ManchesterOWLSyntaxOntologyFormat;
import org.semanticweb.owlapi.apibinding.OWLManager;
import org.semanticweb.owlapi.model.IRI;
import org.semanticweb.owlapi.model.OWLClass;
import org.semanticweb.owlapi.model.OWLClassAxiom;
import org.semanticweb.owlapi.model.OWLDataFactory;
import org.semanticweb.owlapi.model.OWLOntology;
import org.semanticweb.owlapi.model.OWLOntologyCreationException;
import org.semanticweb.owlapi.model.OWLOntologyFormat;
import org.semanticweb.owlapi.model.OWLOntologyManager;
import org.semanticweb.owlapi.model.OWLOntologyStorageException;

import com.winterwell.utils.io.FileUtils;

/**
 * OpenCyc can be downloaded in Owl (RDF/XML) from: 
 * http://www.cyc.com/platform/opencyc/downloads
 * @author daniel
 *
 */
public class ConvertToManchesterSyntax {

	public static void main(String[] args) throws OWLOntologyStorageException, OWLOntologyCreationException {
		File file = new File("/home/daniel/winterwell/coinvent/cyc/opencyc-latest.owl");
		assert file.exists();
		OWLOntologyManager manager = OWLManager.createOWLOntologyManager();
		
		OWLOntology ontology = manager.loadOntologyFromOntologyDocument(file);
		OWLOntologyFormat format = manager.getOntologyFormat(ontology);
	    System.out.println("    format: " + format);

		ManchesterOWLSyntaxOntologyFormat manSyntaxFormat =
		                                         new ManchesterOWLSyntaxOntologyFormat();

		if(format.isPrefixOWLOntologyFormat()) {
	        manSyntaxFormat.copyPrefixesFrom(format.asPrefixOWLOntologyFormat());
	    }

//		File file2 = FileUtils.changeType(file, "man.owl");
//		IRI iri = IRI.create(file2);
//		manager.saveOntology(ontology, manSyntaxFormat, iri);
//	    System.out.println("Manchester syntax: --- saved in Manchester.owl");
		
		OWLDataFactory factory = ontology.getOWLOntologyManager().getOWLDataFactory();
		IRI iri = IRI.create("http://sw.opencyc.org/concept/Mx4rvVjfU5wpEbGdrcN5Y29ycA");
		OWLClass klass = factory.getOWLClass(iri);
		Set<OWLClassAxiom> axioms = ontology.getAxioms(klass);
		for (OWLClassAxiom owlClassAxiom : axioms) {
			System.out.println(owlClassAxiom);
		}
	}
}
