#program preference.
required(P,preferred) :- optimize(P).
:- not preferred(P),  optimize(P).



#program preference.

required(Q,preferred) :- preference(P,and), required(P,preferred), preference(P,_,_,name(Q),_).
preferred(P) :- preference(P,and), required(P,preferred); 
	            preferred(Q) : preference(P,_,_,name(Q),_).
            
required(P,preferred) :- preference(P,and), required(P,preferredeq). 
required(P,eq)        :- preference(P,and), required(P,preferredeq). 
preferredeq(P) :- preference(P,and), required(P,preferredeq),
                  1 #sum { 1: preferred(P); 1: eq(P) }.

required(Q,eq) :- preference(P,and), required(P,eq), preference(P,_,_,name(Q),_).
eq(P) :- preference(P,and), required(P,eq); 
	     eq(Q) : preference(P,_,_,name(Q),_).

required(P,worse) :- preference(P,and), required(P,worseeq). 
required(P,eq)    :- preference(P,and), required(P,worseeq). 
worseeq(P) :- preference(P,and), required(P,worseeq),
              1 #sum { 1: worse(P); 1: eq(P) }.

required(Q,worse) :- preference(P,and), required(P,worse), preference(P,_,_,name(Q),_).
worse(P) :- preference(P,and), required(P,worse); 
	        worse(Q) : preference(P,_,_,name(Q),_).

required(P,preferredeq) :- preference(P,and), required(P,unc). 
required(P,worseeq)     :- preference(P,and), required(P,unc). 
unc(P) :- preference(P,and); required(P,unc); 
          not preferredeq(P); not worseeq(P).



#program preference.

required(P,aso) :- preference(P,aso), required(P,_).
preference(P,aso,Id) :- preference(P,aso), required(P,aso), preference(P,Id,_,_,_).

nohead(P,Id) :- preference(P,aso,Id), 
                not holds(X) : preference(P,Id,H,lit(t,X),_), H!=0;
                holds(X)     : preference(P,Id,H,lit(f,X),_), H!=0.

nohead'(P,Id) :- preference(P,aso,Id), 
                 not holds'(X) : preference(P,Id,H,lit(t,X),_), H!=0;
                 holds'(X)     : preference(P,Id,H,lit(f,X),_), H!=0.

value'(P,Id,V) :- preference(P,aso,Id),
                  V = #min { 1   : not holds'(X), preference(P,Id,0,lit(t,X),_);
                             1   : holds'(X), preference(P,Id,0,lit(f,X),_);
                             1   : nohead'(P,Id);
                             Pos : holds'(X), preference(P,Id,Pos,lit(t,X),_), Pos != 0;
                             Pos : not holds'(X), preference(P,Id,Pos,lit(f,X),_), Pos != 0}.
 
preferred(P,Id) :- preference(P,aso,Id), value'(P,Id,V), required(P,aso,preferred), 
                   V > #min { 1   : not holds(X), preference(P,Id,0,lit(t,X),_);
                              1   : holds(X), preference(P,Id,0,lit(f,X),_);
                              1   : nohead(P,Id);
                              Pos : holds(X), preference(P,Id,Pos,lit(t,X),_), Pos != 0;
                              Pos : not holds(X), preference(P,Id,Pos,lit(f,X),_), Pos != 0}.
 
preferredeq(P,Id) :- preference(P,aso,Id), value'(P,Id,V), required(P,aso,preferredeq),
                     V >= #min { 1   : not holds(X), preference(P,Id,0,lit(t,X),_);
                                 1   : holds(X), preference(P,Id,0,lit(f,X),_);
                                 1   : nohead(P,Id);
                                 Pos : holds(X), preference(P,Id,Pos,lit(t,X),_), Pos != 0;
                                 Pos : not holds(X), preference(P,Id,Pos,lit(f,X),_), Pos != 0}.

required(P,aso,preferred)   :- preference(P,aso), required(P,preferred).                             
required(P,aso,preferredeq) :- preference(P,aso), required(P,preferred).                             
preferred(P) :- preference(P,aso), required(P,preferred),
                preferredeq(P,Id1) : preference(P,aso,Id1);
                preferred(P,Id2), preference(P,aso,Id2).

