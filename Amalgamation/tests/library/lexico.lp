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
