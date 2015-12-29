:- module(sorts,[sorts_preload/2,
                 lca_sorts/3]).

sorts_preload('',_Sorts):-!.

sorts_preload(DomainName,Sorts):-
    load_sorts(DomainName,sorts(Ontologies)),
    sorts_link(Ontologies,none,Sorts,_Sorts_new).
    
sort_link(Ontology,ParentSortVar,Sorts,Sorts_new):-
    Ontology=..[Sort|Ontologies],
    build_sort_Variable(Sort,SortVar,Sorts,Sorts_tmp),
    (var(ParentSortVar)->put_attr(SortVar,parent_link,ParentSortVar);true),
    sorts_link(Ontologies,SortVar,Sorts_tmp,Sorts_new).

sorts_link([],_,Sorts,Sorts).

sorts_link([Ontology|Os],ParentSortVar,Sorts,Sorts_new):-
    sort_link(Ontology,ParentSortVar,Sorts,Sorts_tmp),
    sorts_link(Os,ParentSortVar,Sorts_tmp,Sorts_new).

lca_sorts(S_SortVar,T_SortVar,Sort_Name):-
    (
     (get_attr(S_SortVar,name,'nomap'),get_attr(T_SortVar,name,Sort_Name))
    ;
     (get_attr(T_SortVar,name,'nomap'),get_attr(S_SortVar,name,Sort_Name))
    ),!.


%TODO make faster version
%precompute ancestors, markwith distance, make sets, join sets
lca_sorts(S_SortVar,T_SortVar,Ancestor_Sort_Name):-
    bagof(Ancestor,ancestor(S_SortVar,Ancestor),S_Ancestors),
    bagof(Ancestor,ancestor(T_SortVar,Ancestor),T_Ancestors),
    member(S_Ancestor,S_Ancestors),
    get_attr(S_Ancestor,name,Ancestor_Sort_Name),
    member(T_Ancestor,T_Ancestors),
    get_attr(T_Ancestor,name,Ancestor_Sort_Name),!.

ancestor(SortVar,SortVar).

ancestor(SortVar,Ancestor):-
    get_attr(SortVar,parent_link,ParentSortVar),
    ancestor(ParentSortVar,Ancestor).