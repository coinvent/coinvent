
%file:	example.lp

%
% PROGRAM
%

gr(1..5).

1 { m(1) ; m(2) ; m(3) } 1.

a(1)    :- m(1).
b(1..5) :- m(1).

a(1..2) :- m(2).
b(1)    :- m(2).

a(5)    :- m(3).
b(2..5) :- m(3). 

#show m/1. #show a/1. #show b/1.




%file:	preference.lp
#program base.
%
% PREFERENCE STATEMENTS
%

__preference(p1,aso).
__preference(p1,(1,(X,Y)),1,lit(t,a(X)),()) :- gr(X), gr(Y), X = Y - 1.
__preference(p1,(1,(X,Y)),2,lit(t,a(Y)),()) :- gr(X), gr(Y), X = Y - 1.
__optimize(p1).


%file:	asprin.lib
#program base.

__required(P,preferred) :- __optimize(P).
#program constraints(m1,m2).
:- not __preferred(P,m1,m2),  __optimize(P);
		_volatile(m1,m2).





__required(Q,preferred) :- __preference(P,and), __required(P,preferred), __preference(P,_,_,name(Q),_).
#program preference(m1,m2).
__preferred(P,m1,m2) :- __preference(P,and), __required(P,preferred); 
	            __preferred(Q,m1,m2) : __preference(P,_,_,name(Q),_);
		_volatile(m1,m2).
            
__required(P,preferred) :- __preference(P,and), __required(P,preferredeq). 
__required(P,eq)        :- __preference(P,and), __required(P,preferredeq). 
#program preference(m1,m2).
__preferredeq(P,m1,m2) :- __preference(P,and), __required(P,preferredeq),
                  1 #sum { 1: __preferred(P,m1,m2); 1: __eq(P,m1,m2) };
		_volatile(m1,m2).

__required(Q,eq) :- __preference(P,and), __required(P,eq), __preference(P,_,_,name(Q),_).
#program preference(m1,m2).
__eq(P,m1,m2) :- __preference(P,and), __required(P,eq); 
	     __eq(Q,m1,m2) : __preference(P,_,_,name(Q),_);
		_volatile(m1,m2).

__required(P,worse) :- __preference(P,and), __required(P,worseeq). 
__required(P,eq)    :- __preference(P,and), __required(P,worseeq). 
#program preference(m1,m2).
__worseeq(P,m1,m2) :- __preference(P,and), __required(P,worseeq),
              1 #sum { 1: __worse(P,m1,m2); 1: __eq(P,m1,m2) };
		_volatile(m1,m2).

__required(Q,worse) :- __preference(P,and), __required(P,worse), __preference(P,_,_,name(Q),_).
#program preference(m1,m2).
__worse(P,m1,m2) :- __preference(P,and), __required(P,worse); 
	        __worse(Q,m1,m2) : __preference(P,_,_,name(Q),_);
		_volatile(m1,m2).

__required(P,preferredeq) :- __preference(P,and), __required(P,unc). 
__required(P,worseeq)     :- __preference(P,and), __required(P,unc). 
#program preference(m1,m2).
__unc(P,m1,m2) :- __preference(P,and); __required(P,unc); 
          not __preferredeq(P,m1,m2); not __worseeq(P,m1,m2);
		_volatile(m1,m2).





__required(P,aso) :- __preference(P,aso), __required(P,_).
__preference(P,aso,Id) :- __preference(P,aso), __required(P,aso), __preference(P,Id,_,_,_).

#program preference(m1,m2).
__nohead(P,Id,m1,m2) :- __preference(P,aso,Id), 
                not _holds(X,m1) : __preference(P,Id,H,lit(t,X),_), H!=0;
                _holds(X,m1)     : __preference(P,Id,H,lit(f,X),_), H!=0;
		_volatile(m1,m2).

#program preference(m1,m2).
__nohead'(P,Id,m1,m2) :- __preference(P,aso,Id), 
                 not _holds(X,m2) : __preference(P,Id,H,lit(t,X),_), H!=0;
                 _holds(X,m2)     : __preference(P,Id,H,lit(f,X),_), H!=0;
		_volatile(m1,m2).

#program preference(m1,m2).
__value'(P,Id,V,m1,m2) :- __preference(P,aso,Id),
                  V = #min { 1   : not _holds(X,m2), __preference(P,Id,0,lit(t,X),_);
                             1   : _holds(X,m2), __preference(P,Id,0,lit(f,X),_);
                             1   : __nohead'(P,Id,m1,m2);
                             Pos : _holds(X,m2), __preference(P,Id,Pos,lit(t,X),_), Pos != 0;
                             Pos : not _holds(X,m2), __preference(P,Id,Pos,lit(f,X),_), Pos != 0};
		_volatile(m1,m2).
 
#program preference(m1,m2).
__preferred(P,Id,m1,m2) :- __preference(P,aso,Id), __value'(P,Id,V,m1,m2), __required(P,aso,preferred), 
                   V > #min { 1   : not _holds(X,m1), __preference(P,Id,0,lit(t,X),_);
                              1   : _holds(X,m1), __preference(P,Id,0,lit(f,X),_);
                              1   : __nohead(P,Id,m1,m2);
                              Pos : _holds(X,m1), __preference(P,Id,Pos,lit(t,X),_), Pos != 0;
                              Pos : not _holds(X,m1), __preference(P,Id,Pos,lit(f,X),_), Pos != 0};
		_volatile(m1,m2).
 
