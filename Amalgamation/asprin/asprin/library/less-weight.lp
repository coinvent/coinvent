#program preference.

preferred(P) :- preference(P,less(weight)), required(P,preferred),
                #sum { W,T :     holds(X),  preference(P,_,_,lit(t,X),(W,T)); 
                       W,T : not holds(X),  preference(P,_,_,lit(f,X),(W,T)); 
                      -W,T :     holds'(X), preference(P,_,_,lit(t,X),(W,T)); 
		      -W,T : not holds'(X), preference(P,_,_,lit(f,X),(W,T))} -1.

preferredeq(P) :- preference(P,less(weight)), required(P,preferredeq),
                  #sum { W,T :     holds(X),  preference(P,_,_,lit(t,X),(W,T)); 
                         W,T : not holds(X),  preference(P,_,_,lit(f,X),(W,T)); 
                        -W,T :     holds'(X), preference(P,_,_,lit(t,X),(W,T)); 
                        -W,T : not holds'(X), preference(P,_,_,lit(f,X),(W,T))}0.

eq(P) :- preference(P,less(weight)), required(P,eq),
         0 #sum { W,T :     holds(X),  preference(P,_,_,lit(t,X),(W,T)); 
                  W,T : not holds(X),  preference(P,_,_,lit(f,X),(W,T)); 
                 -W,T :     holds'(X), preference(P,_,_,lit(t,X),(W,T)); 
                 -W,T : not holds'(X), preference(P,_,_,lit(f,X),(W,T))} 0.

worseeq(P) :- preference(P,less(weight)), required(P,worseeq),
              0 #sum { W,T :     holds(X),  preference(P,_,_,lit(t,X),(W,T)); 
                       W,T : not holds(X),  preference(P,_,_,lit(f,X),(W,T)); 
                      -W,T :     holds'(X), preference(P,_,_,lit(t,X),(W,T)); 
                      -W,T : not holds'(X), preference(P,_,_,lit(f,X),(W,T))}.
 
worse(P) :- preference(P,less(weight)), required(P,worse),
            1 #sum { W,T :     holds(X),  preference(P,_,_,lit(t,X),(W,T)); 
                     W,T : not holds(X),  preference(P,_,_,lit(f,X),(W,T)); 
                    -W,T :     holds'(X), preference(P,_,_,lit(t,X),(W,T)); 
		    -W,T : not holds'(X), preference(P,_,_,lit(f,X),(W,T))}.

%
% _heuristic
%

modifier_pos(P,t,false)  :- preference(P,less(weight)), required(P,preferred), _h == on. 
modifier_pos(P,f,true)   :- preference(P,less(weight)), required(P,preferred), _h == on. 
modifier_zero(P,t,level) :- preference(P,less(weight)), required(P,preferred), _h == on. 
modifier_zero(P,f,level) :- preference(P,less(weight)), required(P,preferred), _h == on. 
modifier_neg(P,t,true)   :- preference(P,less(weight)), required(P,preferred), _h == on. 
modifier_neg(P,f,false)  :- preference(P,less(weight)), required(P,preferred), _h == on. 

_heuristic(X,M,1)   :- preference(P,less(weight)), required(P,preferred), _h == on, 
                       preference(P,_,_,lit(S,X),(W,T)), modifier_pos(P,S,M), W > 0.
_heuristic(X,M,1)   :- preference(P,less(weight)), required(P,preferred), _h == on, 
                       preference(P,_,_,lit(S,X),(W,T)), modifier_zero(P,S,M), W = 0.
_heuristic(X,M,1)   :- preference(P,less(weight)), required(P,preferred), _h == on, 
                       preference(P,_,_,lit(S,X),(W,T)), modifier_neg(P,S,M), W < 0.


% UNCOMMENT WHEN TOBIAS FIXES THE PARSER!
% AND ADD HERE A SHOW OF THE HEURISTIC!
%#show X : preference(P,less(weight)), required(P,preferred), _h == on, 
%          preference(P,_,_,lit(S,X),(W,T)).

