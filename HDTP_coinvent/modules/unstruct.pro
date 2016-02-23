:- module(unstruct,[unstruct_term/2,
                    unstruct_terms/2,
                    unstruct_term_fol/2,
                    unstruct_terms_fol/2,
                    unstruct_term_follow_links/2, 
                    unstruct_generalisation_term/2,
                    unstruct_generalisation_term_bylink/3,
                    unstruct_casl_generalisation_term/2,
                    generalisation_casl_atom/2,
                    degen_to_domain/2,
                    extract_mappings/2,
                    extract_variable_mappings/2,
                    filter_symbol_mappings/2
                   ]).

% generates a string representation of a term and follows links to get 
% function symbol names 
unstruct_term_follow_links(_:Var,Term):-
    var(Var),!,
    name_atom_follow_links(Var,Term).

unstruct_term_follow_links(_:(Pname,Args),Term):-
    name_atom_follow_links(Pname,Pname_term),
    unstruct_terms_follow_links(Args,Args_term),
    Term=..[Pname_term|Args_term].

unstruct_terms_follow_links([],[]).
unstruct_terms_follow_links([Arg|Args],[Term|Terms]):-
    unstruct_term_follow_links(Arg,Term),
    unstruct_terms_follow_links(Args,Terms).

% generates a string representation of a term
unstruct_term(_:Var,Term):-
    var(Var),!,
    term_atom(Var,Term).

unstruct_term(_:(Pname,Args),Term):-
    term_atom(Pname,Pname_term),
    unstruct_terms(Args,Args_term),
    Term=..[Pname_term|Args_term].

unstruct_terms([],[]).
unstruct_terms([Arg|Args],[Term|Terms]):-
    unstruct_term(Arg,Term),
    unstruct_terms(Args,Terms).

% generates a string representation of a term without sort
unstruct_term_name(_:Var,Term):-
    var(Var),!,
    name_atom(Var,Term).

unstruct_term_name(_:(Pname,Args),Term):-
    name_atom(Pname,Pname_term),
    unstruct_terms_name(Args,Args_term),
    Term=..[Pname_term|Args_term].

unstruct_terms_name([],[]).
unstruct_terms_name([Arg|Args],[Term|Terms]):-
    unstruct_term_name(Arg,Term),
    unstruct_terms_name(Args,Terms).

% generates term structure without sorts and keeps first order variables as prolog variables
unstruct_term_fol(A:Var,QTerm):-
    get_attr(A,quantifier,Quantifier),!,
    unstruct_term_fol(_:Var,Term),  
    unstruct_quantifier(Quantifier,Term,QTerm).

unstruct_term_fol(_:Var,Term):-
    var(Var),!,
    name_atom_fol(Var,Term).

unstruct_term_fol(_:(Pname,_),_):-
    not(get_attr(Pname,type,atomic)),!,
    write('unstruct: variable in predicate functor not allowed!').

unstruct_term_fol(_:(Pname,Args),Term):-
    get_attr(Pname,type,atomic),!,%guard against predicate variables
    name_atom_fol(Pname,Pname_term),
    unstruct_terms_fol(Args,Args_term),
    Term=..[Pname_term|Args_term].

unstruct_terms_fol([],[]).
unstruct_terms_fol([Arg|Args],[Term|Terms]):-
    unstruct_term_fol(Arg,Term),
    unstruct_terms_fol(Args,Terms).

unstruct_generalisation_term_bylink(Link,_:Var,_:Term):-
    var(Var),!,
    unstruct_generalisation_atom_bylink(Link,Var,Term).

unstruct_generalisation_term_bylink(Link,_:(Pname,Args),_:(Pname_term,Args_term)):-
    unstruct_generalisation_atom_bylink(Link,Pname,Pname_term),
    unstruct_generalisation_terms_bylink(Link,Args,Args_term).


%explicit cut because otherwise choice point is left behind.
unstruct_generalisation_terms_bylink(_,[],[]):-!.

unstruct_generalisation_terms_bylink(Link,[Arg|Args],[Term|Terms]):-
    unstruct_generalisation_term_bylink(Link,Arg,Term),
    unstruct_generalisation_terms_bylink(Link,Args,Terms).

unstruct_generalisation_atom_bylink(Link,Var,Svar):-
    get_attr(Var,Link,Svar).

unstruct_casl_generalisation_term(_:Var,Term):-
    var(Var),!,
    generalisation_casl_atom(Var,Term).

unstruct_casl_generalisation_term(_:(Pname,Args),Term):-
    generalisation_casl_atom(Pname,Pname_term),
    unstruct_casl_generalisation_terms(Args,Args_term),
    Term=..[Pname_term|Args_term].

