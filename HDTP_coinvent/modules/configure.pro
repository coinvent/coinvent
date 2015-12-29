:- module(configure,[configure/1,
                     flag/1,
                     flag/2,
                     enable/1,
                     disable/1]).

% make it seem like configure is in the module namespace it is invoked from
:- module_transparent(configure/1).

% provides dynamic goal exapnsion by specification of option facts provided in File
% inlcudes confirmation printout that option was processed 
configure(File):-
             context_module(_Module), 
             asserta(
                     term_expansion(
                                    default(Name,Value),
                                    default(Name,Value)
                                   )
                                   :- 
                                   %(print(_Module:Name),print(' -> '),print(Value),nl,
                                   flag(Name,_,Value)
                                   %)
                    ),
             consult(File).

flag(Flag)      :-flag(Flag,true).
flag(Flag,Value):-flag(Flag,Value,Value).

enable(Flag):-flag(Flag,_,true).
disable(Flag):-flag(Flag,_,false).
