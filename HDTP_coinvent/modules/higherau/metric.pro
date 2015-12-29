% defines costs for operations on terms

cost_permutation_new(C,C_new,_Permutation,_Pname,_Pname_new):-
    succ(C,C_new).
    

cost_insertion_new(C,C_new,_Insertion,_Pname,_Pname_new,_PlaceOfArg):-
    succ(C,C_new).
        
cost_embedding_new(C,C_new,_EmbeddingPred,_List,Length,_Pname,_Pname_new,_PlaceOfArg):-
    plus(C,Length,C_tmp),
    succ(C_tmp,C_new).

cost_fixation_new(C,C_new,_Pname,_Pname_new):-
    succ(C,C_new).

    