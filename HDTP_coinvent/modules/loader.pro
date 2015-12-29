:- module(loader,[load_analogy/2,
                  load_subst/2,
                  load_sorts/2]).

user:file_search_path(subst    ,hdtp(substitutions)).
user:file_search_path(analogies,hdtp(analogies)).
user:file_search_path(sorts    ,hdtp(sorts)).

% reads prologterm from file
load_file(Filename,Data):-
     absolute_file_name(Filename,Filepath),
     open(Filepath,read,Stream),
     read(Stream,Data_in),
     (Data_in=Data;throw('malformed input':Filepath)),!,
     close(Stream).

load_analogy(Name,Analogy):-
     atom_concat(Name,'.analogy',Filename),
     load_file(analogies(Filename),Analogy).

load_subst(Name,SubstitutionSettings):-
     atom_concat(Name,'.subst',Filename),
     catch(load_file(subst(Filename),SubstitutionSettings),
           _,
           SubstitutionSettings=subst([])).

load_sorts(Name,SortSettings):-
     atom_concat(Name,'.sorts',Filename),
     catch(load_file(sorts(Filename),SortSettings),
           _,
           SortSettings=sorts([])).