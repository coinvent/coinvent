coinvent
========

The infrastructure software for the CoInvent computational creativity project

Status: Empty!   
Maintainer: Daniel Winterstein   

## How to get access: Email Daniel ##

1. First setup a github account.
2. Email me, and I will add you as a contributor. 

## What Goes In Here: Enough to install Coinvent ##

The github repo should contain everything needed to run and maintain the Coinvent software.

For a given component (e.g. HETS or HDTP) that could mean:

1. Installation instructions pointing to a repository which will be maintained for the long-term (i.e. at least 5 years).
2. Or a snapshot of the software (either source code, or binary + source code).
3. Or the source code itself.

## Software Architecture ##

Each top-level module will run as a web-service over http. 

TBD: common formats for data, and interfaces for the modules.

Beyond that, modules can be written however -- in any language, using
any framework (although Java is the preferred language) -- as long as they meet the hardware and installation
requirements below...


## Hardware: Can run on Linux ##

Everything should run on a 64-bit Linux machine, using a Debian-based distro.

That wouldn't mean you have to develop on such a machine, just that we
can install and run your module there.

Let's use the upcoming long-term-stable Ubuntu version 14.04 as our
baseline for tests. 

Dan: I'll make sure we have a server available.

It should be possible to run small examples on a low-end modern machine, e.g. 4gb ram, so that developers don't need high-end
kit for testing. However if your system needs more horsepower to handle big examples, that's fine.


## Installation ##

Each component must have an install.txt file which describes step-by-step how to install it, start it running,
and do a hello-world test example -- starting from a plain out-of-the-box Ubuntu setup. 

The test for this packaging is whether someone else, using only basic "universal" Unix knowledge, can carry
it out. That test should be carried out at least every 6 months -- i.e. we all try installing each other's software 
(I may also volunteer the SoDash sysadmin as an extra tester).

As requirements go, this is very open -- e.g. a module could describe
cloning a git repository from a url, installing half a dozen
dependencies, then compiling it from source -- or at the other end
of the scale, it could be a one-line apt-get for an ubuntu package.


## Documentation: To be kept alongside the component it documents, here in github.


## Testing: TBD


## Git Branching: master, feature-development, stable ##

The master branch is the main place for activity.

Feature branches are for code which will break master (do not put code into master if it would break the system and block other people's work). 
Feature branches should be merged into master and removed when ready.

When we do a release, we will create a stable branch for that release.
Each release gets it's own stable branch. Stable branches are dead-ends -- only updated with urgent fixes between releases.

