% print option/flags we set and then insert the goal to predicate that sets them (set_prolog_flag)
:- assert(goal_expansion(set_prolog_flag_and_print(Flag,Value),
                                   set_prolog_flag(Flag,Value))).


            % dont remove enclosing parenthesis because this will replace the original goal 
%            (context_module(Module),
%                %add namespace if namespace of option/flag set is not 'user' 
%                (Module='user'-> 
%                                 print(Flag)
%                                ;
%                                 print(Module:Flag)
%                ),
%                print(' -> '),print(Value),nl)
%            ).