% set swi-prolog environment flags in non debug mode

% max_depth(0) -> print full term (no ...)
% attributes(ignore) -> do not print variable attributes  

% at querieprompt
:-set_prolog_flag_and_print(toplevel_print_options,[quoted(true), portray(true), max_depth(0), attributes(ignore)]).

% at debugprompt
:-set_prolog_flag_and_print(debugger_print_options,[quoted(true), portray(true), max_depth(0), attributes(ignore)]).

% allow upper case letters as functor names
:-set_prolog_flag_and_print(allow_variable_name_as_functor,true).

% let "hello world" be a string and not a list of characters
:-set_prolog_flag_and_print(double_quotes,string).

% dont print bindings of variables beginning with underscore in queries 
:-set_prolog_flag_and_print(toplevel_print_anon,false).

% make code faster where possibe
%:-set_prolog_flag_and_print(optimise,true).