#program preference(m1,m2).
__preferredeq(P,Id,m1,m2) :- __preference(P,aso,Id), __value'(P,Id,V,m1,m2), __required(P,aso,preferredeq),
                     V >= #min { 1   : not _holds(X,m1), __preference(P,Id,0,lit(t,X),_);
                                 1   : _holds(X,m1), __preference(P,Id,0,lit(f,X),_);
                                 1   : __nohead(P,Id,m1,m2);
                                 Pos : _holds(X,m1), __preference(P,Id,Pos,lit(t,X),_), Pos != 0;
                                 Pos : not _holds(X,m1), __preference(P,Id,Pos,lit(f,X),_), Pos != 0};
		_volatile(m1,m2).

__required(P,aso,preferred)   :- __preference(P,aso), __required(P,preferred).                             
__required(P,aso,preferredeq) :- __preference(P,aso), __required(P,preferred).                             
#program preference(m1,m2).
__preferred(P,m1,m2) :- __preference(P,aso), __required(P,preferred),
                __preferredeq(P,Id1,m1,m2) : __preference(P,aso,Id1);
                __preferred(P,Id2,m1,m2), __preference(P,aso,Id2);
		_volatile(m1,m2).

__required(P,aso,preferredeq) :- __preference(P,aso), __required(P,preferredeq).                            
#program preference(m1,m2).
__preferredeq(P,m1,m2) :- __preference(P,aso), __required(P,preferredeq),
                  __preferredeq(P,Id,m1,m2) : __preference(P,aso,Id);
		_volatile(m1,m2).

              
#program preference(m1,m2).
__eq(P,Id,m1,m2) :- __preference(P,aso,Id), __value'(P,Id,V,m1,m2), __required(P,aso,eq),
            V = #min { 1   : not _holds(X,m1), __preference(P,Id,0,lit(t,X),_);
                       1   : _holds(X,m1), __preference(P,Id,0,lit(f,X),_);
                       1   : __nohead(P,Id,m1,m2);
                       Pos : _holds(X,m1), __preference(P,Id,Pos,lit(t,X),_), Pos != 0;
                       Pos : not _holds(X,m1), __preference(P,Id,Pos,lit(f,X),_), Pos != 0};
		_volatile(m1,m2).
 
#program preference(m1,m2).
__worseeq(P,Id,m1,m2) :- __preference(P,aso,Id), __value'(P,Id,V,m1,m2), __required(P,aso,worseeq),
                 V <= #min { 1   : not _holds(X,m1), __preference(P,Id,0,lit(t,X),_);
                             1   : _holds(X,m1), __preference(P,Id,0,lit(f,X),_);
                             1   : __nohead(P,Id,m1,m2);
                             Pos : _holds(X,m1), __preference(P,Id,Pos,lit(t,X),_), Pos != 0;
                             Pos : not _holds(X,m1), __preference(P,Id,Pos,lit(f,X),_), Pos != 0};
		_volatile(m1,m2).
 
#program preference(m1,m2).
__worse(P,Id,m1,m2) :- __preference(P,aso,Id), __value'(P,Id,V,m1,m2), __required(P,aso,worse),
               V < #min { 1   : not _holds(X,m1), __preference(P,Id,0,lit(t,X),_);
                          1   : _holds(X,m1), __preference(P,Id,0,lit(f,X),_);
                          1   : __nohead(P,Id,m1,m2);
                          Pos : _holds(X,m1), __preference(P,Id,Pos,lit(t,X),_), Pos != 0;
                          Pos : not _holds(X,m1), __preference(P,Id,Pos,lit(f,X),_), Pos != 0};
		_volatile(m1,m2).

__required(P,aso,eq) :- __preference(P,aso), __required(P,eq).                             
#program preference(m1,m2).
__eq(P,m1,m2) :- __preference(P,aso), __required(P,eq),
         __eq(P,Id,m1,m2) : __preference(P,aso,Id);
		_volatile(m1,m2).

__required(P,aso,worseeq) :- __preference(P,aso), __required(P,worseeq).                             
#program preference(m1,m2).
__worseeq(P,m1,m2) :- __preference(P,aso), __required(P,worseeq),
              __worseeq(P,Id,m1,m2) : __preference(P,aso,Id);
		_volatile(m1,m2).

__required(P,aso,worseeq) :- __preference(P,aso), __required(P,worse).                             
__required(P,aso,worse)   :- __preference(P,aso), __required(P,worse).                             
#program preference(m1,m2).
__worse(P,m1,m2) :- __preference(P,aso), __required(P,worse),
            __worseeq(P,Id1,m1,m2) : __preference(P,aso,Id1);
            __worse(P,Id2,m1,m2); __preference(P,aso,Id2);
		_volatile(m1,m2).

__required(P,preferredeq) :- __preference(P,aso), __required(P,unc). 
__required(P,worseeq)     :- __preference(P,aso), __required(P,unc). 
#program preference(m1,m2).
__unc(P,m1,m2) :- __preference(P,aso); __required(P,unc); 
          not __preferredeq(P,m1,m2); not __worseeq(P,m1,m2);
		_volatile(m1,m2).




#program preference(m1,m2).
__preferred(P,m1,m2) :- __preference(P,less(cardinality)), __required(P,preferred),
                1 #sum { -1,X   :     _holds(X,m1),  __preference(P,_,_,lit(t,X),()); 
                         -1,X   : not _holds(X,m1),  __preference(P,_,_,lit(f,X),()); 
                          1,X   :     _holds(X,m2), __preference(P,_,_,lit(t,X),()); 
                          1,X   : not _holds(X,m2), __preference(P,_,_,lit(f,X),())};
		_volatile(m1,m2).

