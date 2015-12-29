:- module(struct,[analogystruct/2,
                  undo_subst/2,
                  domainstruct/6,
                  clausestruct/6,
                  termstruct/8,
                  antiu_trace/3,
                  antiu_trace_all/2,
                  collect_struct_variables/2,
                  build_atomic_Variable/9,
                  build_variable_Variable/8,
                  build_sort_Variable/4]).

% analogystruct(+,-)
% generates a starting preanlogy form analogy specification
% and injecting substitution information from S_domain_name and T_domain_name 
analogystruct(analogy(_Name,domain(S_domain_name,S_sig,Source),domain(T_domain_name,T_sig,Target)),preanalogy(0,source(Source_struct,[],[]),target(Target_struct,[],[]),[],[])):-
    domainstruct(Source,Source_struct,[],Source_Names,[],_Source_Sorts),
    sig_inject(Source_Names,S_sig),
    flag(sourcedomainname,_,S_domain_name),
    domainstruct(Target,Target_struct,[],Target_Names,[],_Target_Sorts),
    sig_inject(Target_Names,T_sig),
    flag(targetdomainname,_,T_domain_name).

sig_inject([],_).

sig_inject([Var|T],Sig):-
    get_attr(Var,sig,_Type),!,    
    sig_inject(T,Sig).

sig_inject([Var|T],Sig):-
    get_attr(Var,name,Name),
    sigmember(Name,Type,Sig),!,
    put_attr(Var,sig,Type),
    sig_inject(T,Sig).

sig_inject([Var|T],Sig):-
    get_attr(Var,name,Name),
    casl_symbol(Name),!,
    put_attr(Var,sig,'$casl_symbol'),
    sig_inject(T,Sig).

sig_inject([Var|T],Sig):-
    get_attr(Var,name,Name),
    format('Warning: found no sort specification for ~w; added it with sort Unspecified',[Name]),nl,
    put_attr(Var,sig,['Unspecified']),!,
    sig_inject(T,Sig).


sigmember(Name,Type,[sig(SName,Type)|_Sig]):-
    Name==SName,!.

sigmember(Name,Type,[_|Sig]):-
    sigmember(Name,Type,Sig).  

% struct are predicates to transform a prolog term into the internal representation of terms HDTP operates on
domainstruct([],[],Domain_Subst,Domain_Subst,Domain_Sorts,Domain_Sorts).
domainstruct([Clause|Domain],[Clause_struct|Domain_struct],Domain_Subst,Domain_Subst_new,Domain_Sorts,Domain_Sorts_new):-
    clausestruct(Clause,Clause_struct,Domain_Subst    ,Domain_Subst_tmp,Domain_Sorts    ,Domain_Sorts_tmp),
    store_count_predicates(Clause_struct),
    domainstruct(Domain,Domain_struct,Domain_Subst_tmp,Domain_Subst_new,Domain_Sorts_tmp,Domain_Sorts_new).
     
clausestruct(Term,Termstruct,InputMapping,InputMapping_new,Sorts,Sorts_new) :-
  	termstruct(Term,Termstruct,0,_Place_next,InputMapping,InputMapping_new,Sorts,Sorts_new).

termstruct(Sort:Term,AttributeVar:Variable,Place,Place_next,InputMapping,InputMapping_new,Sorts,Sorts_new) :- 
    nonvar(Sort),
    var(Term),!,
    term_to_atom(Term,Nameinternal),
    atomic_list_concat(['Input',Nameinternal],Name),
    %TODO: add this in build_variables_Variable
    get_attr(Term,sig,Type),
    build_variable_Variable(Name,Variable,Sort,source,InputMapping,InputMapping_new,Sorts,Sorts_new),
	  put_attr(Variable,sig,Type),
	  set_termstructattributes(AttributeVar,Place,Place_next).

