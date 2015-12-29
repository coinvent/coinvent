:-module(utilities,[add_attr/3,
                    find_by_attr/4,
                    varset_add/3
                   ]).


% TODO: makes this faster using a sorted list
find_by_attr(Name,Value,[Variable|_],Variable):-
    get_attr(Variable,Name,Value),!.

find_by_attr(Name,Value,[_|Variables],Variable):-
    find_by_attr(Name,Value,Variables,Variable).

varset_add(Variable,Variables,[Variable|Variables]):-
    not((member(Variable_found,Variables),Variable==Variable_found)),!.

varset_add(_,Variables,Variables).

varset_del(Variable,[Variable_test|Variables],Variables):-
    Variable==Variable_test,!.

varset_del(Variable,[Variable_test|Variables],[Variable_test|Variables_result]):-
    varset_del(Variable,Variables,Variables_result).

% helper to handle lists in attributes        
add_attr(Variable,Name,Value):-
    get_attr(Variable,Name,Values),!,
    put_attr(Variable,Name,[Value|Values]).

add_attr(Variable,Name,Value):-
    put_attr(Variable,Name,[Value]).