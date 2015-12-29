%-------------------------------------------------------------------------------
% embedding
%-------------------------------------------------------------------------------

% unpack 
term_embedding_new(anti(C,(_,s(F,I,E,P)),Term),anti(C_new,(e(Place_new),s(F_new,I,E_new,P)),Term_new)) :-
	uembedding(C,C_new,Term,Term_new,16777215,Place_new,E,E_new,F,F_new).

term_embedding(anti(C,(e(Place),s(F,I,E,P)),Term),anti(C_new,(e(Place_new),s(F_new,I,E_new,P)),Term_new)) :-
	uembedding(C,C_new,Term,Term_new,Place,Place_new,E,E_new,F,F_new).

uembedding(_C,_C_new,A:Var,_,Place,_Place_new,_E,_E_new,_F,_F_new):-
    (
        get_attr(A,place,Place_tmp),
        Place_tmp >= Place
    ;
        var(Var)
    ),
    !,fail.

% recursion on predicate arguments
uembedding(C,C_new,A:(Pname,Args),A:(Pname,Args_new),Place,Place_new,E,E_new,F,F_new) :-   
    append(Args_before,[Arg|Args_after],Args),
	uembedding(C,C_new,Arg,Arg_new,Place,Place_new,E,E_new,F,F_new),   
    append(Args_before,[Arg_new|Args_after],Args_new).

uembedding(_C,_C_new,_A:(Pname,_Args),_,_Place,_Place_new,_E,_E_new,_F,_F_new):-
    get_attr(Pname,mode_e,denied),!,fail.
	
% embedding a function variable with arity >= 1. consuming arity many arguments
uembedding(C,C_new,A:(Pname,Args),A:(Pname_new,Args_new),Place,Place_new,E,E_new,F,F_new) :-
    %not(get_attr(Pname,atomic,_)),
	append(Args_before,[Aarg:Pred|Args_after],Args),
	nonvar(Pred),Pred = (ArgPname,List),
	%not(get_attr(ArgPname,atomic,_)),
	get_attr(Aarg,place,Place_new),
	(Place_new < Place->true;!,fail),
	append(Args_before,List      ,Args_temp),
	append(Args_temp  ,Args_after,Args_new ),
	length(Args_before,PlaceOfArg),
	make_pname_variable(C,C_tmp,ArgPname,ArgPname_var,F,F_tmp),
	(get_attr(Pname,mode_e,keep)->
	                              set_pname_embedding_keep(C_tmp,C_new,ArgPname_var,List,Pname,Pname_new,PlaceOfArg,E,E_new),
	                              F_new=F
	                             ;
	                              make_pname_variable(C_tmp,C_tmp2,Pname,Pname_var,F_tmp,F_new),
	                              set_pname_embedding(C_tmp2,C_new,ArgPname_var,List,Pname_var,Pname_new,PlaceOfArg,E,E_new) 
    ).	
	
%OPT: use ordering in subst_e
set_pname_embedding(C,C,EmbeddingPred,_,Pname,Pname_new,PlaceOfArg,E,E) :-
    get_attr(Pname,subst_e,SubstE),
    embedding_global_subst_member(e(Pname_new,PlaceOfArg,EmbeddingPred),SubstE),!.
	
set_pname_embedding(C,C,EmbeddingPred,_,Pname,Pname_new,PlaceOfArg,E,E) :-
    embedding_local_subst_member(e(Pname,Pname_new,PlaceOfArg,EmbeddingPred),E),!.
	
set_pname_embedding(C,C_new,EmbeddingPred,List,Pname,Pname_new,PlaceOfArg,E,[e(Pname,Pname_new,PlaceOfArg,EmbeddingPred,Length)|E]) :-
    copy_attribute(sort_link,Pname,Pname_new),
    length(List,Length),
    (get_attr(Pname,cost_e,free)->C_new=C;cost_embedding_new(C,C_new,EmbeddingPred,List,Length,Pname,Pname_new,PlaceOfArg)).

set_pname_embedding_keep(C,C_new,EmbeddingPred,List,Pname,Pname_new,PlaceOfArg,E,[e(Pname,Pname_new,PlaceOfArg,EmbeddingPred,Length)|E]) :-
    copy_for_keepmode(Pname,Pname_new),
    length(List,Length),
    (get_attr(Pname,cost_e,free)->C_new=C;cost_embedding_new(C,C_new,EmbeddingPred,List,Length,Pname,Pname_new,PlaceOfArg)).


%dont have to check for length because of unique name assumption
embedding_local_subst_member(e(Pname,Pname_new,PlaceOfArg,Embedding),[e(EPname,Pname_new,PlaceOfArg,EEmbedding,_Length)|_]) :-
    Pname==EPname,
    Embedding==EEmbedding,!. 
    
embedding_local_subst_member(Match,[_|Rest]):-
    embedding_local_subst_member(Match,Rest).    

%dont have to check for length because of unique name assumption
embedding_global_subst_member(e(Pname_new,PlaceOfArg,Embedding),[e(Pname_new,PlaceOfArg,SubstEmbedding)|_]) :-
    Embedding==SubstEmbedding,!. 
    
embedding_global_subst_member(Match,[_|Rest]):-
    embedding_global_subst_member(Match,Rest).    

