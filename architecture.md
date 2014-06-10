
# Coinvent Architecture

Author: Daniel, with input from Ewen and Mihai   
Status: Final Draft, due for delivery in June.   
Version: 0.9.1   

- [Overview](#overview)
- [The Blend Diagram in Progress](#bdip)
- [Languages / File Formats](#languages)
- [Components](#components)
- [Architecture](#architecture)
- [Open Questions & Risks](#open)
- [References](#references)
- [Appendix 1: Component APIs](#appendix1)

<a name='overview'></a>

## Overview

This document presents the archictectural design for the integrated Coinvent system. 

Please first read:

1. The [Glossary / Jargon buster](http://ccg.doc.gold.ac.uk/research/coinvent/internal/?page_id=356) first. 
2. The [requirements / user-stories](integration+UI/requirements.md) which motivate this design.

For further information, please see the reference documents listed at the end of this file.

<a name='bdip'></a>

## Core Object: The Blend Diagram in Progress

The object type at the heart of Coinvent is the Blend Diagram. The specification below is intentionally broad to support several use-cases.

Crucially we must support blend diagrams which are "works in progress". The high-level process of developing a new blended concept is:

1. Pick two concepts to blend.
2. Compute a common base concept.
3. Compute a blend.
4. Evaluate the blend for consistency.
5. ...Which may lead to changes in either the input concepts, such as logical weakenings to remove the conflict. This process of evaluate-modify could be iterated several times.
6. Evaluate the blend for value, perhaps by generating examples/models and evaluating them.
7. ...This evaluation may lead to modifications, and so the whole process is iterative.

Hence we talk of a Blend Diagram *in Progress* to allow that blends may be developed step-by-step and iteratively.

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

A `Blend Diagram in Progress` is simply a Blend Diagram where any part may be missing or incomplete, and Concepts do not have to be consistent. 

TODO Draw a diagram of this.

<a name='languages'></a>

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
 - `%implied` Marks a proof obligation (i.e. a statement which is required to be true, but has not been proved)

#### DOL: Extra Conventions and Language Terms
There are some features Coinvent needs which DOL does not yet provide (see the project's [GitHub issue tracker](https://github.com/coinvent/coinvent/issues?labels=DOL+%2F+file-formats)). Where possible, we fit these within the current DOL specification by specifying non-standard annotations.

1. Dropping symbols from a Concept: `hide` can be used when defining a mapping to drop sentences as well as symbols.

2. Marking inconsistent sentences: by the annotation `%inconsistent%`

3. Marking relative importance of sentences: by the annotation `%importance(X)%`, where X is a number in the range [0,1]. How this is interpreted is tool dependent. It may be interpreted as a probability that the sentence holds.

4. Evaluating Concepts. That is, adding metadata which describes how good a concept is. Format TBD.
 
###  Mathematics: CASL

CASL is the first order logic language used by HETS. We will adopt it as the language Coinvent should use for mathematical concepts.

### Music: OWL?

The music team are investigating the use of OWL by producing a worked example of cadence blending.

It is anticipated that musical idioms will comprise both rules (e.g. constraints on a cadence) and statistical parts 
(e.g. hidden-markov-models).

### Other Domains: OWL Manchester Syntax

The established OWL description logic, via the Manchester Syntax, should be used for other domains.

### Web-service Wrapper: JSON

The web-service components (see below) will use JSON 
as a black-box wrapper, for web-services to
talk to each other. I.e. JSON is used to encode commands, such as "blend these concepts", and describe results, such as "success" or "failure due to timeout".

JSON is the best choice here, because it's a universal standard.

Low-level components (e.g. HDTP) will not take in JSON. That would be done by a
web-service wrapper, which then calls HDTP.

<a name='components'></a>

## Components

A Coinvent system will be made up of the following components.
A component can be "manual", which means a human being provides the result (using a web interface).

### User Portal
An interface through which the user drives the system.

Default implementation: To be developed.

### Blender: Given a Blend Diagram in Progress, compute the Blend Concept

Default implementation: HETS

### Base Finder: Given 2 Concepts, compute a common base Concept

Default implementation: HDTP

Required work: HDTP currently uses a custom Prolog-based format. To plug into Coinvent (or HETS without Coinvent), a translation layer will be developed so that HDTP can take in OWL or CASL.

Note: HDTP will remain stateless. It will not itself manage sessions or run a web-server.

### Amalgam Finder: Given an inconsistent Blend Diagram, weaken the inputs

Initial implementation: manual

Since the colimit operation (and blending in general) can generate inconsistent blends, it may be necessary to weaken the input theories until a consistent blend is found. 

The Amalgams team will lead on this, exploring the generalization operation for amalgams described in [4], and developing a stand-alone Theory Weakener (TW).

The TW will not be capable of computing colimits itself; therefore it requires a feedback loop with HETS.

In case the colimit is inconsistent, the TW analyzes the input theories and the inconsistencies
in the blend and weakens the theories based on this information by removing sentences from the
input theories. This removal will be based on heuristics known from amalgam reasoning [4]. The whole procedure is repeated until a consistent colimit is found.

For the implementation of the TW, we are currently investigating using an 
Answer Set Programming (ASP) approach, calling on online ASP solvers. This allows us to (i) rapidly implement prototypes, 
(ii) make use of the highly optimized search problem algorithms that drive modern ASP solvers [2], and (iii) use the advantages of online ASP solvers like oclingo [1] that will re-use partial solutions of earlier weakenings. Towards this, a weakening operation is modeled as sequence of theory transitions, based on atomic operations that each affect the different types of sentences (eg. SubClassOf , EquivalentTo, ObjectProperty, etc. for OWL) within theories. Perceiving the theory weakening as a sequence of theory transitions also allows us to exploit the iterative problem solving capabilities of modern ASP solvers and to re-use coding strategies known from other kinds
of state transition based problems that are typically modeled in ASP [2].

### Example Finder: Given a Concept, find examples / models

Default implementation: Manual

This is a key part of creative blending, especially around evaluating a concept. 
It is noticeable that when people learn and evaluate concepts, they often do so via examples.

The meaning of "example" is domain specific.

In mathematical theories, an example is a model, which is itself a theory. 
E.g. in the complex numbers case-study (c.f. https://github.com/coinvent/coinvent/tree/master/HETS/complex_numbers), 
an example is the refined theory where `i^2 = -1` has been added to provide a constructive formula for the existential
axiom `\forall vectors x,y, \exists vector z, x*y = z` (note: in the .dol file, this existential axiom is 
implicit in * being a total function).
 
In musical theories, an example is a piece of music conforming to the theory.
 
Automated implementations will also be domain specific, and may not be possible in all domains.

### Concept Scorer: How good is a Concept?

Default implementations: 

 - HETS for automated consistency checks.
 - Manual for other scores.

### Concept Store: Store Concepts and Blend Diagrams

Must provide save and load over http.

Note that most of the other components do *not* depend on a dedicated storage component. They can work with concepts stored on *any* server, as long as the format is correct and the concept can be identified by url. The User Interface does require a file storage component to store blend diagrams as they're modified.

Default implementation: 

 - File-system backed. By adding git to the file-system we can provide integration with Ontohub.

<a name="architecture"></a>

## Architecture

### Independent components, linked via http APIs

Requirements:  

1. The components of the system may be developed in different languages.
2. The system should be easy to maintain and extend.
3. The system should support both interactive use, and repeatable scripted use.

Requirements (1) and (2) above suggest a loose coupling between components. The use of http-based APIs is an established way of achieving this. In particular, http-based APIs with a REST-like setup (i.e. the url follows a simple readable structure) and using JSON to encode data are now becoming the standard for modern software development. 

JSON will provide a wrapper for API-level information. JSON is not part of the file format for Blend Diagrams. Blend Diagrams are written in DOL + OWL or CASL, and sent within a JSON packet as JSON strings.

An added benefit of this architecture is that it provides flexibility regarding the hardware infrastructure. The components of the Coinvent system may be run either on a single server, or across multiple servers.

#### Scripting the system

Requirement (3) relates to research users, who need to run repeatable concept development sessions. This requirement is met in this architecture by scripts which drive the API. Such scripts would most naturally be developed in javascript, perhaps using a test-runner. Indeed, the test scripts we develop as part of software QA will provide templates for scriptable use.

Where steps involve systems such as the interactive theorem prover Isabelle, it is an open question how we script such systems within Coinvent.

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


### System Stack Diagram

<!--
Coinvent EcoSystem
[Default User Interface]
[AJAX][jQuery][underscore templates]
[Web browser]
[http: JSON format REST API]
[Java web-service wrapper]
[HDTP][Files][HETS server^1]
[SWI Prolog^2][Git^3][Theorem Provers]
[OS: Linux (Ubuntu)]
1: The HETS server provides an http API. This is lower-level than the Coinvent API.
2: HDTP might be re-written by Martin Möhrmann to use a different backend.
3: Git integration provides OntoHub integration without a hard dependency.   
-->

<div id="diadraw"><div class="dia panel panel-primary"><div class="panel-heading"><h3 class="panel-title">Coinvent EcoSystem</h3></div><table class="dia"><tbody><tr><td class="default" colspan="3">Default User Interface</td></tr><tr><td class="ajax" colspan="1">AJAX</td><td class="jquery" colspan="1">jQuery</td><td class="underscore" colspan="1">underscore templates</td></tr><tr><td class="web" colspan="3">Web browser</td></tr><tr><td class="http" colspan="3">http:  JSON format REST API</td></tr><tr><td class="java" colspan="3">Java web-service wrapper</td></tr><tr><td class="hdtp" colspan="1">HDTP</td><td class="files" colspan="1">Files</td><td class="hets" colspan="HETS server^1">HETS server<sup>1</sup></td></tr><tr><td class="swi" colspan="SWI Prolog^2">SWI Prolog<sup>2</sup></td><td class="git" colspan="Git^3">Git<sup>3</sup></td><td class="theorem" colspan="1">Theorem Provers</td></tr><tr><td class="os" colspan="3">OS:  Linux <small>(Ubuntu)</small></td></tr></tbody></table><ul><li>1:  The HETS server provides an http API. This is lower-level than the Coinvent API.</li><li>2:  HDTP might be re-written by Martin Möhrmann to use a different backend.</li><li>3:  Git integration provides OntoHub integration without a hard dependency.</li></ul></div></div>


<a name='open'></a>

## Open Questions and Risks

Many development questions remain open at this stage in the project. Notable open questions are:

1. How to generate examples in the different domains.
2. How to use "3rd party systems" such as the Isabelle interactive theorem prover within Coinvent.
3. How to weaken theories to resolve inconsistencies?
3. What format is best for musical idioms?

### Software development risks & mitigation

Much of the Coinvent system builds upon existing components (HETS, HDTP, DOL), or can use standard software & approaches (the UI). These components therefore have a relatively low risk. That said, all the base components require some development to meet the needs of this project.

Higher risk components are /model and /weaken. How these functions can be implemented is a research topic. The problems are deep, and no readily adaptable solution exists. The team do have relevant expertise in techniques to tackle these tasks, but, as with any open-ended research task, there is a high level of technical risk.

To mitigate these risks, the system design allows for components to be fulfilled by manual interactive input. This means work on automated solutions to /model and /weaken is not a blocker for use of the system.

<a name='references'></a>


## References

 - CASL: [user manual](http://www.informatik.uni-bremen.de/cofi/wiki/index.php/CASL_user_manual)
 and [reference manual](http://www.informatik.uni-bremen.de/cofi/wiki/index.php/CASL_reference_manual)
 - DOL: <https://github.com/tillmo/DOL>
 - HDTP: <http://link.springer.com/chapter/10.1007%2F978-3-642-54516-0_7>
 - HETS: <http://www.informatik.uni-bremen.de/agbkb/forschung/formal_methods/CoFI/hets>
 - OWL Manchester Syntax: <http://www.w3.org/TR/owl2-manchester-syntax/>
 - ASP:
	1. M.Gebser et al, Engineering an Incremental ASP Solver. In International Converence on Logic Programming (2008), no. 1.
	2. M.Gebser et al, Answer Set Solving in Practice. Morgan and Claypool, 2012.
	3. M.Gelfond and V.Lifschitz, The Stable Model Semantics for Logic Programming.
In Proceedings of the International Conference on Logic Programming (ICLP) (1988).
	4. S.Ontan and E.Plaza, Amalgams: A formal approach for combining multiple case
solutions. In ICCBR (2010).
    
<a name='appendix1'></a>


# Appendix 1: Component APIs

## Common

This document uses JSDoc to describe input and output types, e.g. `{?string}` would mark an optional string.

### Url structure

The default server is coinvent.soda.sh and the default port is 8400.

For each component, we provide a default implementation, and these follow a
common url pattern.
Other implementations are possible, and may not follow the pattern.

	http://server:port/component/actor

This means we can have multiple different instances of a component, e.g.
http://coinvent.soda.sh:8400/blender/hets and http://coinvent.soda.sh:8400/blender/hr3

The actor may refer to a piece of software (e.g. hets), or to a user, which allows that any component function can be fulfilled manually by a human being. E.g. http://coinvent.soda.sh:8400/blender/alice

This structure anticipates multi-agent setups, which will be wanted for the 
investigation of social aspects later in the project.

The default file store also fits into this pattern, with component=files. 
E.g. the user Alice's houseboat file could be 
http://coinvent.soda.sh:8400/file/alice/houseboat.omn


### Common Inputs

`Concept` type: Concepts can be provided as the source text itself, or as a uri for a file which contains the source text.

`Mapping` type: Mappings are provided either as:   
 1. JSON maps, e.g. "{"sun":"nucleus", "planet":"electron"}"   
 2. DOL fragments, using only the inner part of the DOL mapping, e.g. "sun |-> nucleus, planet |-> electron".

`BlendDiagram` type: A packet of data comprising the Concepts and Mappings for a blend diagram in progress. The component Concepts of a BlendDiagram use the names `base`, `blend`, `input1`, `input2`, and the Mappings `base_input1`, `base_input2`, `input1_blend`, `input2_blend`. If weakenings are used, then these Concepts are names `weakinput1`, `weakinput2`, and `weakbase`, with corresponding Mappings. Can be provided as the source text itself,  
or as a uri for a file containing the BlendDiagram. Can be in JSON or in DOL, identified in the case of a uri by a .json or .dol file-ending.

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

### /blender: Given a Blend Diagram in Progress, compute the Blend Concept

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


### /weaken: Given an inconsistent blend diagram in progress, weaken the concepts

This is the key method for Amalgams.

Default implementation: Manual (Amalgams later in the project)         
Default end point: http://coinvent.soda.sh:8400/weaken/$user_name

Parameters: 

 - blend_diagram: A Blend Diagram in Progress
 - cursor: {?url} For requesting follow-on results.
 
Response-cargo: A weakened blend diagram

Open question: What information should be passed to /weaken to guide it? 
For example, it might take in line-numbers marking sets of inconsistent sentences.

	
### /model: Given a Concept, find examples

Default implementation: Manual   
Default end point: http://coinvent.soda.sh:8400/model/$user_name

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

Note that most of the other components do *not* depend on the /file component. They
can work with concepts stored on any server (and identified by uri). The User Interface requires it to store blend diagrams as they're modified.

Default implementation: file-system based, with git support   
Default end point: http://coinvent.soda.sh:8400/file/$user_name

Load Parameters: 

 - Use the path (i.e. the slug) to specify a file.   
 E.g. `http://coinvent.soda.sh:8400/files/alice/stuff/alices_boat.dol`
 would fetch the file stored at `$base_dir/alice/stuff/alices_boat.dol`

Response: the file  
  
Save Parameters:

 - Use the path (i.e. the slug) to specify a file.
 - Use http PUT or the parameter=value pair `action=save`
 - The post body contains the text to save.

Response: the file  

A save (or a delete) triggers a git commit and push. 
Distributed git repositories cany be linked together, and in particular OntoHub
uses git-based storage. This allows for connection with OntoHub.

 
Delete Parameters:

 - Use http DELETE or the parameter=value pair `action=delete`

Response: just the envelope, indicating success or failure 
 
### /job: List open tasks

Default implementation: Coinvent Integration+UI module      
Default end point: http://coinvent.soda.sh:8400/job/$user_name

Parameters:

 - status: {?string} open|closed Optional filter.
 - cursor: {?url} For requesting follow-on results.
   
Response-cargo: 
	
	{
		jobs: [
			{
				id: {string},   
				status: open|closed
			}
			] 
	}

#### /job/$user_name/$job_id: Show / delete job details

Default implementation: Coinvent Integration+UI module      
Default end point: http://coinvent.soda.sh:8400/job/$user_name

 - Use the path (i.e. the slug) to specify a file.   
 E.g. `http://coinvent.soda.sh:8400/job/alice/1234`
 would fetch details on job id 1234, assigned to Alice.
If a job-id is not specified, this endpoint will list jobs (see above).
 - action: delete Use this, or the http method DELETE, to request cancellation of a job.

Response-cargo: 
	
	{
		job: {
			id: {string},
			status: open|closed
			} 
	}

This may optionally provide more information about the job, such as a progress update.

	