#program preference(m1,m2).
__preferredeq(P,m1,m2) :- __preference(P,less(cardinality)), __required(P,preferredeq),
                  0 #sum { -1,X   :     _holds(X,m1),  __preference(P,_,_,lit(t,X),()); 
                           -1,X   : not _holds(X,m1),  __preference(P,_,_,lit(f,X),()); 
                            1,X   :     _holds(X,m2), __preference(P,_,_,lit(t,X),()); 
                            1,X   : not _holds(X,m2), __preference(P,_,_,lit(f,X),())};
		_volatile(m1,m2).

#program preference(m1,m2).
__eq(P,m1,m2) :- __preference(P,less(cardinality)), __required(P,eq),
         0 #sum { -1,X   :     _holds(X,m1),  __preference(P,_,_,lit(t,X),()); 
                  -1,X   : not _holds(X,m1),  __preference(P,_,_,lit(f,X),()); 
                   1,X   :     _holds(X,m2), __preference(P,_,_,lit(t,X),()); 
                   1,X   : not _holds(X,m2), __preference(P,_,_,lit(f,X),())} 0;
		_volatile(m1,m2).

#program preference(m1,m2).
__worseeq(P,m1,m2) :- __preference(P,less(cardinality)), __required(P,worseeq),
              #sum { -1,X   :     _holds(X,m1),  __preference(P,_,_,lit(t,X),()); 
                     -1,X   : not _holds(X,m1),  __preference(P,_,_,lit(f,X),()); 
                      1,X   :     _holds(X,m2), __preference(P,_,_,lit(t,X),()); 
                      1,X   : not _holds(X,m2), __preference(P,_,_,lit(f,X),())} 0;
		_volatile(m1,m2).

#program preference(m1,m2).
__worse(P,m1,m2) :- __preference(P,less(cardinality)), __required(P,worse),
            #sum { -1,X   :     _holds(X,m1),  __preference(P,_,_,lit(t,X),()); 
                   -1,X   : not _holds(X,m1),  __preference(P,_,_,lit(f,X),()); 
                    1,X   :     _holds(X,m2), __preference(P,_,_,lit(t,X),()); 
                    1,X   : not _holds(X,m2), __preference(P,_,_,lit(f,X),())} -1;
		_volatile(m1,m2).


%
% _heuristic
%

__modifier(P,t,false) :- __preference(P,less(cardinality)), __required(P,preferred), _h == on. 
__modifier(P,f,true)  :- __preference(P,less(cardinality)), __required(P,preferred), _h == on. 
_heuristic(X,M,1)   :- __preference(P,less(cardinality)), __required(P,preferred), _h == on, 
                       __preference(P,_,_,lit(S,X),_), __modifier(P,S,M).





#program preference(m1,m2).
__preferred(P,m1,m2) :- __preference(P,less(weight)), __required(P,preferred),
                #sum { W,T :     _holds(X,m1),  __preference(P,_,_,lit(t,X),(W,T)); 
                       W,T : not _holds(X,m1),  __preference(P,_,_,lit(f,X),(W,T)); 
                      -W,T :     _holds(X,m2), __preference(P,_,_,lit(t,X),(W,T)); 
		      -W,T : not _holds(X,m2), __preference(P,_,_,lit(f,X),(W,T))} -1;
		_volatile(m1,m2).

#program preference(m1,m2).
__preferredeq(P,m1,m2) :- __preference(P,less(weight)), __required(P,preferredeq),
                  #sum { W,T :     _holds(X,m1),  __preference(P,_,_,lit(t,X),(W,T)); 
                         W,T : not _holds(X,m1),  __preference(P,_,_,lit(f,X),(W,T)); 
                        -W,T :     _holds(X,m2), __preference(P,_,_,lit(t,X),(W,T)); 
                        -W,T : not _holds(X,m2), __preference(P,_,_,lit(f,X),(W,T))}0;
		_volatile(m1,m2).

#program preference(m1,m2).
__eq(P,m1,m2) :- __preference(P,less(weight)), __required(P,eq),
         0 #sum { W,T :     _holds(X,m1),  __preference(P,_,_,lit(t,X),(W,T)); 
                  W,T : not _holds(X,m1),  __preference(P,_,_,lit(f,X),(W,T)); 
                 -W,T :     _holds(X,m2), __preference(P,_,_,lit(t,X),(W,T)); 
                 -W,T : not _holds(X,m2), __preference(P,_,_,lit(f,X),(W,T))} 0;
		_volatile(m1,m2).

#program preference(m1,m2).
__worseeq(P,m1,m2) :- __preference(P,less(weight)), __required(P,worseeq),
              0 #sum { W,T :     _holds(X,m1),  __preference(P,_,_,lit(t,X),(W,T)); 
                       W,T : not _holds(X,m1),  __preference(P,_,_,lit(f,X),(W,T)); 
                      -W,T :     _holds(X,m2), __preference(P,_,_,lit(t,X),(W,T)); 
                      -W,T : not _holds(X,m2), __preference(P,_,_,lit(f,X),(W,T))};
		_volatile(m1,m2).
 
#program preference(m1,m2).
__worse(P,m1,m2) :- __preference(P,less(weight)), __required(P,worse),
            1 #sum { W,T :     _holds(X,m1),  __preference(P,_,_,lit(t,X),(W,T)); 
                     W,T : not _holds(X,m1),  __preference(P,_,_,lit(f,X),(W,T)); 
                    -W,T :     _holds(X,m2), __preference(P,_,_,lit(t,X),(W,T)); 
		    -W,T : not _holds(X,m2), __preference(P,_,_,lit(f,X),(W,T))};
		_volatile(m1,m2).

