:- configure(config).
:- consult(metric).
:- consult(fixation).
:- consult(insertion).
:- consult(embedding).
:- consult(permutation).

%###############################################################################
% generation of internal work structure 
%###############################################################################

antiunify_terms(Term1_struct,Term2_struct,Result) :-
    antiunify_terms(Term1_struct,Term2_struct,16777215,Result).


antiunify_terms(Term1_struct,Term2_struct,Limit,Result) :-
    flag(startmode,Startmode),
    flag(startposition,Startposition),
    Start=..[Startmode,Startposition],!,
    antiunify([anti(0,(Start,s([],[],[],[])),Term1_struct)],
	          [anti(0,(Start,s([],[],[],[])),Term2_struct)],[],[],Limit,[],Result).
%-------------------------------------------------------------------------------

%###############################################################################
% main breath first search loop 
%###############################################################################

antiunify([anti(C1,S1,T1)|T1_Open_Rest],[anti(C2,S2,T2)|T2_Open_Rest],T1_Closed,T2_Closed,Limit,Result,Result_new):-
    C1<C2,C1=<Limit,!,antiunify_next_s(anti(C1,S1,T1),                T1_Open_Rest ,[anti(C2,S2,T2)|T2_Open_Rest],T1_Closed,T2_Closed,Limit,Result,Result_new).

antiunify([anti(C1,S1,T1)|T1_Open_Rest],[anti(C2,S2,T2)|T2_Open_Rest],T1_Closed,T2_Closed,Limit,Result,Result_new):-
          C2=<Limit,!,antiunify_next_t(anti(C2,S2,T2),[anti(C1,S1,T1)|T1_Open_Rest],                T2_Open_Rest ,T1_Closed,T2_Closed,Limit,Result,Result_new).

antiunify([anti(C1,S1,T1)|T1_Open_Rest],[]                           ,T1_Closed,T2_Closed,Limit,Result,Result_new):-
          C1=<Limit,!,antiunify_next_s(anti(C1,S1,T1),T1_Open_Rest                 ,[]                           ,T1_Closed,T2_Closed,Limit,Result,Result_new).
    
antiunify([]                           ,[anti(C2,S2,T2)|T2_Open_Rest],T1_Closed,T2_Closed,Limit,Result,Result_new):-
          C2=<Limit,!,antiunify_next_t(anti(C2,S2,T2),[]                           ,T2_Open_Rest                 ,T1_Closed,T2_Closed,Limit,Result,Result_new).
 
antiunify(_,_,_,_,_,Result,Result).

%-------------------------------------------------------------------------------
   	
%-------------------------------------------------------------------------------
   	
antiunify_next_s(Anti,T1_Open,T2_Open,T1_Closed,T2_Closed,Limit,Results,Results_new) :-
    find_results(s,Anti,T2_Closed,Limit,Limit_new,Results,Results_next),
    expand_antiinstances(Anti,T1_Open,T1_Open_new),   
    antiunify(T1_Open_new,T2_Open,[Anti|T1_Closed],T2_Closed,Limit_new,Results_next,Results_new). 		       

%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------

antiunify_next_t(Anti,T1_Open,T2_Open,T1_Closed,T2_Closed,Limit,Results,Results_new) :-
    find_results(t,Anti,T1_Closed,Limit,Limit_new,Results,Results_next),
    expand_antiinstances(Anti,T2_Open,T2_Open_new),
    antiunify(T1_Open,T2_Open_new,T1_Closed,[Anti|T2_Closed],Limit_new,Results_next,Results_new). 		       

%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------

find_results(Side,Anti,Closed,Limit,Limit_new,Results,Results_next):-
    gmember(Side,Limit,Anti,Closed,[],Results_match),
    filtersmallest(Limit,Results_match,[],Results_gen),
    Results_gen = [result(Csum,_,_)|_],
    Csum=<Limit,
    compare(Op,Csum,Limit),
    case_results(Op,Csum,Results_gen,Limit,Limit_new,Results,Results_next)
    ,!.

find_results(_,_,_,Limit,Limit,Results,Results).        

%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------

