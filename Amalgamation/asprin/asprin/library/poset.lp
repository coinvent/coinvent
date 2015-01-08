#program preference.

%
% qualitative preferences
%

required(P)       :- preference(P,poset), required(P,_).
required(P,noteq) :- preference(P,poset), required(P,X), X != eq.

preference(P,lit(SX,X)) :- preference(P,poset), required(P),
                           preference(P,I,1,lit(SX,X),_), not preference(P,I,2,_,_).
preference(P,lit(SX,X),lit(SY,Y)) :- preference(P,poset), required(P,noteq),
                                     preference(P,I,1,lit(SX,X),_), preference(P,I,2,lit(SY,Y),_).

% transitive closure
preference(P,lit(SX,X),lit(SY,Y)) :- preference(P,poset), required(P,noteq),
                                     preference(P,lit(SX,X),lit(SZ,Z)), 
                                     preference(P,lit(SZ,Z),lit(SY,Y)).

% preferred

better(P,lit(t,X)) :- preference(P,poset), required(P,preferred), 
                      preference(P,lit(t,X)), holds(X), not holds'(X).

better(P,lit(f,X)) :- preference(P,poset), required(P,preferred),
                      preference(P,lit(f,X)), not holds(X), holds'(X).

notbetter(P) :- preference(P,poset), required(P,preferred),
                preference(P,lit(t,X)), not holds(X), holds'(X),
                not better(P,lit(SY,Y)) : preference(P,lit(SY,Y),lit(t,X)).

notbetter(P) :- preference(P,poset), required(P,preferred),
                preference(P,lit(f,X)), holds(X), not holds'(X),
                not better(P,lit(SY,Y)) : preference(P,lit(SY,Y),lit(f,X)).

preferred(P) :- preference(P,poset), required(P,preferred),
                1 #sum { 1: better(P,lit(SX,X)) }, not notbetter(P).

% preferredeq
required(P,eq)        :- preference(P,poset), required(P,preferredeq).
required(P,preferred) :- preference(P,poset), required(P,preferredeq).
preferredeq(P)  :- preference(P,poset), required(P,preferredeq),
                   1 #sum { eq(P), preferred(P) }.

% eq
eq(P) :- preference(P,poset), required(P,eq),
         holds(X) : preference(P,lit(_,X)), holds'(X);
         not holds(X) : preference(P,lit(_,X)), not holds'(X).


% worseeq
required(P,eq)    :- preference(P,poset), required(P,worseeq).
required(P,worse) :- preference(P,poset), required(P,worseeq).
worseeq(P)  :- preference(P,poset), required(P,worseeq),
               1 #sum { eq(P), worse(P) }.


% worse
worse(P,lit(t,X)) :- preference(P,poset), required(P,worse),
                     preference(P,lit(t,X)), holds'(X), not holds(X).

worse(P,lit(f,X)) :- preference(P,poset), required(P,worse),
                     preference(P,lit(f,X)), not holds'(X), holds(X).

notworse(P) :- preference(P,poset), required(P,worse),
               preference(P,lit(t,X)), not holds'(X), holds(X),
		       not worse(P,lit(SY,Y)) : preference(P,lit(SY,Y),lit(t,X)).

notworse(P) :- preference(P,poset), required(P,worse),
               preference(P,lit(f,X)), holds'(X), not holds(X),
		       not worse(P,lit(SY,Y)) : preference(P,lit(SY,Y),lit(f,X)).
											
worse(P) :- preference(P,poset), required(P,worse),
            1 #sum { 1: worse(P,lit(SX,X)) }, not notworse(P).

% unc
required(P,preferredeq) :- preference(P,poset), required(P,unc).
required(P,worseeq)     :- preference(P,poset), required(P,unc).
unc(P) :- preference(P,poset), required(P,unc),
          not preferredeq(P), not worseeq(P).
      