%
% _heuristic
%

__modifier_pos(P,t,false)  :- __preference(P,less(weight)), __required(P,preferred), _h == on. 
__modifier_pos(P,f,true)   :- __preference(P,less(weight)), __required(P,preferred), _h == on. 
__modifier_zero(P,t,level) :- __preference(P,less(weight)), __required(P,preferred), _h == on. 
__modifier_zero(P,f,level) :- __preference(P,less(weight)), __required(P,preferred), _h == on. 
__modifier_neg(P,t,true)   :- __preference(P,less(weight)), __required(P,preferred), _h == on. 
__modifier_neg(P,f,false)  :- __preference(P,less(weight)), __required(P,preferred), _h == on. 

_heuristic(X,M,1)   :- __preference(P,less(weight)), __required(P,preferred), _h == on, 
                       __preference(P,_,_,lit(S,X),(W,T)), __modifier_pos(P,S,M), W > 0.
_heuristic(X,M,1)   :- __preference(P,less(weight)), __required(P,preferred), _h == on, 
                       __preference(P,_,_,lit(S,X),(W,T)), __modifier_zero(P,S,M), W = 0.
_heuristic(X,M,1)   :- __preference(P,less(weight)), __required(P,preferred), _h == on, 
                       __preference(P,_,_,lit(S,X),(W,T)), __modifier_neg(P,S,M), W < 0.


% UNCOMMENT WHEN TOBIAS FIXES THE PARSER!
% AND ADD HERE A SHOW OF THE HEURISTIC!
%#show X : preference(P,less(weight)), required(P,preferred), _h == on, 
%          preference(P,_,_,lit(S,X),(W,T)).





__required(Q,preferred) :- __preference(P,lexico), __required(P,preferred), __preference(P,_,_,name(Q),_).
__required(Q,eq)        :- __preference(P,lexico), __required(P,preferred), __preference(P,_,_,name(Q),_).
#program preference(m1,m2).
__preferred(P,m1,m2) :- __preference(P,lexico), __required(P,preferred),
                __preferred(R,m1,m2); __preference(P,_,_,name(R),(L));
	            __eq(Q,m1,m2)      : __preference(P,_,_,name(Q),(LL)), LL < L;
		_volatile(m1,m2).

__required(P,preferred) :- __preference(P,lexico), __required(P,preferredeq). 
__required(P,eq)        :- __preference(P,lexico), __required(P,preferredeq). 
#program preference(m1,m2).
__preferredeq(P,m1,m2) :- __preference(P,lexico), __required(P,preferredeq),
                  1 #sum { 1: __preferred(P,m1,m2); 1: __eq(P,m1,m2) };
		_volatile(m1,m2).

__required(Q,eq) :- __preference(P,lexico), __required(P,eq), __preference(P,_,_,name(Q),_).
#program preference(m1,m2).
__eq(P,m1,m2) :- __preference(P,lexico), __required(P,eq),
         __eq(Q,m1,m2) : __preference(P,_,_,name(Q),_);
		_volatile(m1,m2).

__required(P,worse) :- __preference(P,lexico), __required(P,worseeq). 
__required(P,eq)    :- __preference(P,lexico), __required(P,worseeq). 
#program preference(m1,m2).
__worseeq(P,m1,m2) :- __preference(P,lexico), __required(P,worseeq),
              1 #sum { 1: __worse(P,m1,m2); 1: __eq(P,m1,m2) };
		_volatile(m1,m2).

__required(Q,worse) :- __preference(P,lexico), __required(P,worse), __preference(P,_,_,name(Q),_).
__required(Q,eq)    :- __preference(P,lexico), __required(P,worse), __preference(P,_,_,name(Q),_).
#program preference(m1,m2).
__worse(P,m1,m2) :- __preference(P,lexico), __required(P,worse),
            __worse(R,m1,m2); __preference(P,_,_,name(R),(L));
	        __eq(Q,m1,m2) : __preference(P,_,_,name(Q),(LL)), LL < L;
		_volatile(m1,m2).

__required(P,preferredeq) :- __preference(P,lexico), __required(P,unc). 
__required(P,worseeq)     :- __preference(P,lexico), __required(P,unc). 
#program preference(m1,m2).
__unc(P,m1,m2) :- __preference(P,lexico); __required(P,unc); 
          not __preferredeq(P,m1,m2); not __worseeq(P,m1,m2);
		_volatile(m1,m2).




#program preference(m1,m2).
__preferred(P,m1,m2) :- __preference(P,more(cardinality)), __required(P,preferred),
                #sum { -1,X   :     _holds(X,m1),  __preference(P,_,_,lit(t,X),()); 
                       -1,X   : not _holds(X,m1),  __preference(P,_,_,lit(f,X),()); 
                        1,X   :     _holds(X,m2), __preference(P,_,_,lit(t,X),()); 
                        1,X   : not _holds(X,m2), __preference(P,_,_,lit(f,X),())} -1;
		_volatile(m1,m2).

#program preference(m1,m2).
__preferredeq(P,m1,m2) :- __preference(P,more(cardinality)), __required(P,preferredeq),
                  #sum { -1,X   :     _holds(X,m1),  __preference(P,_,_,lit(t,X),()); 
                         -1,X   : not _holds(X,m1),  __preference(P,_,_,lit(f,X),()); 
                          1,X   :     _holds(X,m2), __preference(P,_,_,lit(t,X),()); 
                          1,X   : not _holds(X,m2), __preference(P,_,_,lit(f,X),())} 0;
		_volatile(m1,m2).