required(P,aso,preferredeq) :- preference(P,aso), required(P,preferredeq).                            
preferredeq(P) :- preference(P,aso), required(P,preferredeq),
                  preferredeq(P,Id) : preference(P,aso,Id).

              
eq(P,Id) :- preference(P,aso,Id), value'(P,Id,V), required(P,aso,eq),
            V = #min { 1   : not holds(X), preference(P,Id,0,lit(t,X),_);
                       1   : holds(X), preference(P,Id,0,lit(f,X),_);
                       1   : nohead(P,Id);
                       Pos : holds(X), preference(P,Id,Pos,lit(t,X),_), Pos != 0;
                       Pos : not holds(X), preference(P,Id,Pos,lit(f,X),_), Pos != 0}.
 
worseeq(P,Id) :- preference(P,aso,Id), value'(P,Id,V), required(P,aso,worseeq),
                 V <= #min { 1   : not holds(X), preference(P,Id,0,lit(t,X),_);
                             1   : holds(X), preference(P,Id,0,lit(f,X),_);
                             1   : nohead(P,Id);
                             Pos : holds(X), preference(P,Id,Pos,lit(t,X),_), Pos != 0;
                             Pos : not holds(X), preference(P,Id,Pos,lit(f,X),_), Pos != 0}.
 
worse(P,Id) :- preference(P,aso,Id), value'(P,Id,V), required(P,aso,worse),
               V < #min { 1   : not holds(X), preference(P,Id,0,lit(t,X),_);
                          1   : holds(X), preference(P,Id,0,lit(f,X),_);
                          1   : nohead(P,Id);
                          Pos : holds(X), preference(P,Id,Pos,lit(t,X),_), Pos != 0;
                          Pos : not holds(X), preference(P,Id,Pos,lit(f,X),_), Pos != 0}.

required(P,aso,eq) :- preference(P,aso), required(P,eq).                             
eq(P) :- preference(P,aso), required(P,eq),
         eq(P,Id) : preference(P,aso,Id).

required(P,aso,worseeq) :- preference(P,aso), required(P,worseeq).                             
worseeq(P) :- preference(P,aso), required(P,worseeq),
              worseeq(P,Id) : preference(P,aso,Id).

required(P,aso,worseeq) :- preference(P,aso), required(P,worse).                             
required(P,aso,worse)   :- preference(P,aso), required(P,worse).                             
worse(P) :- preference(P,aso), required(P,worse),
            worseeq(P,Id1) : preference(P,aso,Id1);
            worse(P,Id2); preference(P,aso,Id2).

required(P,preferredeq) :- preference(P,aso), required(P,unc). 
required(P,worseeq)     :- preference(P,aso), required(P,unc). 
unc(P) :- preference(P,aso); required(P,unc); 
          not preferredeq(P); not worseeq(P).


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



#program preference.

required(Q,preferred) :- preference(P,lexico), required(P,preferred), preference(P,_,_,name(Q),_).
required(Q,eq)        :- preference(P,lexico), required(P,preferred), preference(P,_,_,name(Q),_).
preferred(P) :- preference(P,lexico), required(P,preferred),
                preferred(R); preference(P,_,_,name(R),(L));
	            eq(Q)      : preference(P,_,_,name(Q),(LL)), LL < L.

required(P,preferred) :- preference(P,lexico), required(P,preferredeq). 
required(P,eq)        :- preference(P,lexico), required(P,preferredeq). 
preferredeq(P) :- preference(P,lexico), required(P,preferredeq),
                  1 #sum { 1: preferred(P); 1: eq(P) }.

required(Q,eq) :- preference(P,lexico), required(P,eq), preference(P,_,_,name(Q),_).
eq(P) :- preference(P,lexico), required(P,eq),
         eq(Q) : preference(P,_,_,name(Q),_).

