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
      