#program preference(m1,m2).
__eq(P,m1,m2) :- __preference(P,more(cardinality)), __required(P,eq),
         0 #sum { -1,X   :     _holds(X,m1),  __preference(P,_,_,lit(t,X),()); 
                  -1,X   : not _holds(X,m1),  __preference(P,_,_,lit(f,X),()); 
                   1,X   :     _holds(X,m2), __preference(P,_,_,lit(t,X),()); 
                   1,X   : not _holds(X,m2), __preference(P,_,_,lit(f,X),())} 0;
		_volatile(m1,m2).

#program preference(m1,m2).
__worseeq(P,m1,m2) :- __preference(P,more(cardinality)), __required(P,worseeq),
              0 #sum { -1,X   :     _holds(X,m1),  __preference(P,_,_,lit(t,X),()); 
                       -1,X   : not _holds(X,m1),  __preference(P,_,_,lit(f,X),()); 
                        1,X   :     _holds(X,m2), __preference(P,_,_,lit(t,X),()); 
                        1,X   : not _holds(X,m2), __preference(P,_,_,lit(f,X),())};
		_volatile(m1,m2).

#program preference(m1,m2).
__worse(P,m1,m2) :- __preference(P,more(cardinality)), __required(P,worse),
            1 #sum { -1,X   :     _holds(X,m1),  __preference(P,_,_,lit(t,X),()); 
                     -1,X   : not _holds(X,m1),  __preference(P,_,_,lit(f,X),()); 
                      1,X   :     _holds(X,m2), __preference(P,_,_,lit(t,X),()); 
                      1,X   : not _holds(X,m2), __preference(P,_,_,lit(f,X),())};
		_volatile(m1,m2).

%
% _heuristic
%

__modifier(P,t,true)  :- __preference(P,more(cardinality)), __required(P,preferred), _h == on. 
__modifier(P,f,false) :- __preference(P,more(cardinality)), __required(P,preferred), _h == on. 
_heuristic(X,M,1)   :- __preference(P,more(cardinality)), __required(P,preferred), _h == on, 
                       __preference(P,_,_,lit(S,X),()), __modifier(P,S,M).
     




#program preference(m1,m2).
__preferred(P,m1,m2) :- __preference(P,more(weight)), __required(P,preferred),
                1 #sum { W,T :     _holds(X,m1),  __preference(P,_,_,lit(t,X),(W,T)); 
                         W,T : not _holds(X,m1),  __preference(P,_,_,lit(f,X),(W,T)); 
                        -W,T :     _holds(X,m2), __preference(P,_,_,lit(t,X),(W,T)); 
                        -W,T : not _holds(X,m2), __preference(P,_,_,lit(f,X),(W,T))};
		_volatile(m1,m2).

#program preference(m1,m2).
__preferredeq(P,m1,m2) :- __preference(P,more(weight)), __required(P,preferredeq),
                  0 #sum { W,T :     _holds(X,m1),  __preference(P,_,_,lit(t,X),(W,T)); 
                           W,T : not _holds(X,m1),  __preference(P,_,_,lit(f,X),(W,T)); 
                          -W,T :     _holds(X,m2), __preference(P,_,_,lit(t,X),(W,T)); 
                          -W,T : not _holds(X,m2), __preference(P,_,_,lit(f,X),(W,T))};
		_volatile(m1,m2).

#program preference(m1,m2).
__eq(P,m1,m2) :- __preference(P,more(weight)), __required(P,eq),
         0 #sum { W,T :     _holds(X,m1),  __preference(P,_,_,lit(t,X),(W,T)); 
                  W,T : not _holds(X,m1),  __preference(P,_,_,lit(f,X),(W,T)); 
                 -W,T :     _holds(X,m2), __preference(P,_,_,lit(t,X),(W,T)); 
                 -W,T : not _holds(X,m2), __preference(P,_,_,lit(f,X),(W,T))} 0;
		_volatile(m1,m2).

#program preference(m1,m2).
__worseeq(P,m1,m2) :- __preference(P,more(weight)), __required(P,worseeq),
              #sum { W,T :     _holds(X,m1),  __preference(P,_,_,lit(t,X),(W,T)); 
                     W,T : not _holds(X,m1),  __preference(P,_,_,lit(f,X),(W,T)); 
                    -W,T :     _holds(X,m2), __preference(P,_,_,lit(t,X),(W,T)); 
                    -W,T : not _holds(X,m2), __preference(P,_,_,lit(f,X),(W,T))} 0;
		_volatile(m1,m2).

#program preference(m1,m2).
__worse(P,m1,m2) :- __preference(P,more(weight)), __required(P,worse),
            #sum { W,T :     _holds(X,m1),  __preference(P,_,_,lit(t,X),(W,T)); 
                   W,T : not _holds(X,m1),  __preference(P,_,_,lit(f,X),(W,T)); 
                  -W,T :     _holds(X,m2), __preference(P,_,_,lit(t,X),(W,T)); 
		  -W,T : not _holds(X,m2), __preference(P,_,_,lit(f,X),(W,T))} -1;
		_volatile(m1,m2).

%
% _heuristic
%