case_results(=,_,Results_gen,Limit,Limit,Results,Results_next):-
    append(Results_gen,Results,Results_next).
         
case_results(<,C,Results_gen,_    ,C    ,_      ,Results_gen ).

%-------------------------------------------------------------------------------

%###############################################################################
% expand all onestep anti-instances of a term 
%###############################################################################
expand_antiinstances(A,Open,Open_new) :-
    expandmode(A,Mode),
    %print('#######################################'),nl,
    %print_antiinstance(A),nl,
    modefindall(Mode,A,Antiinstances),
    %print_antiinstances(Antiinstances),nl,
    sort(Antiinstances,Antiinstances_sorted),
	amerge(Antiinstances_sorted,Open,Open_new).
	
expandmode(anti(_,(Mode,_),_),Mode).

%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------

%NEVER use findall here, it does not produce sharing variables.

%TODO since A might be changed we need to carry the side effects of rerepsentation
modefindall(i(_),A,Antiinstances) :-
	( bagof(A_new,( ( flag(term_insertion_allowed  ),term_insertion(A,A_new)      );
	                ( flag(term_embedding_allowed  ),term_embedding_new(A,A_new)  );
	                ( flag(term_permutation_allowed),term_permutation_new(A,A_new))
	              ),Antiinstances)
     ;
      Antiinstances=[]
    ),!.

modefindall(e(_),A,Antiinstances) :-
	( bagof(A_new,( ( flag(term_embedding_allowed  ),term_embedding(A,A_new)       );
	                ( flag(term_permutation_allowed),term_permutation_new(A,A_new) )
	              ),Antiinstances)
     ;
      Antiinstances=[]
    ),!.

modefindall(p(_),A,Antiinstances) :-
	( bagof(A_new,( flag(term_permutation_allowed),term_permutation(A,A_new)
	              ),Antiinstances)
     ;
      Antiinstances=[]
    ),!.

%-------------------------------------------------------------------------------

%###############################################################################
% helper
%###############################################################################

amerge([Preanalogy|Rest],Old,Merge):-
    arg(1,Preanalogy,Cost),
    amerge(Cost,Preanalogy,Rest,Old,Merge).

amerge([],Old,Old).
    
amerge(_,P,Ps_rest,[],[P|Ps_rest]):-!.
amerge(Cost,P,Ps_rest,[Preanalogy|Old],Merge):-
    arg(1,Preanalogy,Cost_old),
    Cost < Cost_old,!,
    amerge(Ps_rest,[P,Preanalogy|Old],Merge).   
    
amerge(Cost,P,Ps_rest,[Preanalogy|Old],[Preanalogy|Merge]):-
    amerge(Cost,P,Ps_rest,Old,Merge).        

%-------------------------------------------------------------------------------
gmember(_,_,_,[],R,R). %notrace,nodebug.

gmember(Side,Limit,Anti,[Anti_match|Rest],Result,Result_new) :-
    Anti = anti(Cost1,_,_),
    Anti_match = anti(Cost2,_,_),
    plus(Cost1,Cost2,Cost_sum),
    Cost_sum =< Limit,
    %copy_term_nat(Term,Term_noattr),
	%copy_term_nat(Termmatch,Termmatch_noattr),
	%print_antiinstance(Anti),print(' against '),print_antiinstance(Anti_match),nl,
	%print(Anti),print(' against '),print(Anti_match),nl,
	%Term_noattr =@= Termmatch_noattr, %this operation also checks for attribute structure equallity , thats why we did strip them before
	%trace,
	gcheck(Limit,Anti,Anti_match,Anti_new,Anti_match_new),!,
    %nodebug,notrace,
    %print('done'),nl,
	build_result(Side,Anti_new,Anti_match_new,Result_match),
	gmember(Side,Limit,Anti,Rest,[Result_match|Result],Result_new).
	
gmember(Side,Limit,Anti,[_|Rest],Result,Result_new) :-	
    gmember(Side,Limit,Anti,Rest,Result,Result_new).

%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------

