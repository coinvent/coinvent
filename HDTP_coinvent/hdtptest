#!/usr/bin/swipl -G0G -T0G -L0G -g print_banner -s

% aboth is a shabang and start swiprolog maximal global trail and local stack
% this makes it possible to execute ./hdtp.pro directly

% get important version information
:- consult('info.pro').

% define important directory paths e.g. init(dir) as hdtppath/init/dir
:- consult('bootstrap.pro').

% define other path shorthands like modules,unify_hooks ...
:- consult(init(paths)).

:- consult(init(settings)).
:- consult(init(expansions)).

% set prolog environment flags like print options
:- consult(init(environment)).

% imports all modules e.g. unify_hooks via use_module
:- consult(init(imports)).
:- consult(init(history)).
:- consult(init(libraries)).
:- consult(init(banner)).
:- consult(init(language)).
:- consult(interface).
:- findall(A,L,(load_analogy("current",A),disable(maprules),enable(one_to_one),gen_simple_casl(A))).