__modifier_pos(P,t,true)   :- __preference(P,more(weight)), __required(P,preferred), _h == on. 
__modifier_pos(P,f,false)  :- __preference(P,more(weight)), __required(P,preferred), _h == on. 
__modifier_zero(P,t,level) :- __preference(P,more(weight)), __required(P,preferred), _h == on. 
__modifier_zero(P,f,level) :- __preference(P,more(weight)), __required(P,preferred), _h == on. 
__modifier_neg(P,t,false)  :- __preference(P,more(weight)), __required(P,preferred), _h == on. 
__modifier_neg(P,f,true)   :- __preference(P,more(weight)), __required(P,preferred), _h == on. 

_heuristic(X,M,1)   :- __preference(P,more(weight)), __required(P,preferred), _h == on, 
                       __preference(P,_,_,lit(S,X),(W,T)), __modifier_pos(P,S,M), W > 0.
_heuristic(X,M,1)   :- __preference(P,more(weight)), __required(P,preferred), _h == on, 
                       __preference(P,_,_,lit(S,X),(W,T)), __modifier_zero(P,S,M), W = 0.
_heuristic(X,M,1)   :- __preference(P,more(weight)), __required(P,preferred), _h == on, 
                       __preference(P,_,_,lit(S,X),(W,T)), __modifier_neg(P,S,M), W < 0.
	       




__required(Q,worse) :- __preference(P,neg), __required(P,preferred), __preference(P,_,_,name(Q),_).
#program preference(m1,m2).
__preferred(P,m1,m2) :- __preference(P,neg), __required(P,preferred),
	            __worse(Q,m1,m2), __preference(P,_,_,name(Q),_);
		_volatile(m1,m2).

__required(P,preferred) :- __preference(P,neg), __required(P,preferredeq). 
__required(P,eq)        :- __preference(P,neg), __required(P,preferredeq). 
#program preference(m1,m2).
__preferredeq(P,m1,m2) :- __preference(P,neg), __required(P,preferredeq),
                  1 #sum { 1: __preferred(P,m1,m2); 1: __eq(P,m1,m2) };
		_volatile(m1,m2).

__required(Q,eq) :- __preference(P,neg), __required(P,eq), __preference(P,_,_,name(Q),_).
#program preference(m1,m2).
__eq(P,m1,m2) :- __preference(P,neg), __required(P,eq),
	     __eq(Q,m1,m2), __preference(P,_,_,name(Q),_);
		_volatile(m1,m2).

__required(P,worse) :- __preference(P,neg), __required(P,worseeq). 
__required(P,eq)    :- __preference(P,neg), __required(P,worseeq). 
#program preference(m1,m2).
__worseeq(P,m1,m2) :- __preference(P,neg), __required(P,worseeq),
              1 #sum { 1: __worse(P,m1,m2); 1: __eq(P,m1,m2) };
		_volatile(m1,m2).

__required(Q,preferred) :- __preference(P,neg), __required(P,worse), __preference(P,_,_,name(Q),_).
#program preference(m1,m2).
__worse(P,m1,m2) :- __preference(P,neg), __required(P,worse),
	        __preferred(Q,m1,m2), __preference(P,_,_,name(Q),_);
		_volatile(m1,m2).

__required(P,preferredeq) :- __preference(P,neg), __required(P,unc). 
__required(P,worseeq)     :- __preference(P,neg), __required(P,unc). 
#program preference(m1,m2).
__unc(P,m1,m2) :- __preference(P,neg); __required(P,unc); 
          not __preferredeq(P,m1,m2); not __worseeq(P,m1,m2);
		_volatile(m1,m2).
      




__required(Q,preferred)   :- __preference(P,pareto), __required(P,preferred), __preference(P,_,_,name(Q),_).
__required(Q,preferredeq) :- __preference(P,pareto), __required(P,preferred), __preference(P,_,_,name(Q),_).
#program preference(m1,m2).
__preferred(P,m1,m2) :- __preference(P,pareto), __required(P,preferred),
	            __preferredeq(Q,m1,m2) : __preference(P,_,_,name(Q),_);
                __preferred(R,m1,m2);    __preference(P,_,_,name(R),_);
		_volatile(m1,m2).

__required(Q,preferredeq) :- __preference(P,pareto), __required(P,preferredeq), __preference(P,_,_,name(Q),_).
#program preference(m1,m2).
__preferredeq(P,m1,m2) :- __preference(P,pareto), __required(P,preferredeq),
	              __preferredeq(Q,m1,m2) : __preference(P,_,_,name(Q),_);
		_volatile(m1,m2).

__required(Q,eq) :- __preference(P,pareto), __required(P,eq), __preference(P,_,_,name(Q),_).
#program preference(m1,m2).
__eq(P,m1,m2) :- __preference(P,pareto), __required(P,eq),
	     __eq(Q,m1,m2) : __preference(P,_,_,name(Q),_);
		_volatile(m1,m2).

__required(Q,worseeq) :- __preference(P,pareto), __required(P,worseeq), __preference(P,_,_,name(Q),_).
#program preference(m1,m2).
__worseeq(P,m1,m2) :- __preference(P,pareto), __required(P,worseeq),
	          __worseeq(Q,m1,m2) : __preference(P,_,_,name(Q),_);
		_volatile(m1,m2).

__required(Q,worse)   :- __preference(P,pareto), __required(P,worse), __preference(P,_,_,name(Q),_).
__required(Q,worseeq) :- __preference(P,pareto), __required(P,worse), __preference(P,_,_,name(Q),_).
#program preference(m1,m2).
__worse(P,m1,m2) :- __preference(P,pareto), __required(P,worse),
	        __worseeq(Q,m1,m2) : __preference(P,_,_,name(Q),_);
            __worse(R,m1,m2);    __preference(P,_,_,name(R),_);
		_volatile(m1,m2).