required(P,worse) :- preference(P,lexico), required(P,worseeq). 
required(P,eq)    :- preference(P,lexico), required(P,worseeq). 
worseeq(P) :- preference(P,lexico), required(P,worseeq),
              1 #sum { 1: worse(P); 1: eq(P) }.

required(Q,worse) :- preference(P,lexico), required(P,worse), preference(P,_,_,name(Q),_).
required(Q,eq)    :- preference(P,lexico), required(P,worse), preference(P,_,_,name(Q),_).
worse(P) :- preference(P,lexico), required(P,worse),
            worse(R); preference(P,_,_,name(R),(L));
	        eq(Q) : preference(P,_,_,name(Q),(LL)), LL < L.

required(P,preferredeq) :- preference(P,lexico), required(P,unc). 
required(P,worseeq)     :- preference(P,lexico), required(P,unc). 
unc(P) :- preference(P,lexico); required(P,unc); 
          not preferredeq(P); not worseeq(P).


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
	       


#program preference.

required(Q,worse) :- preference(P,neg), required(P,preferred), preference(P,_,_,name(Q),_).
preferred(P) :- preference(P,neg), required(P,preferred),
	            worse(Q), preference(P,_,_,name(Q),_).

required(P,preferred) :- preference(P,neg), required(P,preferredeq). 
required(P,eq)        :- preference(P,neg), required(P,preferredeq). 
preferredeq(P) :- preference(P,neg), required(P,preferredeq),
                  1 #sum { 1: preferred(P); 1: eq(P) }.

required(Q,eq) :- preference(P,neg), required(P,eq), preference(P,_,_,name(Q),_).
eq(P) :- preference(P,neg), required(P,eq),
	     eq(Q), preference(P,_,_,name(Q),_).

required(P,worse) :- preference(P,neg), required(P,worseeq). 
required(P,eq)    :- preference(P,neg), required(P,worseeq). 
worseeq(P) :- preference(P,neg), required(P,worseeq),
              1 #sum { 1: worse(P); 1: eq(P) }.

required(Q,preferred) :- preference(P,neg), required(P,worse), preference(P,_,_,name(Q),_).
worse(P) :- preference(P,neg), required(P,worse),
	        preferred(Q), preference(P,_,_,name(Q),_).

required(P,preferredeq) :- preference(P,neg), required(P,unc). 
required(P,worseeq)     :- preference(P,neg), required(P,unc). 
unc(P) :- preference(P,neg); required(P,unc); 
          not preferredeq(P); not worseeq(P).
      


#program preference.

required(Q,preferred)   :- preference(P,pareto), required(P,preferred), preference(P,_,_,name(Q),_).
required(Q,preferredeq) :- preference(P,pareto), required(P,preferred), preference(P,_,_,name(Q),_).
preferred(P) :- preference(P,pareto), required(P,preferred),
	            preferredeq(Q) : preference(P,_,_,name(Q),_);
                preferred(R);    preference(P,_,_,name(R),_).

required(Q,preferredeq) :- preference(P,pareto), required(P,preferredeq), preference(P,_,_,name(Q),_).
preferredeq(P) :- preference(P,pareto), required(P,preferredeq),
	              preferredeq(Q) : preference(P,_,_,name(Q),_).

required(Q,eq) :- preference(P,pareto), required(P,eq), preference(P,_,_,name(Q),_).
eq(P) :- preference(P,pareto), required(P,eq),
	     eq(Q) : preference(P,_,_,name(Q),_).

required(Q,worseeq) :- preference(P,pareto), required(P,worseeq), preference(P,_,_,name(Q),_).
worseeq(P) :- preference(P,pareto), required(P,worseeq),
	          worseeq(Q) : preference(P,_,_,name(Q),_).

required(Q,worse)   :- preference(P,pareto), required(P,worse), preference(P,_,_,name(Q),_).
required(Q,worseeq) :- preference(P,pareto), required(P,worse), preference(P,_,_,name(Q),_).
worse(P) :- preference(P,pareto), required(P,worse),
	        worseeq(Q) : preference(P,_,_,name(Q),_);
            worse(R);    preference(P,_,_,name(R),_).

