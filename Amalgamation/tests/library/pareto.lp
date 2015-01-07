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