__required(P,preferredeq) :- __preference(P,pareto), __required(P,unc). 
__required(P,worseeq)     :- __preference(P,pareto), __required(P,unc). 
#program preference(m1,m2).
__unc(P,m1,m2) :- __preference(P,pareto); __required(P,unc); 
          not __preferredeq(P,m1,m2); not __worseeq(P,m1,m2);
		_volatile(m1,m2).





%
% qualitative preferences
%

__required(P)       :- __preference(P,qpref), __required(P,_).
__required(P,noteq) :- __preference(P,qpref), __required(P,X), X != eq.

__preference(P,lit(SX,X)) :- __preference(P,qpref), __required(P),
                           __preference(P,I,1,lit(SX,X),_), not __preference(P,I,2,_,_).
__preference(P,lit(SX,X),lit(SY,Y)) :- __preference(P,qpref), __required(P,noteq),
                                     __preference(P,I,1,lit(SX,X),_), __preference(P,I,2,lit(SY,Y),_).

% transitive closure
__preference(P,lit(SX,X),lit(SY,Y)) :- __preference(P,qpref), __required(P,noteq),
                                     __preference(P,lit(SX,X),lit(SZ,Z)), 
                                     __preference(P,lit(SZ,Z),lit(SY,Y)).

% preferred

#program preference(m1,m2).
__better(P,lit(t,X),m1,m2) :- __preference(P,qpref), __required(P,preferred), 
                      __preference(P,lit(t,X)), _holds(X,m1), not _holds(X,m2);
		_volatile(m1,m2).

#program preference(m1,m2).
__better(P,lit(f,X),m1,m2) :- __preference(P,qpref), __required(P,preferred),
                      __preference(P,lit(f,X)), not _holds(X,m1), _holds(X,m2);
		_volatile(m1,m2).

#program preference(m1,m2).
__notbetter(P,m1,m2) :- __preference(P,qpref), __required(P,preferred),
                __preference(P,lit(t,X)), not _holds(X,m1), _holds(X,m2),
                not __better(P,lit(SY,Y),m1,m2) : __preference(P,lit(SY,Y),lit(t,X));
		_volatile(m1,m2).

#program preference(m1,m2).
__notbetter(P,m1,m2) :- __preference(P,qpref), __required(P,preferred),
                __preference(P,lit(f,X)), _holds(X,m1), not _holds(X,m2),
                not __better(P,lit(SY,Y),m1,m2) : __preference(P,lit(SY,Y),lit(f,X));
		_volatile(m1,m2).

#program preference(m1,m2).
__preferred(P,m1,m2) :- __preference(P,qpref), __required(P,preferred),
                1 #sum { 1: __better(P,lit(SX,X),m1,m2) }, not __notbetter(P,m1,m2);
		_volatile(m1,m2).

% preferredeq
__required(P,eq)        :- __preference(P,qpref), __required(P,preferredeq).
__required(P,preferred) :- __preference(P,qpref), __required(P,preferredeq).
#program preference(m1,m2).
__preferredeq(P,m1,m2)  :- __preference(P,qpref), __required(P,preferredeq),
                   1 #sum { eq(P), preferred(P) };
		_volatile(m1,m2).

% eq
#program preference(m1,m2).
__eq(P,m1,m2) :- __preference(P,qpref), __required(P,eq),
         _holds(X,m1) : __preference(P,lit(_,X)), _holds(X,m2);
         not _holds(X,m1) : __preference(P,lit(_,X)), not _holds(X,m2);
		_volatile(m1,m2).


% worseeq
__required(P,eq)    :- __preference(P,qpref), __required(P,worseeq).
__required(P,worse) :- __preference(P,qpref), __required(P,worseeq).
#program preference(m1,m2).
__worseeq(P,m1,m2)  :- __preference(P,qpref), __required(P,worseeq),
               1 #sum { eq(P), worse(P) };
		_volatile(m1,m2).


% worse
#program preference(m1,m2).
__worse(P,lit(t,X),m1,m2) :- __preference(P,qpref), __required(P,worse),
                     __preference(P,lit(t,X)), _holds(X,m2), not _holds(X,m1);
		_volatile(m1,m2).

#program preference(m1,m2).
__worse(P,lit(f,X),m1,m2) :- __preference(P,qpref), __required(P,worse),
                     __preference(P,lit(f,X)), not _holds(X,m2), _holds(X,m1);
		_volatile(m1,m2).

#program preference(m1,m2).
__notworse(P,m1,m2) :- __preference(P,qpref), __required(P,worse),
               __preference(P,lit(t,X)), not _holds(X,m2), _holds(X,m1),
		       not __worse(P,lit(SY,Y),m1,m2) : __preference(P,lit(SY,Y),lit(t,X));
		_volatile(m1,m2).

#program preference(m1,m2).
__notworse(P,m1,m2) :- __preference(P,qpref), __required(P,worse),
               __preference(P,lit(f,X)), _holds(X,m2), not _holds(X,m1),
		       not __worse(P,lit(SY,Y),m1,m2) : __preference(P,lit(SY,Y),lit(f,X));
		_volatile(m1,m2).
											
#program preference(m1,m2).
__worse(P,m1,m2) :- __preference(P,qpref), __required(P,worse),
            1 #sum { 1: __worse(P,lit(SX,X),m1,m2) }, not __notworse(P,m1,m2);
		_volatile(m1,m2).