gcheck(Limit,anti(Cost1,Subst1,Term1),anti(Cost2,Subst2,Term2),anti(Cost1_new,Subst1_new,Term1_new),anti(Cost2_new,Subst2_new,Term2_new)):-
    unifiable(Term1,Term2,_),%fast check if structurally equal
    predicate_variables(anti(Cost1,Subst1,Term1),anti(Cost2,Subst2,Term2),anti(Cost1_new,Subst1_new,Term1_new),anti(Cost2_new,Subst2_new,Term2_new),[],_),
    plus(Cost1_new,Cost2_new,Cost_sum_new),
    Cost_sum_new =< Limit.
    
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------    
predicate_variables(anti(Cost1,Subst1,A1:Var1),anti(Cost2,Subst2,A2:Var2),anti(Cost1_new,Subst1_new,A1:Var1_new),anti(Cost2_new,Subst2_new,A2:Var2_new),Bindings,Bindings_new):-
    % the semantics of this:
    % ((    var(Var1) ,     var(Var2)) -> !,....);
    % ((not(var(Var1)),     var(Var2)) -> !,fail);
    % ((    var(Var1) ,not(var(Var2))) -> !,fail);
    % ((not(var(Var1)),not(var(Var2))) ->   fail)
    var(Var1)->(!,var(Var2),gcheck_var(varanti(Cost1,Subst1,Var1),varanti(Cost2,Subst2,Var2),varanti(Cost1_new,Subst1_new,Var1_new),varanti(Cost2_new,Subst2_new,Var2_new),Bindings,Bindings_new));(var(Var2),!,fail).
    
predicate_variables(anti(Cost1    ,Subst1    ,_:(Var1    ,List1    )),anti(Cost2    ,Subst2    ,_:(Var2    ,List2    )),
                    anti(Cost1_new,Subst1_new,_:(Var1_new,List1_new)),anti(Cost2_new,Subst2_new,_:(Var2_new,List2_new)),
                    Bindings,Bindings_new):-
    gcheck_var(               varanti(Cost1    ,Subst1    ,Var1     ), varanti(Cost2    ,Subst2    ,Var2     ),
                              varanti(Cost1_tmp,Subst1_tmp,Var1_new ), varanti(Cost2_tmp,Subst2_tmp,Var2_new ),
                             Bindings    ,Bindings_tmp),
    predicate_variables_list(listanti(Cost1_tmp,Subst1_tmp,List1    ),listanti(Cost2_tmp,Subst2_tmp,List2    ),
                             listanti(Cost1_new,Subst1_new,List1_new),listanti(Cost2_new,Subst2_new,List2_new),
                             Bindings_tmp,Bindings_new).

%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------

predicate_variables_list(listanti(Cost1    ,Subst1    ,[]                    ),listanti(Cost2    ,Subst2    ,[]                    ),
                         listanti(Cost1    ,Subst1    ,[]                    ),listanti(Cost2    ,Subst2    ,[]),
                         B                                                    ,B                               ).

predicate_variables_list(listanti(Cost1    ,Subst1    ,[A1:Var1    |List1    ]),listanti(Cost2    ,Subst2    ,[A2:Var2    |List2    ]),
                         listanti(Cost1_new,Subst1_new,[A1:Var1_new|List1_new]),listanti(Cost2_new,Subst2_new,[A2:Var2_new|List2_new]),
                         Bindings,Bindings_new):-
    % the semantics of this:
    % ((    var(Var1) ,     var(Var2)) -> !,....);
    % ((not(var(Var1)),     var(Var2)) -> !,fail);
    % ((    var(Var1) ,not(var(Var2))) -> !,fail);
    % ((not(var(Var1)),not(var(Var2))) ->   fail)
    var(Var1)->
    (!,
     var(Var2),
     gcheck_var(               varanti(Cost1    ,Subst1    ,Var1     ), varanti(Cost2    ,Subst2    ,Var2     ),
                               varanti(Cost1_tmp,Subst1_tmp,Var1_new ), varanti(Cost2_tmp,Subst2_tmp,Var2_new ),
                              Bindings,Bindings_tmp),
     predicate_variables_list(listanti(Cost1_tmp,Subst1_tmp,List1    ),listanti(Cost2_tmp,Subst2_tmp,List2    ),
                              listanti(Cost1_new,Subst1_new,List1_new),listanti(Cost2_new,Subst2_new,List2_new),
                              Bindings_tmp,Bindings_new)
    )
    ;
    (var(Var2),!,fail).


