:- module(mapping,[mapping_cont/2]).

user:file_search_path(mapping,modules(mapping)).

:- consult(mapping(main)).