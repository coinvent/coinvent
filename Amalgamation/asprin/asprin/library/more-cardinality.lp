#program preference.

preferred(P) :- preference(P,more(cardinality)), required(P,preferred),
                #sum { -1,X   :     holds(X),  preference(P,_,_,lit(t,X),()); 
                       -1,X   : not holds(X),  preference(P,_,_,lit(f,X),()); 
                        1,X   :     holds'(X), preference(P,_,_,lit(t,X),()); 
                        1,X   : not holds'(X), preference(P,_,_,lit(f,X),())} -1.

preferredeq(P) :- preference(P,more(cardinality)), required(P,preferredeq),
                  #sum { -1,X   :     holds(X),  preference(P,_,_,lit(t,X),()); 
                         -1,X   : not holds(X),  preference(P,_,_,lit(f,X),()); 
                          1,X   :     holds'(X), preference(P,_,_,lit(t,X),()); 
                          1,X   : not holds'(X), preference(P,_,_,lit(f,X),())} 0.

eq(P) :- preference(P,more(cardinality)), required(P,eq),
         0 #sum { -1,X   :     holds(X),  preference(P,_,_,lit(t,X),()); 
                  -1,X   : not holds(X),  preference(P,_,_,lit(f,X),()); 
                   1,X   :     holds'(X), preference(P,_,_,lit(t,X),()); 
                   1,X   : not holds'(X), preference(P,_,_,lit(f,X),())} 0.

worseeq(P) :- preference(P,more(cardinality)), required(P,worseeq),
              0 #sum { -1,X   :     holds(X),  preference(P,_,_,lit(t,X),()); 
                       -1,X   : not holds(X),  preference(P,_,_,lit(f,X),()); 
                        1,X   :     holds'(X), preference(P,_,_,lit(t,X),()); 
                        1,X   : not holds'(X), preference(P,_,_,lit(f,X),())}.

worse(P) :- preference(P,more(cardinality)), required(P,worse),
            1 #sum { -1,X   :     holds(X),  preference(P,_,_,lit(t,X),()); 
                     -1,X   : not holds(X),  preference(P,_,_,lit(f,X),()); 
                      1,X   :     holds'(X), preference(P,_,_,lit(t,X),()); 
                      1,X   : not holds'(X), preference(P,_,_,lit(f,X),())}.

%
% _heuristic
%

modifier(P,t,true)  :- preference(P,more(cardinality)), required(P,preferred), _h == on. 
modifier(P,f,false) :- preference(P,more(cardinality)), required(P,preferred), _h == on. 
_heuristic(X,M,1)   :- preference(P,more(cardinality)), required(P,preferred), _h == on, 
                       preference(P,_,_,lit(S,X),()), modifier(P,S,M).
     