unstruct_casl_generalisation_terms([],[]).
unstruct_casl_generalisation_terms([Arg|Args],[Term|Terms]):-
    unstruct_casl_generalisation_term(Arg,Term),
    unstruct_casl_generalisation_terms(Args,Terms).
    
unstruct_generalisation_term(_:Var,Term):-
    var(Var),!,
    generalisation_casl_atom(Var,Term).

unstruct_generalisation_term(_:(Pname,Args),Term):-
    generalisation_atom_no_follow_reverse_link(Pname,Pname_term),
    unstruct_generalisation_terms(Args,Args_term),
    Term=..[Pname_term|Args_term].

unstruct_generalisation_terms([],[]).
unstruct_generalisation_terms([Arg|Args],[Term|Terms]):-
    unstruct_generalisation_term(Arg,Term),
    unstruct_generalisation_terms(Args,Terms).

%TODO: clean up degen unstruct
degen_to_domain(Preanalogy,domain('',Normaldomain)):-
    arg(4,Preanalogy,Generalisation),
    degen_terms(Generalisation,Normaldomain).

degen_term(_:Var,Term):-
    var(Var),!,
    degen_atom(Var,Term).

degen_term(_:(Pname,Args),Sort:Term):-
    degen_atom_no_follow_reverse_link(Pname,Sort:Pname_term),
    degen_terms(Args,Args_term),
    Term=..[Pname_term|Args_term].

degen_terms([],[]).
degen_terms([Arg|Args],[Term|Terms]):-
    degen_term(Arg,Term),
    degen_terms(Args,Terms).


degen_atom_no_follow_reverse_link(Var,Sortname:Nameatom):-
    get_attr(Var,source_link,Svar),
    get_attr(Var,target_link,Tvar),
    name_atom_follow_flinks(Svar,Svarnameatom),
    name_atom_follow_flinks(Tvar,Tvarnameatom),
    get_sortname(Var,Sortname),
    (Svarnameatom==Tvarnameatom->
                                 Nameatom = Svarnameatom
                                ;
                                 get_attr(Var,name,Nameatom_old),
                                 atom_concat('General_',Nameatom_tmp,Nameatom_old),
                                 atom_concat('Input_G_',Nameatom_tmp,Nameatom)
    ).

degen_atom(Var,Sortname:Nameatom):-
    get_attr(Var,source_link,Svar),
    get_attr(Var,target_link,Tvar),
    reverse_link_atom(Svar,Svarnameatom),
    reverse_link_atom(Tvar,Tvarnameatom),
    get_sortname(Var,Sortname),
    (Svarnameatom==Tvarnameatom->
                                 Nameatom = Svarnameatom
                                ;
                                 get_attr(Var,name,Nameatom_old),
                                 atom_concat('General_',Nameatom_tmp,Nameatom_old),
                                 atom_concat('Input_G_',Nameatom_tmp,Nameatom)
    ).

generalisation_atom_no_follow_reverse_link(Var,Atom):-
    get_attr(Var,source_link,Svar),
    get_attr(Var,target_link,Tvar),
    name_atom_follow_flinks(Svar,Svarnameatom),
    name_atom_follow_flinks(Tvar,Tvarnameatom),
    sortpart_atom(Var,Sortatom),
    generalisation_atom(Svarnameatom,Tvarnameatom,Sortatom,Atom).


generalisation_casl_atom(Var,Atom):-
    get_attr(Var,source_link,Svar),
    get_attr(Var,target_link,Tvar),
    reverse_link_atom(Svar,Svarnameatom),
    reverse_link_atom(Tvar,Tvarnameatom),
    sortpart_atom(Var,Sortatom),
    term_to_atom(Var,Genvaratom),
    (var(Var)->atom_concat('G',Genvaratom,GGenvaratom)
               ;
               GGenvaratom=Genvaratom
    ),
    generalisation_casl_atom(Svarnameatom,Tvarnameatom,GGenvaratom,Sortatom,Atom).

generalisation_casl_atom(Svarnameatom,Tvarnameatom,Genatom,Sortatom,Atom):-
    (Svarnameatom==Tvarnameatom->         
        atomic_list_concat([Sortatom,Svarnameatom],Atom)
        ;
        atomic_list_concat([Sortatom,Genatom],Atom)
    ).


generalisation_atom(Var,Atom):-
    get_attr(Var,source_link,Svar),
    get_attr(Var,target_link,Tvar),
    reverse_link_atom(Svar,Svarnameatom),
    reverse_link_atom(Tvar,Tvarnameatom),
    sortpart_atom(Var,Sortatom),
    generalisation_atom(Svarnameatom,Tvarnameatom,Sortatom,Atom).

% adds sort information to strings of generalization   
generalisation_atom(Svarnameatom,Tvarnameatom,Sortatom,Atom):-
    (Svarnameatom==Tvarnameatom->         
        atomic_list_concat([Sortatom,Svarnameatom],Atom)
        ;
        atomic_list_concat([Sortatom,'{',Svarnameatom,'|',Tvarnameatom,'}'],Atom)
    ).
            
