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
