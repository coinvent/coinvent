#program preference.

preferred(P) :- preference(P,superset); required(P,preferred); 
                holds(X) : preference(P,_,_,lit(t,X),_), holds'(X);
                not holds(X) : preference(P,_,_,lit(f,X),_), not holds'(X);
                1 #sum { 1 : holds(X), not holds'(X), preference(P,_,_,lit(t,X),_);
                         1 : not holds(X), holds'(X), preference(P,_,_,lit(f,X),_)}.

preferredeq(P) :- preference(P,superset); required(P,preferredeq); 
                  holds(X) : preference(P,_,_,lit(t,X),_), holds'(X);
                  not holds(X) : preference(P,_,_,lit(f,X),_), not holds'(X).

required(P,preferredeq) :- preference(P,superset); required(P,eq). 
required(P,worseeq)     :- preference(P,superset); required(P,eq). 
eq(P) :- preference(P,superset); required(P,eq); 
         preferredeq(P); worseeq(P).

worseeq(P) :- preference(P,superset); required(P,worseeq); 
              holds'(X) : preference(P,_,_,lit(t,X),_), holds(X);
              not holds'(X) : preference(P,_,_,lit(f,X),_), not holds(X).

required(P,preferredeq) :- preference(P,superset); required(P,worse). 
required(P,worseeq)     :- preference(P,superset); required(P,worse). 
worse(P) :- preference(P,superset); required(P,worse); 
            not preferredeq(P); worseeq(P).

required(P,preferredeq) :- preference(P,superset); required(P,unc). 
required(P,worseeq)     :- preference(P,superset); required(P,unc). 
unc(P) :- preference(P,superset); required(P,unc); 
          not preferredeq(P); not worseeq(P).

