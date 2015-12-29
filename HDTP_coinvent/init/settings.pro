% let the prolog sysyem know about special predicate properties
  
:- multifile(user:term_expansion/2).
:- dynamic(user:term_expansion/2).

:- multifile(user:goal_expansion/2).
:- dynamic(user:goal_expansion/2).