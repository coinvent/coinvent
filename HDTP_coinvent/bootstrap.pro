%check for swi prolog and sufficient version number
:- expects_dialect(swi).
:- current_prolog_flag(version,Versionnumber),hdtp_swi_min_version(Neededversion),(Versionnumber>=Neededversion;(print('Need at least SWI-Prolog version '),print(Neededversion),nl,halt)).

%define fileending .pro as prolog source files 
%so we can use import(filename) and prolog will source filename.pro if it exists
prolog_file_type(pro,prolog). 

% make hdtp as filepathshortcut available so we can use hdtp(dir) to refer to hdtppath/dir
:- prolog_load_context(directory,Dir),asserta(user:file_search_path(hdtp, Dir)). 

% define init as hdtppath/init/ so we can use init(dir) to refer to hdtppath/init/dir
file_search_path(init,hdtp(init)).
