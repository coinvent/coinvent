
# Coinvent Architecture

Author: Daniel, with input from Ewen and Mihai   
Status: Draft, due for delivery in June.   
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

This document presents the archictectural design for the integrated Coinvent system. 

Please first read:

1. The [Glossary / Jargon buster](http://ccg.doc.gold.ac.uk/research/coinvent/internal/?page_id=356) first. 
2. The [requirements / user-stories](requirements.md) which motivate this design.

For further information, please see the reference documents listed at the end of this file.

## Core Object: The Partial Blend Diagram

The object type at the heart of Coinvent is the Blend Diagram. The specification is intentionally broad to support several use-cases.

Concepts are defined in CASL or OWL. Mappings between concepts are defined in DOL. Metadata is also defined in DOL. The Blend Diagram may be a single file, or several linked files, using DOL's support for urls.

A `Blend Diagram` consists of:

1. A Blended Concept
2. A set of Input Concepts (typically 2)
3. Optionally, weakenings of the Input Concepts. E.g. a mapping Concept1 -> WeakerConcept1, by dropping symbols or sentences.
4. A Base Concept, which is a common base for all the Input Concepts. If there are weakenings, then the Base is a base for the weakened concepts (not the originals).
5. Mappings from the Base Concept to each of the (weakened) Input Concepts.
6. Mappings from each of the (weakened) Input Concepts to the Blended Concept.
7. Optional metadata about each of the Concepts, such as evaluation scores,  proof obligations, or relationship to other Concepts.

The Blended Concept *may* be a colimit, but it does not have to be.
The Base Concept *may* be found via anti-unification, but it does not have to be.

A `Partial Blend Diagram` is simply a Blend Diagram where any part may be missing or incomplete, and Concepts do not have to be consistent. The Partial Blend Diagram allows that blends may be developed (perhaps iteratively).

TODO Draw a diagram of this.

## Languages / File Formats

Coinvent will focus on human-readable text-file formats. 
A couple of formats for concepts will be supported, with the DOL language used to describe the connections between concepts.

### 3 Levels of languages: software, meta-logic, domain-logic

1. The outer language (json) is used to connect software components. E.g. specifying software inputs & callbacks, reporting on job-status, etc.
2. The meta-logic language (DOL) is used to describe the mappings between concepts.
3. The domain-logics (OWL, CASL) are used to describe actual concepts.

### Connecting concepts: DOL (modified)
DOL (Distributed Ontology, Modeling and Specification Language) is a language for describing how ontologies connect. 
DOL is currently in development by Till Mossakowski's group. It is used by the HETS system. This integration with HETS makes it a good choice for Coinvent.

DOL is both larger than we need, and does not have a couple of things we need. So
we specify a modified version of DOL. We will work with the DOL team aiming to
converge on a true subset of DOL.

#### DOL subset: Supported Language Terms

Coinvent does not need all the features of DOL, and so we specify a reduced subset of DOL which should be used. Sticking to a smaller set reduces the learning curve for new Coinvent users.

Briefly, the supported symbols are:

 - `logic` Specify the Concept language, e.g. `logic OWL`
 - `ontology` Start defining a Concept.
 - `end` Finish defining a Concept. 
 - `view` Specify a mapping between Concepts, e.g. `view MyView : A to B =`
 - `with` Start of a symbol mapping within a combine statement.
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

### Web-service Wrapper: JSON

The web-service components (see below) will use JSON 
as a black-box wrapper, for web-services to
talk to each other. I.e. JSON is used to encode commands, such as "", and describe results, such as "success" or "failure due to timeout".

JSON is the best choice here, because it's a universal standard.

Low-level components (e.g. HDTP) will not take in JSON. That would be done by a
web-service wrapper, which then calls HDTP.

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

### Amalgam Finder: Given an inconsistent Blend Diagram, weaken the inputs

Default implementation: manual

### Example Finder: Given a Concept, find examples

Default implementation: Manual

### Concept Scorer: How good is a Concept?

Default implementations: 

 - HETS for automated consistency checks.
 - Manual for other scores.

### Concept Store: Store Concepts and Blend Diagrams

Must provide save and load over http.

Default implementation: 

 - File-system backed. By adding git to the file-system we can provide integration with Ontohub.

## Architecture

### Independent components, linked via http APIs

Requirements:  

1. The components of the system may be developed in different languages.
2. The system should be easy to maintain and extend.

This suggests a loose coupling between components. The use of http-based APIs is an established way of achieving this. In particular, http-based APIs with a REST-like setup (i.e. the url follows a simple readable structure) and using JSON to encode data are now becoming the standard for modern software development. 

JSON will provide a wrapper for API-level information. JSON is not part of the file format for Blend Diagrams. Blend Diagrams are written in DOL + OWL or CASL, and sent within a JSON packet as JSON strings.

An added benefit of this architecture is that it provides flexibility regarding the hardware infrastructure. The components of the Coinvent system may be run either on a single server, or across multiple servers.

#### Software Wrapped as a Server

"Calculation" software such as HDTP will be incorporated into this framework using a server which "wraps" the low-level software. E.g. the other components connect to the HDTP-server over http, and the server manages calling HDTP itself.

### Top-level Stateful, Low-level Stateless

Calculation software will be stateless. This is simpler, and avoids tying the
low-level components to the bigger system.

There's the question of: paging through results.
E.g. HDTP can produce multiple outputs for some inputs.
If we have one mapping & we want a 2nd or a 3rd -- how do we do that?   

This will be handled via input flags, and just repeating
the calculation asking for more outputs (i.e. iterative deepening).

The overall system will be stateful, because being stateful is the
most natural way to support a couple of features we want:

 - Slow tasks, where a job is started, runs, finishes later.
 - Interactive UI, where the user has a fixed reference point to view
a developing blend.

The state would be handled at the top level. The components
(HDTP, HETS-as-a-colimit-calculator, etc) are used in a stateless manner.


### Actor / Queue Pattern

Requirements:  

1. The components of the system call on each other to perform tasks...
2. ...but these tasks may be slow to complete. Since tasks may require human input (eg. a proof in an interactive theorem prover like Isabelle), a task
could even take days.

This means a standard call/response would timeout. We therefore adopt an actor / queue based pattern (see <https://en.wikipedia.org/wiki/Actor_model>). 

Each top-level component is an actor, which can send and receive messages to other actors. Each API request is marked as either *fast* or *slow*:

 - Fast messages get an immediate result within the http response.
 - Slow messages send an immediate receipt response with a job-id (using http code 202 "accepted for processing"), followed later by a result (which may indicate failure). This later message is either pushed via a callback, or pulled by polling.


### TODO System Stack Diagram


## References

 - CASL: <http://www.informatik.uni-bremen.de/cofi/wiki/index.php/CASL_user_manual>
 - DOL: <https://github.com/tillmo/DOL>
 - HDTP: Talk to Martin Mohrmann
 - HETS: <http://www.informatik.uni-bremen.de/agbkb/forschung/formal_methods/CoFI/hets>
 - OWL Manchester Syntax: <http://www.w3.org/TR/owl2-manchester-syntax/>

# TODO Appendix 1: Component APIs

## Common

This document uses JSDoc to describe input and output types, e.g. `{?string}` would mark an optional string.

### Url structure

The default server is coinvent.soda.sh and the default port is 8400.

For each component, we provide a default implementation, and these follow a
common url pattern.
Other implementations are possible, and may not follow the pattern.

	http://server:port/component/actor

So we can have multiple different instances of a component, e.g.
http://coinvent.soda.sh:8400/blender/hets and http://coinvent.soda.sh:8400/blender/hr3

The actor may refer to a piece of software (e.g. hets), or to a user, which allows that any component function can be fulfilled manually by a human being. E.g. http://coinvent.soda.sh:8400/blender/alice

This structure anticipates multi-agent setups, which will be wanted for the 
investigation of social aspects later in the project.

The default file store also fits into this pattern, with component=files. 
E.g. the user Alice's houseboat file could be 
http://coinvent.soda.sh:8400/files/alice/houseboat.omn


### Common Inputs

`concept` type: Concepts can be provided as the source text itself, or as a uri for a file which contains the source text.

`mapping` type: Mappings are provided either as:   
 1. JSON maps, e.g. "{"sun":"nucleus", "planet":"electron"}"
 2. DOL fragments, using only the inner part of the DOL mapping, e.g. "sun |-> nucleus, planet |-> electron".

All inputs are of course sent URL encoded.

### Common Outputs

With the exception of files, all outputs are in JSON and have a common envelope.

#### Envelope

Each response has the same top level structure:

	{
		"success": {boolean} usually true,
		"cargo": the meat of the response, or null if it is a slow asynchronous request,
		"jobid": {string} The job id for slow requests,
		"messages": {string[]} an array of notifications for the user -- usually null,
		"cursor": {uri} the next page in a series -- usually null				
	}

### Authentication: none

No authentication is required at this stage in the project.

### Cross-server requests: CORS

Cross-server calls -- where a webpage hosted on one server makes an ajax request
on another server -- are supported via CORS. This means they just work, although CORS may not work with older browsers.

## Component APIs

### /blender: Given a Partial Blend Diagram, compute the Blend Concept

Default implementation: HETS   
Default end point: http://coinvent.soda.sh:8400/blender/hets

Parameters:

 - lang: owl|casl
 - input1: {concept} 
 - input2: {concept}
 - base: {concept}
 - base_input1: {mapping} from base to input1
 - base_input2: {mapping} from base to input1
  
Response-cargo: 
	
	{
		blend: {concept} which is a blend of input1 and input2,
		input1_blend: {mapping} from input1 to blend,
		input2_blend: {mapping} from input2 to blend
	}

### /base: Given 2 Concepts, compute a common base Concept

Default implementation: HDTP   
Default end point: http://coinvent.soda.sh:8400/base/hdtp

Parameters:

 - lang: owl|casl
 - input1: {concept} 
 - input2: {concept}
 - base: {?concept}
 - base_input1: {?mapping} from base to input1
 - base_input2: {?mapping} from base to input1
 - cursor: {?url} For requesting follow-on results.
 
Response-cargo: 
	
	{
		base: {concept} which is a common base for input1 and input2,
		base_input1: {mapping} from base to input1,
		base_input2: {mapping} from base to input2
	}

## TODO /weaken

### /model: Given a Concept, find examples

Default implementation: Manual   
Default end point: http://coinvent.soda.sh:8400/<user-name>/model

Parameters:

 - lang: owl|casl
 - concept: {concept} 
 - cursor: {?url} For requesting follow-on results.
   
Response-cargo: 
	
	{
		models: {concept[]} 
	}

### /eval: Concept Scorer: How good is a Concept?

Default implementations: 

 - HETS for automated consistency checks.
 - Manual for other scores.

### /file: Store Concepts and Blend Diagrams

Must provide save and load over http.

Default implementation: file-system based   
Default end point: http://coinvent.soda.sh:8400/files/<user-name>

Load Parameters: 

 - Use the path (i.e. the slug) to specify a file.   
 E.g. `http://coinvent.soda.sh:8400/files/alice/stuff/alices_boat.dol`
 would fetch the file stored at `<base dir>/alice/stuff/alices_boat.dol`

Response: the file  
  
Save Parameters:

 - Use the path (i.e. the slug) to specify a file.
 - Use PUT or the parameter=value pair `action=save`
 - The post body contains the text to save.

Response: the file  
 
### /job: List open tasks





	
