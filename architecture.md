
# Coinvent Architecture

Author: Daniel, with input from Ewen and Mihai   
Status: Draft   
Version: 0.1   

<!-- MarkdownTOC depth=2 -->

- Overview
- Languages / File Formats
- Core Object: The Partial Blend Diagram
- Components
- Architecture
- References

<!-- /MarkdownTOC -->

## Overview

This document presents the archictectural design for the integrated Coinvent system. It is currently a draft for discussion. It is due for delivery in June.

Please read the [Glossary / Jargon buster](http://ccg.doc.gold.ac.uk/research/coinvent/internal/?page_id=356) first. For further information, please see the reference documents listed at the end of this file.


## Core Object: The Partial Blend Diagram

The object type at the heart of Coinvent is the Blend Diagram. The specification is intentionally broad to support several use-cases.

Concepts are defined in CASL or OWL. Mappings between concepts are defined in DOL. Metadata is also defined in DOL. The Blend Diagram may be a single file, or several linked files, using DOL's support for urls.

A `Blend Diagram` consists of:

1. A Blended Concept
2. A set of Input Concepts (typically 2)
3. A Base Concept, which is a common base for all the Input Concepts
4. Mappings from the Base Concept to each of the Input Concepts.
5. Mappings from each of the Input Concepts to the Blended Concept.
6. Optional metadata about each of the Concepts, such as evaluation scores,  proof obligations, or relationship to other Concepts.

The Blended Concept *may* be a colimit, but it does not have to be.
The Base Concept *may* be found via anti-unification, but it does not have to be.

A `Partial Blend Diagram` is simply a Blend Diagram where any part may be missing or incomplete, and Concepts do not have to be consistent. The Partial Blend Diagram allows that blends may be developed (perhaps iteratively).

## Languages / File Formats

Coinvent will focus on human-readable text-file formats. 
A couple of formats for concepts will be supported, with the DOL language used to describe the connections between concepts.

### Connecting concepts: DOL (modified)
DOL (Distributed Ontology, Modeling and Specification Language) is a language for describing how ontologies connect. 
DOL is currently in development by Till Mossakowski's group. It is used by the HETS system.

#### DOL: Supported Language Terms

Coinvent does not need all the features of DOL, and so we specify a reduced subset of DOL which should be used. Sticking to a smaller set reduces the learning curve for new Coinvent users.

Briefly, the supported symbols are:

 - `logic` Specify the Concept language, e.g. `logic OWL`
 - `ontology` Start defining a Concept.
 - `end` Finish defining a Concept. 
 - `view` Specify a mapping between Concepts, e.g. `view MyView : A to B =`
 - `with` Start of a symbol mapping.
 - `combine` Compute the colimit, e.g. `ontology B = combine I1, I2`
 - `hide` Used in a mapping to drop a symbol.
 - `=`
 - `:`
 - `,` List separator.
 - `|->` Part of a mapping, e.g. `zero |-> 0`
 - `%predicate(value)%` An annotation on a sentence.
 - `%%` Starts a comment

#### DOL: Extra Conventions and Language Terms
There are some features Coinvent needs which DOL does not yet provide (see the project's [GitHub issue tracker](https://github.com/coinvent/coinvent/issues?labels=DOL+%2F+file-formats)). Where possible, we fit these within the current DOL specification by specifying non-standard annotations.

1. Dropping symbols from a Concept: `hide` can be used when defining a mapping to drop sentences as well as symbols.

2. Marking inconsistent sentences: by the annotation `%inconsistent%`

3. Marking relative importance of sentences: by the annotation `%importance(X)%`, where X is a number in the range [0,1]. How this is interpreted is tool dependent. It may be interpreted as a probability that the sentence holds.

4. Evaluating Concepts. That is, adding metadata which describes how good a concept is. Format TBD.
 
###  Mathematics: CASL

CASL is the first order logic language used by HETS. We will adopt it as the language Coinvent should use for mathematical concepts.

### Music: TBD
The music team are investigating the use of OWL by producing a worked example of cadence blending.

### Other Domains: OWL Manchester Syntax

The established OWL description logic, via the Manchester Syntax, should be used for other domains.


## Components

A Coinvent system will be made up of the following components.
A component can be "manual", which means a human being provides the result (using a web interface).

### User Portal
An interface through which the user drives the system.

Default implementation: To be developed.

### Blender: Given a Partial Blend Diagram, compute the Blend Concept

Default implementation: HETS

### Base Finder: Given 2 Concepts, compute a common base Concept

Default implementation: HDTP

### Example Finder: Given a Concept, find examples

Default implementation: Manual

### Concept Scorer: How good is a Concept?

Default implementations: 

 - HETS for automated consistency checks.
 - Manual for other scores.

### Concept Store: Store Concepts and Blend Diagrams

Must provide save and load over http.

Default implementation: 

 - File-system backed. Adding git to the file-system would provide integration with Ontohub.

## Architecture

### Independent components, linked via http APIs

Requirements:  

1. The components of the system may be developed in different languages.
2. The system should be easy to maintain and extend.

This suggests a loose coupling between components. The use of http-based APIs is an established way of achieving this. In particular, http-based APIs with a REST-like setup (i.e. the url follows a simple readable structure) and using JSON to encode data are now becoming the standard for modern software development. 

JSON will provide a wrapper for API-level information. JSON is not part of the file format for Blend Diagrams. Blend Diagrams are written in DOL + OWL or CASL, and sent within a JSON packet as JSON strings.

An added benefit of this architecture is that it provides flexibility regarding the hardware infrastructure. The components of the Coinvent system may be run either on a single server, or across multiple servers.

#### Software Wrapped as a Server

Software such as HDTP will be incorporated into this framework using a server which "wraps" the low-level software. E.g. the other components connect to the HDTP-server over http, and the server manages calling HDTP itself.

### Actor / Queue Pattern

Requirements:  

1. The components of the system call on each other to perform tasks...
2. ...but these tasks may be slow to complete. Since tasks may require human input (eg. a proof in an interactive theorem prover like Isabelle), a task
could even take days.

This means a standard call/response would timeout. We therefore adopt an actor / queue based pattern (see <https://en.wikipedia.org/wiki/Actor_model>). 

Each top-level component is an actor, which can send and receive messages to other actors. Each API request is marked as either *fast* or *slow*:

 - Fast messages get an immediate result within the http response.
 - Slow messages send an immediate receipt response with a job-id, followed later by a result (which may indicate failure). This later message is either pushed via a callback, or pulled by polling.


### TODO System Stack Diagram


## References

 - CASL: <http://www.informatik.uni-bremen.de/cofi/wiki/index.php/CASL_user_manual>
 - DOL: <https://github.com/tillmo/DOL>
 - HDTP: Talk to Martin Mohrmann
 - HETS: <http://www.informatik.uni-bremen.de/agbkb/forschung/formal_methods/CoFI/hets>
 - OWL Manchester Syntax: <http://www.w3.org/TR/owl2-manchester-syntax/>

# TODO Appendix 1: Component APIs
 
