#program preference.

preferred(P) :- preference(P,subset); required(P,preferred); 
                not holds(X) : preference(P,_,_,lit(t,X),_), not holds'(X);
                holds(X) : preference(P,_,_,lit(f,X),_), holds'(X);
                1 #sum { 1 : not holds(X), holds'(X), preference(P,_,_,lit(t,X),_);
                         1 : holds(X), not holds'(X), preference(P,_,_,lit(f,X),_)}.

preferredeq(P) :- preference(P,subset); required(P,preferredeq); 
                  not holds(X) : preference(P,_,_,lit(t,X),_), not holds'(X);
                  holds(X) : preference(P,_,_,lit(f,X),_), holds'(X).

required(P,preferredeq) :- preference(P,subset); required(P,eq). 
required(P,worseeq)     :- preference(P,subset); required(P,eq). 
eq(P) :- preference(P,subset); required(P,eq); 
         preferredeq(P); worseeq(P).

worseeq(P) :- preference(P,subset); required(P,worseeq); 
              not holds'(X) : preference(P,_,_,lit(t,X),_), not holds(X);
              holds'(X) : preference(P,_,_,lit(f,X),_), holds(X).

required(P,preferredeq) :- preference(P,subset); required(P,worse). 
required(P,worseeq)     :- preference(P,subset); required(P,worse). 
worse(P) :- preference(P,subset); required(P,worse); 
            not preferredeq(P); worseeq(P).

required(P,preferredeq) :- preference(P,subset); required(P,unc). 
required(P,worseeq)     :- preference(P,subset); required(P,unc). 
unc(P) :- preference(P,subset); required(P,unc); 
          not preferredeq(P); not worseeq(P).