%in case Term is atomic -> new Variable tagged with atomic
termstruct(Sort:Term,AttributeVar:ConstVar,Place,Place_next,InputMapping,InputMapping_new,Sorts,Sorts_new) :- 
    nonvar(Sort),
    atomic(Term),!,
	  build_atomic_Variable(Term,ConstVar,_,Sort,source,InputMapping,InputMapping_new,Sorts,Sorts_new),
    set_termstructattributes(AttributeVar,Place,Place_next).

%in case Term is a predicate -> predicate(name,ListofArguments)   
termstruct(Sort:Term,AttributeVar:(PredicatenameVar,Arguments_struct),Place,Place_next,InputMapping,InputMapping_new,Sorts,Sorts_new) :- 
    nonvar(Sort),
    Term =.. [Predicatename|Arguments],!,
	  (is_higherorder_varname(Predicatename)->
	       build_variable_Variable(Predicatename,PredicatenameVar,Sort,source,InputMapping,InputMapping_tmp,Sorts,Sorts_tmp)
	  ;
	       build_atomic_Variable(Predicatename,PredicatenameVar,_,Sort,source,InputMapping,InputMapping_tmp,Sorts,Sorts_tmp)
	  ),
	  set_termstructattributes(AttributeVar,Place,Place_tmp),
	  termstruct_arguments(Arguments,Arguments_struct,Place_tmp,Place_next,InputMapping_tmp,InputMapping_new,Sorts_tmp,Sorts_new).

termstruct(Term,TaggedTerm,Place,Place_next,InputMapping,InputMapping_new,Sorts,Sorts_new) :- 
    termstruct(none:Term,TaggedTerm,Place,Place_next,InputMapping,InputMapping_new,Sorts,Sorts_new).

% check if Name starts with uppercase letter
is_higherorder_varname(Name):-
    sub_atom(Name,0,1,_,Char),
    char_type(Char,upper).

build_sort_Variable(Name,Variable,Sorts,Sorts):-
    find_by_attr(name,Name,Sorts,Variable),!.

build_sort_Variable(Name,Variable,Sorts,Sorts_new):-
    put_attr(Variable,name,Name),
    varset_add(Variable,Sorts,Sorts_new).

%-------------------------------------------------------------------------------
% built a prolog variable representing a variable of term algebra

% check if we already made a prolog variable for this variable and reuse it
build_variable_Variable(Name,Variable,Sort,_Source,InputMapping,InputMapping,Sorts,Sorts) :-
    find_by_attr(name,Name,InputMapping,Variable),!,
    get_attr(Variable,sort_link,SortVar),
    %check if it has expected sort
    assertion(get_attr(SortVar,name,Sort)).
    
% add information about variable in attributes
build_variable_Variable(Name,Variable,Sort,Source,InputMapping,InputMapping_new,Sorts,Sorts_new) :-
    build_sort_Variable(Sort,SortVar,Sorts,Sorts_new),
    put_attr(Variable,sort_link,SortVar),
    put_attr(Variable,name,Name),
    put_attr(Variable,source,Source),
    varset_add(Variable,InputMapping,InputMapping_new).

%-------------------------------------------------------------------------------

% built a prolog variable representing a constant of term algebra

% check if we already made a variable for this constant and reuse it
build_atomic_Variable(Name,Variable,Variable_variable,Sort,_Source,InputMapping,InputMapping,Sorts,Sorts):-
    find_by_attr(name,Name,InputMapping,Variable),!,
    get_attr(Variable,sort_link,SortVar),
    get_attr(Variable,var_link,Variable_variable),
    (get_attr(SortVar,name,Sort)->true;trace,throw('encountered '|Name|' with differing sort definitions')).

% add information about consant in attributes    
build_atomic_Variable(Name,Variable,Variable_variable,Sort,Source,InputMapping,InputMapping_new,Sorts,Sorts_new) :-
    put_attr(Variable,type,atomic),
    build_sort_Variable(Sort,SortVar,Sorts,Sorts_new),
    put_attr(Variable,sort_link,SortVar),
    put_attr(Variable,name,Name),
    put_attr(Variable,source,Source),
    put_attr(Variable,var_link,Variable_variable),
    %prebuild reverse link so it can be used by unstruct for generalisations
    put_attr(Variable_variable,reverse_link,f_reverse(Variable)),
    put_attr(Variable_variable,sort_link,SortVar),
    varset_add(Variable,InputMapping,InputMapping_new).
    
