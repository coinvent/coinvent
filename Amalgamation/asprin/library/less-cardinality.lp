#program preference.

preferred(P) :- preference(P,less(cardinality)), required(P,preferred),
                1 #sum { -1,X   :     holds(X),  preference(P,_,_,lit(t,X),()); 
                         -1,X   : not holds(X),  preference(P,_,_,lit(f,X),()); 
                          1,X   :     holds'(X), preference(P,_,_,lit(t,X),()); 
                          1,X   : not holds'(X), preference(P,_,_,lit(f,X),())}.

preferredeq(P) :- preference(P,less(cardinality)), required(P,preferredeq),
                  0 #sum { -1,X   :     holds(X),  preference(P,_,_,lit(t,X),()); 
                           -1,X   : not holds(X),  preference(P,_,_,lit(f,X),()); 
                            1,X   :     holds'(X), preference(P,_,_,lit(t,X),()); 
                            1,X   : not holds'(X), preference(P,_,_,lit(f,X),())}.

eq(P) :- preference(P,less(cardinality)), required(P,eq),
         0 #sum { -1,X   :     holds(X),  preference(P,_,_,lit(t,X),()); 
                  -1,X   : not holds(X),  preference(P,_,_,lit(f,X),()); 
                   1,X   :     holds'(X), preference(P,_,_,lit(t,X),()); 
                   1,X   : not holds'(X), preference(P,_,_,lit(f,X),())} 0.

worseeq(P) :- preference(P,less(cardinality)), required(P,worseeq),
              #sum { -1,X   :     holds(X),  preference(P,_,_,lit(t,X),()); 
                     -1,X   : not holds(X),  preference(P,_,_,lit(f,X),()); 
                      1,X   :     holds'(X), preference(P,_,_,lit(t,X),()); 
                      1,X   : not holds'(X), preference(P,_,_,lit(f,X),())} 0.

worse(P) :- preference(P,less(cardinality)), required(P,worse),
            #sum { -1,X   :     holds(X),  preference(P,_,_,lit(t,X),()); 
                   -1,X   : not holds(X),  preference(P,_,_,lit(f,X),()); 
                    1,X   :     holds'(X), preference(P,_,_,lit(t,X),()); 
                    1,X   : not holds'(X), preference(P,_,_,lit(f,X),())} -1.


%
% _heuristic
%

modifier(P,t,false) :- preference(P,less(cardinality)), required(P,preferred), _h == on. 
modifier(P,f,true)  :- preference(P,less(cardinality)), required(P,preferred), _h == on. 
_heuristic(X,M,1)   :- preference(P,less(cardinality)), required(P,preferred), _h == on, 
                       preference(P,_,_,lit(S,X),_), modifier(P,S,M).