predicate_variables_list(listanti(Cost1    ,Subst1    ,[A1:(Var1    ,Arg1    )|List1    ]),listanti(Cost2    ,Subst2    ,[A2:(Var2    ,Arg2    )|List2    ]),
                         listanti(Cost1_new,Subst1_new,[A1:(Var1_new,Arg1_new)|List1_new]),listanti(Cost2_new,Subst2_new,[A2:(Var2_new,Arg2_new)|List2_new]),
                         Bindings,Bindings_new):-
     gcheck_var(               varanti(Cost1     ,Subst1     ,Var1     ), varanti(Cost2     ,Subst2     ,Var2     ),
                               varanti(Cost1_tmp ,Subst1_tmp ,Var1_new ), varanti(Cost2_tmp ,Subst2_tmp ,Var2_new ),
                              Bindings     ,Bindings_tmp ),
     predicate_variables_list(listanti(Cost1_tmp ,Subst1_tmp ,Arg1     ),listanti(Cost2_tmp ,Subst2_tmp ,Arg2     ),
                              listanti(Cost1_tmp2,Subst1_tmp2,Arg1_new ),listanti(Cost2_tmp2,Subst2_tmp2,Arg2_new ),
                              Bindings_tmp ,Bindings_tmp2),
     predicate_variables_list(listanti(Cost1_tmp2,Subst1_tmp2,List1    ),listanti(Cost2_tmp2,Subst2_tmp2,List2    ),
                              listanti(Cost1_new ,Subst1_new ,List1_new),listanti(Cost2_new ,Subst2_new ,List2_new),
                              Bindings_tmp2,Bindings_new ).

%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------

gcheck_var(varanti(_,_,Var1),varanti(_,_,Var2),_,_,_,_):-
    get_attr(Var1,sort_link,Var1_SortVar),
    get_attr(Var2,sort_link,Var2_SortVar),
    not(lca_sorts(Var1_SortVar,Var2_SortVar,_)),
    !,
    fail.

gcheck_var(varanti(Cost1,Subst1,Var1),varanti(Cost2,Subst2,Var2),
           varanti(Cost1,Subst1,Var1),varanti(Cost2,Subst2,Var2),
           Bindings,Bindings_new):-
    get_attr(Var1,type,atomic),
    get_attr(Var2,type,atomic),
    get_attr(Var1,name,Name),
    get_attr(Var2,name,Name),
    get_attr(Var1,var_link,Var1_new),
    get_attr(Var2,var_link,Var2_new),
    (flag(one_to_one)->onetoone_checkbindings(  Var1_new,Var2_new,Bindings,Bindings_new)
                      ;onetomany_checkbindings(Var1_new,Var2_new,Bindings,Bindings_new)
    )
    ,!.
    
gcheck_var(varanti(Cost1    ,(M1,s(F1    ,I1,E1,P1)),Var1    ),varanti(Cost2    ,(M2,s(F2    ,I2,E2,P2)),Var2    ),
           varanti(Cost1_new,(M1,s(F1_new,I1,E1,P1)),Var1_new),varanti(Cost2_new,(M2,s(F2_new,I2,E2,P2)),Var2_new),
           Bindings,Bindings_new):-
    %print:print_variable_names([Var1,Var2]),nl,
    not(get_attr(Var1,sig,'$casl_symbol')),
    not(get_attr(Var2,sig,'$casl_symbol')),
    make_pname_variable(Cost1,Cost1_new,Var1,Var1_new,F1,F1_new),
    make_pname_variable(Cost2,Cost2_new,Var2,Var2_new,F2,F2_new),!,
    %print:print_variable_names([Var1_new,Var2_new]),nl,
    (flag(one_to_one)->onetoone_checkbindings(  Var1_new,Var2_new,Bindings,Bindings_new)
                      ;onetomany_checkbindings(Var1_new,Var2_new,Bindings,Bindings_new)
    )
    %notrace,nodebug,
    %print('good'),nl
    ,!.
            
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
onetoone_checkbindings(Var1,Var2,Bindings,Bindings):-
    (
     (get_attr(Var1,sort_link,Var1_SortVar),get_attr(Var1_SortVar,name,'nomap'))
    ;
     (get_attr(Var2,sort_link,Var2_SortVar),get_attr(Var2_SortVar,name,'nomap'))
    ),!.