name_atom_follow_links(Var,Svarnameatom):-
    get_attr(Var,source_link,Svar),
    get_attr(Var,target_link,Tvar),
    name_atom_follow_flinks(Svar,Svarnameatom),
    name_atom_follow_flinks(Tvar,Tvarnameatom),
    Svarnameatom==Tvarnameatom,!.

name_atom_follow_links(Var,Name):-
    name_atom_follow_flinks(Var,Name).
        
name_atom_follow_flinks(Var,Name):-
    get_attr(Var,reverse_link,f_reverse(Var_new)),
    name_atom_follow_flinks(Var_new,Name),!.

name_atom_follow_flinks(Var,Name):-
    name_atom(Var,Name),!.    

casl_name_atom(Var,Name):-
    get_attr(Var,caslname,Name),!.

casl_name_atom(Var,Name):-
    name_atom(Var,Name).

name_atom(Var,Name):-
    get_attr(Var,name,Name),!.

name_atom(Var,Name):-
    term_to_atom(Var,Name).
    
name_atom_fol(Var,Name):-
    get_attr(Var,type,atomic),!,
    get_attr(Var,name,Name).

name_atom_fol(Var,Var).

%nameatom(Var,Name):-
%    unstruct_term_from_reverse_link(Var,Name).
    
get_sortname(Var,Sortname):-
    get_attr(Var,sort_link,SortVar),
    get_attr(SortVar,name,Sortname).

sortpart_atom(Var,Atom):-
    get_sortname(Var,Sortname),
    (Sortname==none->
                     Atom=''
                    ;
                     atomic_list_concat([Sortname,':'],Atom)
    ).

term_atom(Var,Atom):-
    name_atom(Var,Nameatom),
    sortpart_atom(Var,Sortatom),
    atomic_list_concat([Sortatom,Nameatom],Atom).
     
reverse_link_atom(Var,Atom):-
    undo_subst(_:Var,Term),
    unstruct_term_name(Term,Term_new),
    term_to_atom(Term_new,Atom).

unstruct_quantifier([],Term,Term).

unstruct_quantifier([(Quantor,Variable)|Rest],Term,Quantifier:QTerm):-
    Quantifier=..[Quantor,Variable],
    unstruct_quantifier(Rest,Term,QTerm).

filter_symbol_mappings([],[]).
filter_symbol_mappings([Mapping|Mappings],[Mapping|MappingsRet]):-
    functor(Mapping,mapping,5),!,
    filter_symbol_mappings(Mappings,MappingsRet).

filter_symbol_mappings([_Mapping|Mappings],MappingsRet):-
    filter_symbol_mappings(Mappings,MappingsRet).


extract_variable_mappings([],[]).
extract_variable_mappings([Var|Vars],[mapping(Svar,Var,Tvar)|Mappings]):-
    get_attr(Var,source_link,Svar),
    get_attr(Var,target_link,Tvar),
    not(get_attr(Svar,reverse_link,_)),
    not(get_attr(Tvar,reverse_link,_)),!,
    extract_variable_mappings(Vars,Mappings).    

extract_variable_mappings([_|Vars],Mappings):-
    extract_variable_mappings(Vars,Mappings).    

extract_mappings([],[]).

extract_mappings([Var|Vars],Mappings):-
    get_attr(Var,source_link,Svar),
    get_attr(Var,target_link,Tvar),
    get_attr(Svar,reverse_link,f_reverse(Svarf)),
    get_attr(Svarf,sig,'$casl_symbol'),
    get_attr(Tvar,reverse_link,f_reverse(Tvarf)),
    get_attr(Tvarf,sig,'$casl_symbol'),!,
    extract_mappings(Vars,Mappings).


extract_mappings([Var|Vars],[mapping(Svarnameatom,Svarf,Var,Tvarf,Tvarnameatom)|Mappings]):-
    get_attr(Var,source_link,Svar),
    get_attr(Var,target_link,Tvar),
    get_attr(Svar,reverse_link,f_reverse(Svarf)),
    casl_name_atom(Svarf,Svarnameatom),
    get_attr(Tvar,reverse_link,f_reverse(Tvarf)),
    casl_name_atom(Tvarf,Tvarnameatom),!,
    extract_mappings(Vars,Mappings).

extract_mappings([Var|Vars],[mapping(Svar,Var,Tvar)|Mappings]):-
    get_attr(Var,source_link,Svar),
    get_attr(Var,target_link,Tvar),
    not(get_attr(Svar,reverse_link,_)),
    not(get_attr(Tvar,reverse_link,_)),
    extract_mappings(Vars,Mappings).