%-------------------------------------------------------------------------------    

%recurse through list of terms
termstruct_arguments([],[],Place,Place,InputMapping,InputMapping,Sorts,Sorts) :- !.
termstruct_arguments([Head|Tail],[Head_struct|Tail_struct],Place,Place_next,InputMapping,InputMapping_new,Sorts,Sorts_new) :-
	termstruct(Head,Head_struct,Place,Place_tmp,InputMapping,InputMapping_tmp,Sorts,Sorts_tmp),
	termstruct_arguments(Tail,Tail_struct,Place_tmp,Place_next,InputMapping_tmp,InputMapping_new,Sorts_tmp,Sorts_new).

set_termstructattributes(Var,Place,Place_next) :-
	put_attr(Var,place,Place),
	succ(Place,Place_next).
	
% annotates a variable with the sum of symbols its subterms 
% used as heuristic in main:cost_nomatch
store_count_predicates(Attributevar:Term):-
    count_predicates(Attributevar:Term,Count),
    put_attr(Attributevar,number_predicates,Count).

% counts number of symbols in term   
count_predicates(Term,C):-
    count_predicates(Term,0,C).
    
count_predicates(_:Var,C,C_new):-
    var(Var),!,
    succ(C,C_new).

count_predicates(_:(_,List),C,C_new):-
    succ(C,C_tmp),
    count_predicates_list(List,C_tmp,C_new).

count_predicates_list([],C,C).

count_predicates_list([T|T_list],C,C_new):-
    count_predicates(T,C,C_tmp),
    count_predicates_list(T_list,C_tmp,C_new).

collect_struct_variables(Term_struct_list,Names):-
    collect_struct_variables_list(Term_struct_list,[],Names).

collect_struct_variables(_:Var,Variables,Variables_new):-
    var(Var),!,
    varset_add(Var,Variables,Variables_new).

collect_struct_variables(_:(Var,Term_struct_list),Variables,Variables_new):-
    varset_add(Var,Variables,Variables_tmp),
    collect_struct_variables_list(Term_struct_list,Variables_tmp,Variables_new).

collect_struct_variables_list([],Variables,Variables).

collect_struct_variables_list([Term_struct|Term_struct_list],Variables,Variables_new):-
    collect_struct_variables(Term_struct,Variables,Variables_tmp),
    collect_struct_variables_list(Term_struct_list,Variables_tmp,Variables_new).

%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
% these are predicates that help to reverse substitutions made on terms
% they are used to trace the instantiation ordering

% traverses anti-instance to find reverse-links to instances of this term
undo_subst(A:Var,A:(Pname_result,Args_result)):-
    var(Var),
    get_attr(Var,reverse_link,Reverseinfo),!,
    reverse_subst(Reverseinfo,[],Pname_before,Args_before),
    undo_subst(A:(Pname_before,Args_before),A:(Pname_result,Args_result)).

undo_subst(A:Var,A:Var):-
    var(Var),!.    

undo_subst(A:(Pname,Args),A:(Pname_result,Args_result)):-
    get_attr(Pname,reverse_link,Reverseinfo),!,
    reverse_subst(Reverseinfo,Args,Pname_before,Args_before),
    undo_subst(A:(Pname_before,Args_before),A:(Pname_result,Args_result)).
    
undo_subst(A:(Pname,Args),A:(Pname,Args_before)):-
    undo_subst_list(Args,Args_before).

undo_subst_list([],[]).
    
undo_subst_list([Arg|Args],[Arg_before|Args_before]):-
    undo_subst(Arg,Arg_before),
    undo_subst_list(Args,Args_before).

