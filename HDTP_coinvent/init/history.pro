user:file_search_path(session,hdtp(session)).

init_history :-
    absolute_file_name(session('inputrc'),ReadlineInitFile),
    rl_read_init_file(ReadlineInitFile),
    absolute_file_name(session('history'),HistoryFile),
    % try to read existing history
    ignore((rl_read_history(HistoryFile),print('loading history from '),print(HistoryFile),nl)),
    % make hook to save history on exit of prolog session
    at_halt((rl_write_history(HistoryFile),print('written history to '),print(HistoryFile),nl)). 

% activates session indepedent history if readline support is available 
%:- (current_prolog_flag(readline,true) -> 
%        print('readline support is true'),nl,
%        print('history support -> enabled'),nl,
%        init_history
%    ;
%        print('readline support is false'),nl,
%        print('history support -> disabled'),nl
%   ).