% unc
__required(P,preferredeq) :- __preference(P,qpref), __required(P,unc).
__required(P,worseeq)     :- __preference(P,qpref), __required(P,unc).
#program preference(m1,m2).
__unc(P,m1,m2) :- __preference(P,qpref), __required(P,unc),
          not __preferredeq(P,m1,m2), not __worseeq(P,m1,m2);
		_volatile(m1,m2).
      




#program preference(m1,m2).
__preferred(P,m1,m2) :- __preference(P,subset); __required(P,preferred); 
                not _holds(X,m1) : __preference(P,_,_,lit(t,X),_), not _holds(X,m2);
                _holds(X,m1) : __preference(P,_,_,lit(f,X),_), _holds(X,m2);
                1 #sum { 1 : not _holds(X,m1), _holds(X,m2), __preference(P,_,_,lit(t,X),_);
                         1 : _holds(X,m1), not _holds(X,m2), __preference(P,_,_,lit(f,X),_)};
		_volatile(m1,m2).

#program preference(m1,m2).
__preferredeq(P,m1,m2) :- __preference(P,subset); __required(P,preferredeq); 
                  not _holds(X,m1) : __preference(P,_,_,lit(t,X),_), not _holds(X,m2);
                  _holds(X,m1) : __preference(P,_,_,lit(f,X),_), _holds(X,m2);
		_volatile(m1,m2).

__required(P,preferredeq) :- __preference(P,subset); __required(P,eq). 
__required(P,worseeq)     :- __preference(P,subset); __required(P,eq). 
#program preference(m1,m2).
__eq(P,m1,m2) :- __preference(P,subset); __required(P,eq); 
         __preferredeq(P,m1,m2); __worseeq(P,m1,m2);
		_volatile(m1,m2).

#program preference(m1,m2).
__worseeq(P,m1,m2) :- __preference(P,subset); __required(P,worseeq); 
              not _holds(X,m2) : __preference(P,_,_,lit(t,X),_), not _holds(X,m1);
              _holds(X,m2) : __preference(P,_,_,lit(f,X),_), _holds(X,m1);
		_volatile(m1,m2).

__required(P,preferredeq) :- __preference(P,subset); __required(P,worse). 
__required(P,worseeq)     :- __preference(P,subset); __required(P,worse). 
#program preference(m1,m2).
__worse(P,m1,m2) :- __preference(P,subset); __required(P,worse); 
            not __preferredeq(P,m1,m2); __worseeq(P,m1,m2);
		_volatile(m1,m2).

__required(P,preferredeq) :- __preference(P,subset); __required(P,unc). 
__required(P,worseeq)     :- __preference(P,subset); __required(P,unc). 
#program preference(m1,m2).
__unc(P,m1,m2) :- __preference(P,subset); __required(P,unc); 
          not __preferredeq(P,m1,m2); not __worseeq(P,m1,m2);
		_volatile(m1,m2).





#program preference(m1,m2).
__preferred(P,m1,m2) :- __preference(P,superset); __required(P,preferred); 
                _holds(X,m1) : __preference(P,_,_,lit(t,X),_), _holds(X,m2);
                not _holds(X,m1) : __preference(P,_,_,lit(f,X),_), not _holds(X,m2);
                1 #sum { 1 : _holds(X,m1), not _holds(X,m2), __preference(P,_,_,lit(t,X),_);
                         1 : not _holds(X,m1), _holds(X,m2), __preference(P,_,_,lit(f,X),_)};
		_volatile(m1,m2).

#program preference(m1,m2).
__preferredeq(P,m1,m2) :- __preference(P,superset); __required(P,preferredeq); 
                  _holds(X,m1) : __preference(P,_,_,lit(t,X),_), _holds(X,m2);
                  not _holds(X,m1) : __preference(P,_,_,lit(f,X),_), not _holds(X,m2);
		_volatile(m1,m2).

__required(P,preferredeq) :- __preference(P,superset); __required(P,eq). 
__required(P,worseeq)     :- __preference(P,superset); __required(P,eq). 
#program preference(m1,m2).
__eq(P,m1,m2) :- __preference(P,superset); __required(P,eq); 
         __preferredeq(P,m1,m2); __worseeq(P,m1,m2);
		_volatile(m1,m2).

#program preference(m1,m2).
__worseeq(P,m1,m2) :- __preference(P,superset); __required(P,worseeq); 
              _holds(X,m2) : __preference(P,_,_,lit(t,X),_), _holds(X,m1);
              not _holds(X,m2) : __preference(P,_,_,lit(f,X),_), not _holds(X,m1);
		_volatile(m1,m2).

__required(P,preferredeq) :- __preference(P,superset); __required(P,worse). 
__required(P,worseeq)     :- __preference(P,superset); __required(P,worse). 
#program preference(m1,m2).
__worse(P,m1,m2) :- __preference(P,superset); __required(P,worse); 
            not __preferredeq(P,m1,m2); __worseeq(P,m1,m2);
		_volatile(m1,m2).

__required(P,preferredeq) :- __preference(P,superset); __required(P,unc). 
__required(P,worseeq)     :- __preference(P,superset); __required(P,unc). 
#program preference(m1,m2).
__unc(P,m1,m2) :- __preference(P,superset); __required(P,unc); 
          not __preferredeq(P,m1,m2); not __worseeq(P,m1,m2);
		_volatile(m1,m2).


#program unsat_constraints(m1,m2).
:- not _unsat(m1,m2); _volatile(m1,m2).
_unsat(m1,m2) :- not __preferred(P,m1,m2),  __optimize(P);
		_volatile(m1,m2).

#program base.
_holds(a(X),0):-a(X).
_holds(a(Y),0):-a(Y).