onetoone_checkbindings(Var1,Var2,Bindings,Bindings_new):-
    %print_term_follow_links(_:Var1),print(' '),print_term_follow_links(_:Var2),nl,
    %(get_attr(Var1,f_link,L1)->print(L1),nl;true),
    not(get_attr(Var1,general_link,_)),
    not(get_attr(Var2,general_link,_)),!,
    onetoone_checkbindings_aux(Var1,Var2,Bindings,Bindings_new).

onetoone_checkbindings(Var1,Var2,Bindings,Bindings):-
    get_attr(Var1,general_link,[Gvar1]),
    get_attr(Gvar1,name,_Gname1),
    get_attr(Gvar1,source_link,_),
    get_attr(Gvar1,target_link,_),
    get_attr(Var2,general_link,[Gvar2]),
    get_attr(Gvar2,name,_Gname2),
    get_attr(Gvar2,source_link,_),
    get_attr(Gvar2,target_link,_),
    Gvar1==Gvar2. 
     
    
onetoone_checkbindings_aux(Var1,Var2,[],[(Var1,Var2)]).

onetoone_checkbindings_aux(Var1,Var2,[(Bindvar1,Bindvar2)|Rest],[(Bindvar1,Bindvar2)|Rest_new]):-
    ((Var1==Bindvar1)->
        Var2==Bindvar2,
        Rest_new=Rest % it is already in local bindings
        ;
        not(Var2==Bindvar2),
        onetoone_checkbindings_aux(Var1,Var2,Rest,Rest_new)
    ).

    
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
onetomany_checkbindings(Var1,Var2,Bindings,Bindings):-
    (
     (get_attr(Var1,sort_link,Var1_SortVar),get_attr(Var1_SortVar,name,'nomap'))
    ;
     (get_attr(Var2,sort_link,Var2_SortVar),get_attr(Var2_SortVar,name,'nomap'))
    ),!.

onetomany_checkbindings(Var1,Var2,Bindings,Bindings):-
    get_attr(Var1,general_link,Gvar1_list),
    get_attr(Var2,general_link,Gvar2_list),!,
    member(Gvar1,Gvar1_list),
    member(Gvar2,Gvar2_list),
    Gvar1==Gvar2,!. 

onetomany_checkbindings(Var1,Var2,Bindings,Bindings):-
    member_tuple(Var1,Var2,Bindings),!.

onetomany_checkbindings(Var1,Var2,Bindings,[(Var1,Var2)|Bindings]):-
    get_attr(Var1,general_link,Gvar1_list),!,
    not(member_tuple_second(Var2,Bindings)),
    onetomany_check_list(Var1,Gvar1_list).

onetomany_checkbindings(Var1,Var2,Bindings,[(Var1,Var2)|Bindings]):-
    get_attr(Var2,general_link,Gvar2_list),!,
    not(member_tuple_first(Var1,Bindings)),
    onetomany_check_list(Var2,Gvar2_list).
    
onetomany_checkbindings(Var1,Var2,Bindings,[(Var1,Var2)|Bindings]):-
    not(member_tuple_first(Var1,Bindings)),!.
    
onetomany_checkbindings(Var1,Var2,Bindings,[(Var1,Var2)|Bindings]):-
    not(member_tuple_second(Var2,Bindings)),!.

onetomany_check_list(_,[_|_]):-!.

onetomany_check_list(OVar,[GVar]):-
    get_attr(GVar,source_link,SVar),
    not(SVar==OVar),!,% make sure to not check the side were we came from
    get_attr(SVar,general_link,[_]). %single link
    
