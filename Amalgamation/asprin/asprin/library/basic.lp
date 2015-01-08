#program preference.
required(P,preferred) :- optimize(P).
:- not preferred(P),  optimize(P).

