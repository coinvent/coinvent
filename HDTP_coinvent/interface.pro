gen_from_to_casl(Min,Max,Analogy):-
    flag(solutioncounter,_,1),
    gen_simple_casl(Analogy,Result),
    flag(solutioncounter,X,X),
    (X>=Min->print_casl(Result)
            ;
            true
    ),
    (X>=Max->halt
            ;
            true
    ),
    plus(1,X,Xsucc),
    flag(solutioncounter,_,Xsucc),
    fail.

gen_simple_casl(Analogy):-
    gen_simple_casl(Analogy,Result),
    print_casl(Result).

gen_simple_casl(Analogy,Result):-
    analogystruct(Analogy,Preanalogy_struct),
    %Preanalogy_struct=preanalogy(_,source(Source_domain,_,_),target(Target_domain,_,_),_,_),
    %write('source = '),nl,print_pretty_domain(Source_domain),nl,nl,
    %write('target = '),nl,print_pretty_domain(Target_domain),nl,nl,
    disable(term_insertion_allowed),
	  disable(term_embedding_allowed),
	  disable(term_permutation_allowed),!,
	  mapping_cont(Preanalogy_struct,Result).

% build_antiunifications(+Domain1,+Domain2)
build_antiunifications(domain(S_domain_name,Source),domain(T_domain_name,Target)):-
    !,
    clausestruct(Source,Source_struct,[],Source_Subst,[],Source_Sorts),
    %integrate knowledge about domain into the term lattice
    subst_preload(S_domain_name,Source_Subst),
    sorts_preload(S_domain_name,Source_Sorts),
    clausestruct(Target,Target_struct,[],Target_Subst,[],Target_Sorts),
    %integrate knowledge about domain into the term lattice
    subst_preload(T_domain_name,Target_Subst),
    sorts_preload(T_domain_name,Target_Sorts),
    nl,print('antiunifying: '),print_term(Source_struct),print(' with '),print_term(Target_struct),nl,nl,
    antiunify_terms(Source_struct,Target_struct,Results),
    Results = [result(Cost,_,_)|_],
    print('Generalisations with costs '),print(Cost),print(':'),nl,nl,
    %print(Results),
    print_pretty_antiu_results(Results).

% overload build_antiunifications/2 to have default domain none selected when no domains are is given
build_antiunifications(Source,Target):-
    build_antiunifications(domain('none',Source),domain('none',Target)).    

% overload build_antiunifications/2 to have default domain for both term lattices if given explicitly
build_antiunifications(Domain,Source,Target):-
    build_antiunifications(domain(Domain,Source),domain(Domain,Target)).    

% get_antiunificationcost(+Domain1,+Domain2,-Cost) 
get_antiunificationcost(domain(S_domain_name,Source),domain(T_domain_name,Target),Cost):-
    clausestruct(Source,Source_struct,[],Source_Subst,[],Source_Sorts),
    %integrate knowledge about domain into the term lattice
    subst_preload(S_domain_name,Source_Subst),
    sorts_preload(S_domain_name,Source_Sorts),
    clausestruct(Target,Target_struct,[],Target_Subst,[],Target_Sorts),
    %integrate knowledge about domain into the term lattice
    subst_preload(T_domain_name,Target_Subst),
    sorts_preload(T_domain_name,Target_Sorts),
    antiunify_terms(Source_struct,Target_struct,Results),
    Results = [result(Cost,_,_)|_].