required(P,preferredeq) :- preference(P,pareto), required(P,unc). 
required(P,worseeq)     :- preference(P,pareto), required(P,unc). 
unc(P) :- preference(P,pareto); required(P,unc); 
          not preferredeq(P); not worseeq(P).



#program preference.

%
% qualitative preferences
%

required(P)       :- preference(P,qpref), required(P,_).
required(P,noteq) :- preference(P,qpref), required(P,X), X != eq.

preference(P,lit(SX,X)) :- preference(P,qpref), required(P),
                           preference(P,I,1,lit(SX,X),_), not preference(P,I,2,_,_).
preference(P,lit(SX,X),lit(SY,Y)) :- preference(P,qpref), required(P,noteq),
                                     preference(P,I,1,lit(SX,X),_), preference(P,I,2,lit(SY,Y),_).

% transitive closure
preference(P,lit(SX,X),lit(SY,Y)) :- preference(P,qpref), required(P,noteq),
                                     preference(P,lit(SX,X),lit(SZ,Z)), 
                                     preference(P,lit(SZ,Z),lit(SY,Y)).

% preferred

better(P,lit(t,X)) :- preference(P,qpref), required(P,preferred), 
                      preference(P,lit(t,X)), holds(X), not holds'(X).

better(P,lit(f,X)) :- preference(P,qpref), required(P,preferred),
                      preference(P,lit(f,X)), not holds(X), holds'(X).

notbetter(P) :- preference(P,qpref), required(P,preferred),
                preference(P,lit(t,X)), not holds(X), holds'(X),
                not better(P,lit(SY,Y)) : preference(P,lit(SY,Y),lit(t,X)).

notbetter(P) :- preference(P,qpref), required(P,preferred),
                preference(P,lit(f,X)), holds(X), not holds'(X),
                not better(P,lit(SY,Y)) : preference(P,lit(SY,Y),lit(f,X)).

preferred(P) :- preference(P,qpref), required(P,preferred),
                1 #sum { 1: better(P,lit(SX,X)) }, not notbetter(P).

% preferredeq
required(P,eq)        :- preference(P,qpref), required(P,preferredeq).
required(P,preferred) :- preference(P,qpref), required(P,preferredeq).
preferredeq(P)  :- preference(P,qpref), required(P,preferredeq),
                   1 #sum { eq(P), preferred(P) }.

% eq
eq(P) :- preference(P,qpref), required(P,eq),
         holds(X) : preference(P,lit(_,X)), holds'(X);
         not holds(X) : preference(P,lit(_,X)), not holds'(X).


% worseeq
required(P,eq)    :- preference(P,qpref), required(P,worseeq).
required(P,worse) :- preference(P,qpref), required(P,worseeq).
worseeq(P)  :- preference(P,qpref), required(P,worseeq),
               1 #sum { eq(P), worse(P) }.


% worse
worse(P,lit(t,X)) :- preference(P,qpref), required(P,worse),
                     preference(P,lit(t,X)), holds'(X), not holds(X).

worse(P,lit(f,X)) :- preference(P,qpref), required(P,worse),
                     preference(P,lit(f,X)), not holds'(X), holds(X).

notworse(P) :- preference(P,qpref), required(P,worse),
               preference(P,lit(t,X)), not holds'(X), holds(X),
		       not worse(P,lit(SY,Y)) : preference(P,lit(SY,Y),lit(t,X)).

notworse(P) :- preference(P,qpref), required(P,worse),
               preference(P,lit(f,X)), holds'(X), not holds(X),
		       not worse(P,lit(SY,Y)) : preference(P,lit(SY,Y),lit(f,X)).
											
worse(P) :- preference(P,qpref), required(P,worse),
            1 #sum { 1: worse(P,lit(SX,X)) }, not notworse(P).

% unc
required(P,preferredeq) :- preference(P,qpref), required(P,unc).
required(P,worseeq)     :- preference(P,qpref), required(P,unc).
unc(P) :- preference(P,qpref), required(P,unc),
          not preferredeq(P), not worseeq(P).
      


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

