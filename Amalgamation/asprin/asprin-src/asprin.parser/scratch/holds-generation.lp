
% don't generate holds(ngen(X),0) if head is already holds
holds(X) :- ngen(X).

% generate holds(gen(X),0). <--- think about this one
gen(X) :- holds(X).

b(X) :- a(X), c(X).

agg(SUM) :- SUM = #sum{a(X)} .

% head aggregate 
1{a(X):b(X)}1.

% disjunction doesn't work yet