onetomany_check_list(OVar,[GVar]):-
    get_attr(GVar,target_link,TVar),
    not(TVar==OVar),!,% make sure to not check the side were we came from
    get_attr(TVar,general_link,[_]). %single link
    

member_tuple(Var1,Var2,[(Bindvar1,Bindvar2)|_]):-
    Var1==Bindvar1,
    Var2==Bindvar2,!.

member_tuple(Var1,Var2,[_|Rest]):-
    member_tuple(Var1,Var2,Rest).    

member_tuple_second(Var2,[(_,Bindvar2)|_]):-
    Var2==Bindvar2,!.

member_tuple_second(Var2,[_|Rest]):-
    member_tuple_first(Var2,Rest).    

member_tuple_first(Var1,[(Bindvar1,_)|_]):-
    Var1==Bindvar1,!.
    
member_tuple_first(Var1,[_|Rest]):-
    member_tuple_first(Var1,Rest).    

%-------------------------------------------------------------------------------

manytomany_checkbindings(Var1,Var2,Bindings,Bindings):-
    member_tuple(Var1,Var2,Bindings),!.

manytomany_checkbindings(Var1,Var2,Bindings,[(Var1,Var2)|Bindings]).
    
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------

build_result(s,anti(Cost,Subst,Term),anti(Cost_match,Subst_match,Term_match),result(Csum,anti(Cost,Subst,Term),anti(Cost_match,Subst_match,Term_match))):-
    plus(Cost,Cost_match,Csum).
    
build_result(t,anti(Cost,Subst,Term),anti(Cost_match,Subst_match,Term_match),result(Csum,anti(Cost_match,Subst_match,Term_match),anti(Cost,Subst,Term))):-
    plus(Cost,Cost_match,Csum).

%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
% "It's easier to ask forgiveness than it is to get permission"
get_attr_subst(V,Attribute,Value):-
    get_attr(V,Attribute,Value),!.

get_attr_subst(_V,_Attribute,[]).    

%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------

filtersmallest(_,[],R,R).

%using arg/3 or compare/3 will gain no performance here
filtersmallest(Limit,[result(Limit,Anti1,Anti2)|Rest],Result,Result_new):-!,
    filtersmallest(Limit,Rest,[result(Limit,Anti1,Anti2)|Result],Result_new).

filtersmallest(Limit,[result(C,Anti1,Anti2)|Rest],_,Result_new):-
    C < Limit,!,
    filtersmallest(C,Rest,[result(C,Anti1,Anti2)],Result_new).

filtersmallest(Limit,[_|Rest],Result,Result_new):-
    filtersmallest(Limit,Rest,Result,Result_new).

%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
copy_attribute(Name,Pname,Pname_new):-
    get_attr(Pname,Name,Value),!,
    put_attr(Pname_new,Name,Value).

copy_attribute(_,_,_).

%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
%make sure all copies are done if algorithm extended
copy_for_keepmode(Pname,Pname_atomic_new):-
    copy_attribute(name,Pname,Pname_atomic_new),
    copy_attribute(type,Pname,Pname_atomic_new),
    copy_attribute(sort_link,Pname,Pname_atomic_new),
    put_attr(Pname_atomic_new,var_link,Pname_new),
    %prebuild reverse link so it can be used by unstruct for generalisations
    put_attr(Pname_new,reverse_link,f_reverse(Pname_atomic_new)),
    copy_attribute(sort_link,Pname_atomic_new,Pname_new),
    copy_modifiers(Pname,Pname_atomic_new).

%-------------------------------------------------------------------------------    

%-------------------------------------------------------------------------------
copy_modifiers(Pname,Pname_new) :-
    copy_attribute(cost_p,Pname,Pname_new),
    copy_attribute(cost_e,Pname,Pname_new),
    copy_attribute(cost_i,Pname,Pname_new),
    copy_attribute(mode_p,Pname,Pname_new),
    copy_attribute(mode_e,Pname,Pname_new),
    copy_attribute(mode_i,Pname,Pname_new).

%-------------------------------------------------------------------------------