%-------------------------------------------------------------------------------

% reverses substitutions
reverse_subst(f_reverse(Pname_before),Args,Pname_before,Args).

reverse_subst(i_reverse(Pname_before,Args_before_insertion,Args_after_insertion),Args,Pname_before,Args_before):-
    copy_term((Args_before_insertion,Args_after_insertion),(Args,Args_before)).

reverse_subst(e_reverse(Pname_before,Args_before_embedding,Args_after_embedding),Args,Pname_before,Args_before):-
    copy_term((Args_before_embedding,Args_after_embedding),(Args,Args_before)).

reverse_subst(p_reverse(Pname_before,Args_before_permutation,Args_after_permutation),Args,Pname_before,Args_before):-
    copy_term((Args_before_permutation,Args_after_permutation),(Args,Args_before)).

%-------------------------------------------------------------------------------

antiu_trace(f_reverse,A:Var,trace(f_reverse,A:Pname_before)):-
    var(Var),
    get_attr(Var,reverse_link,Reverseinfo),
    functor(Reverseinfo,f_reverse,_),!,
    reverse_subst(Reverseinfo,[],Pname_before,[]).

antiu_trace(i_reverse,A:Var,Result):-
    var(Var),!,
    get_attr(Var,reverse_link,Reverseinfo),
    functor(Reverseinfo,i_reverse,_),
    reverse_subst(Reverseinfo,[],Pname_before,Args_before),
    (
     Result = trace(i_reverse,A:(Pname_before,Args_before))
    ;
     antiu_trace(i_reverse,A:(Pname_before,Args_before),Result)
    ).

antiu_trace(Mode,A:(Pname,Args),Result):-
    get_attr(Pname,reverse_link,Reverseinfo),
    functor(Reverseinfo,Mode,_),!,
    reverse_subst(Reverseinfo,Args,Pname_before,Args_before),
    (
     Result = trace(Mode,A:(Pname_before,Args_before))
    ;
     antiu_trace(Mode,A:(Pname_before,Args_before),Result)
    ).
    
antiu_trace(Mode,A:(Pname,Args),trace(Mode,A:(Pname,Args_before))):-
    antiu_trace_list(Mode,Args,Args_before).
    
antiu_trace_list(Mode,[Arg|Args],Result):-
    antiu_trace(Mode,Arg,trace(Mode,Arg_before)),!,
    (
     Result = [Arg_before|Args]
     ;
     antiu_trace_list(Mode,[Arg_before|Args],Result)
    ).

antiu_trace_list(Mode,[Arg|Args],[Arg|Args_before]):-
    antiu_trace_list(Mode,Args,Args_before).

% traces an anti-instance to its orginal term
antiu_trace_all(Term,Tracelist):-
    antiu_trace_by_mode(p_reverse,Term       ,Tracelist_permutation,Term_p_last),
    antiu_trace_by_mode(e_reverse,Term_p_last,Tracelist_embedding  ,Term_e_last),
    antiu_trace_by_mode(i_reverse,Term_e_last,Tracelist_insertion  ,Term_i_last),
    antiu_trace_by_mode(f_reverse,Term_i_last,Tracelist_fixation   ,_          ),
    append(Tracelist_permutation,Tracelist_embedding,Tracelist_tmp ),
    append(Tracelist_tmp        ,Tracelist_insertion,Tracelist_tmp2),
    append(Tracelist_tmp2       ,Tracelist_fixation ,Tracelist     ).

antiu_trace_by_mode(Mode,Term,Tracelist,Term_last):-
    bagof(Trace,antiu_trace(Mode,Term,Trace),Tracelist),!,
    lasttermintrace(Term_last,Tracelist).

antiu_trace_by_mode(_,Term,[],Term).

lasttermintrace(Term,[trace(_,Term)]):-!.
lasttermintrace(Term,[_|T]):-
    lasttermintrace(Term,T). 

%-------------------------------------------------------------------------------