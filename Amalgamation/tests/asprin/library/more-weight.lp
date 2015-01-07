#program preference.

preferred(P) :- preference(P,more(weight)), required(P,preferred),
                1 #sum { W,T :     holds(X),  preference(P,_,_,lit(t,X),(W,T)); 
                         W,T : not holds(X),  preference(P,_,_,lit(f,X),(W,T)); 
                        -W,T :     holds'(X), preference(P,_,_,lit(t,X),(W,T)); 
                        -W,T : not holds'(X), preference(P,_,_,lit(f,X),(W,T))}.

preferredeq(P) :- preference(P,more(weight)), required(P,preferredeq),
                  0 #sum { W,T :     holds(X),  preference(P,_,_,lit(t,X),(W,T)); 
                           W,T : not holds(X),  preference(P,_,_,lit(f,X),(W,T)); 
                          -W,T :     holds'(X), preference(P,_,_,lit(t,X),(W,T)); 
                          -W,T : not holds'(X), preference(P,_,_,lit(f,X),(W,T))}.

eq(P) :- preference(P,more(weight)), required(P,eq),
         0 #sum { W,T :     holds(X),  preference(P,_,_,lit(t,X),(W,T)); 
                  W,T : not holds(X),  preference(P,_,_,lit(f,X),(W,T)); 
                 -W,T :     holds'(X), preference(P,_,_,lit(t,X),(W,T)); 
                 -W,T : not holds'(X), preference(P,_,_,lit(f,X),(W,T))} 0.

worseeq(P) :- preference(P,more(weight)), required(P,worseeq),
              #sum { W,T :     holds(X),  preference(P,_,_,lit(t,X),(W,T)); 
                     W,T : not holds(X),  preference(P,_,_,lit(f,X),(W,T)); 
                    -W,T :     holds'(X), preference(P,_,_,lit(t,X),(W,T)); 
                    -W,T : not holds'(X), preference(P,_,_,lit(f,X),(W,T))} 0.

worse(P) :- preference(P,more(weight)), required(P,worse),
            #sum { W,T :     holds(X),  preference(P,_,_,lit(t,X),(W,T)); 
                   W,T : not holds(X),  preference(P,_,_,lit(f,X),(W,T)); 
                  -W,T :     holds'(X), preference(P,_,_,lit(t,X),(W,T)); 
		  -W,T : not holds'(X), preference(P,_,_,lit(f,X),(W,T))} -1.

%
% _heuristic
%

modifier_pos(P,t,true)   :- preference(P,more(weight)), required(P,preferred), _h == on. 
modifier_pos(P,f,false)  :- preference(P,more(weight)), required(P,preferred), _h == on. 
modifier_zero(P,t,level) :- preference(P,more(weight)), required(P,preferred), _h == on. 
modifier_zero(P,f,level) :- preference(P,more(weight)), required(P,preferred), _h == on. 
modifier_neg(P,t,false)  :- preference(P,more(weight)), required(P,preferred), _h == on. 
modifier_neg(P,f,true)   :- preference(P,more(weight)), required(P,preferred), _h == on. 

_heuristic(X,M,1)   :- preference(P,more(weight)), required(P,preferred), _h == on, 
                       preference(P,_,_,lit(S,X),(W,T)), modifier_pos(P,S,M), W > 0.
_heuristic(X,M,1)   :- preference(P,more(weight)), required(P,preferred), _h == on, 
                       preference(P,_,_,lit(S,X),(W,T)), modifier_zero(P,S,M), W = 0.
_heuristic(X,M,1)   :- preference(P,more(weight)), required(P,preferred), _h == on, 
                       preference(P,_,_,lit(S,X),(W,T)), modifier_neg(P,S,M), W < 0.
	       
