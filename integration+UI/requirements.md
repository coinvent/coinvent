
# Coinvent Requirements / User-Stories

Author: Daniel, with input from the April workshop 
Status: Final Draft, due for delivery in June.      
Version: 0.9   

## Overview

This document presents the motivating requirements for the integrated Coinvent system. It does so via the agile method of user-stories: requirements are driven by example use-cases of who needs it and why.


Please first read:

1. The [Glossary / Jargon buster](http://ccg.doc.gold.ac.uk/research/coinvent/internal/?page_id=356) first. 

For further information, please see the reference documents listed at the end of this file.

## User Stories

### As a Coinvent Researcher...

User: Logic researcher    
Task: Explore creating and using blends   
Needs:

 - Specify concepts.
 - Create blends.
 - Evaluate blends (this is domain specific -- see specific domains below).
 - Reliably replay a "session" of concept blending plus associated concept development (such as theorem proving or example music generation).

Success criteria: The software supports research, leading to papers on blending which extend the state of research.   
Priority: High.


User: Social creativity researcher    
Task: Explore multiple users/agents creating & using blends      
Needs:

 - As for Logic Researcher, plus...
 - Agent-based system to model & explore social interactions.
 - Setup different starting models for agents.

Priority: This is a key strand of the project plan. For Year 2/3.

### As a non-Coinvent developer...

Later in the project, we aim to run Coinvent hackathons, where other developers
use Coinvent to build things.

User: A researcher with ontology experience.    
Task: Explore concept blending.   
Needs: Same as for a Coinvent Logic Researcher, plus a user-friendly UI and documentation.

User: A developer making a creativity tool for a domain of their choice (e.g. one of the domains considered below).      
Needs: 

 - The system must be flexible enough to support:
   - Modified back-end components.
   - Other user interfaces, built on top of the API. 
 - Enough documentation to support 3rd party developers, including a Hello-World example project.      

Success criteria: Developers from outside the project produce projects (which may be just proof-of-concept scratch projects) using Coinvent.   
Priority: For Year 3.

### As an end-user...

#### Domain: Mathematics

User: Coinvent researcher
Task: Explore the blending of mathematical concepts.      
Use-case: Define concepts. Pick 2 concepts as input, and get back a blended concept. Further develop the blend to resolve "quality issues" such as.
Further develop the blended concept to create interesting outputs -- possibly models / examples.   
Requirements: 

1. A format which can define mathematical concepts.
2. Specify two theories, and blend them to produce a new concept.
2. Weaken input concepts and strengthen output blends ??. 
3. Given a concept, check it for consistency.
4. Given a concept, produce examples / a model.
5. Given a concept, identify the unresolved questions in the blend (for complex numbers, the missing formula x.y=?).
6. Solve the unresolved questions in the blend, adding axioms and resolving any proof obligations.

Note that some steps may have to be manual or semi-automated, and so it is a requirement that the
system supports interactive reasoning.

Success criteria: It works.       
Priority: High. This is a project deliverable.
 
 
User: A non-mathematical analyst (e.g. someone who'd normally use Excel)    
Task: Quantitative analysis of data   
Wants: To meaningfully analyse some data using bayesian mathematical models.   
Specific use-case: Interpret Twitter conversational data on a topic, in terms of types of person and types of conversation.   
Needs:

 - A friendly UI.
 - To create a model by blending pre-defined models.
 - To understand what they've made without understanding the source code -- i.e. a clear natural language summary of the model.
 - To apply the model to the data...
 - ...And get back results they can understand (e.g. pie-charts and time-series charts with meaningful labels).

Success criteria: It works and is adopted for use by a researcher or analyst outside the project.   
Priority: Medium. This is an achievable valuable goal within the important mathematics thread.


#### Domain: Music

User: Coinvent researcher
Task: Explore the blending of musical idioms      
Use-case: Define idioms. Pick 2 musical idioms as input, and get back a blended idiom. Given an idiom, evaluate it, by creating examples and subjectively assessing them.   
Requirements: 

1. A format which can define musical idioms. Open question: What levels of structure does this have to capture?
2. Optional? The ability to statistically analyse a body of example music as part of fleshing out a musical idiom (e.g. creating an HMM for use in generation).
3. Blend idioms to produce new idioms. This requires support for weakening or otherwise resolving clashes, as fully-fledged idioms are likely to be logically inconsistent.
4. Given an idiom, produce example music.
4. Optional: Support for evaluating music / idioms.

Success criteria: It works.       
Priority: High. This is the basis for all music-domain work.
 
User: A listener
Task: Create music they like      
Use-case: Pick 2 musical idioms as input, and get back a newly-created high-quality piece of music.
Success criteria: A group is identified who adopt Coinvent-based software as part of their music listening software. Or a Coinvent-created piece of music gains small-scale public success.   
Priority: Low. This is a very hard task and may not be achieved within this project.
 
User: An avant-garde composer    
Task: Create music to use as inspiration / source material   
Use-case: Pick 2 musical idioms as input, and get back a newly-created *low-quality* piece of music.   
Success criteria: A composer collaborates with the project and uses Coinvent to create a piece of music they then perform.      
Priority: For Year 2/3. This is an achievable goal for this project.


#### Other Domains

##### Domain: Fictional beasts   
User: A child    
Task: Create a fictional beast
Use-case: Pick two input beasts (using a simple user-friendly GUI), and get back a fictional blended beast with a mini-story about how it behaves.  
Wants: To play around creating fun new animals and interacting with them.
Needs:

 - A very friendly UI.
 - An ontology of animals behind it.
 - To specify two animals to blend.
 - To get a pictorial view of the blend.
 - To see some behaviour, e.g. robot cat chases mutant mice, stops to drink some milk, short-circuits.

Success criteria: Adopted for use by a school, or distributed publicly as an app.         
Priority: Medium. For Year 2. This is an achievable goal for this project.


##### Domain: Mechanical engineering.   

User: A mechnical engineer.   
Task: Create a new product, and streamline the 3D modelling, requirements checking, & safety testing by leaning on an existing database.   
Wants: To specify a new component (e.g. a car ejector seat), which has aspects of existing components. Then get a CAD model which fits the spec.   
Priority: Low. This lacks a sponsor within the project.

##### Domain: Poetry

User: A poet   
Task: Create poetry fragments to use as inspiration / source material   
Use-case: 

1. Pick 2 concepts as input, and get back a newly-created metaphor and sentences illustrating it.   
2. Pick a concept and a property, and get back a 2nd concept which when blended with the first provides a metaphor for the desired property. 

Success criteria: A poet collaborates with the project and uses Coinvent to create a piece of poetry they then publish.  
Priority: Medium. This is an achievable goal for this project. This is an accessible domain for technology testing, and it fits with the research interests of Goldsmiths group.

User: A reader   
Wants: To be entertained or stimulated.   
Success criteria: Producing poems that are rated as interesting, either by literature critics or a more general readership.    
Priority: Low. This is an accessible domain for technology testing, and it fits with the research interests of Goldsmiths group. However there is considerable extra work required for software to go from a blended-concept metaphor, to a complete poem.

##### Domain: Recipes

User: An amateur cook   
Wants: To create a new recipe or meal-plan by blending ideas.   
Success criteria: Some new & tasty recipes.   
Priority: Low. This is an accessible domain for proving the technology. However there is so much cooking material online, that a new resource would not be very valuable.   




