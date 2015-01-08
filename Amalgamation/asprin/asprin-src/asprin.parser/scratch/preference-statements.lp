% preference files
#program base.
a(Y) :- a(X).
  
pa(X).

a(Y) :- Y = #count{X,b(X):c(X)}.


#optimize(p5).

#preference(t, minimize){
	a(X) :- b(X).	
}.
b(X).
test(XX).
a(X).

#program preference.

	prefp(X) :- optimize(X).
   	
      
	a(X) :- b(X), d(X).
	c(X) :- b(X).
	d(X) :- b(X), a(X).
	b(X) :- c(X).
    

	#preference(p1,minimize(cardinality)){
		
		a.
		not b.
		c.

	}.

	:- not better(X); b(X); holds(Y).

	% comment 
	sum(SUM) :- SUM = #sum{S,A:s(A,S)}.
	count(C) :- C = #count{S,A:c(S), holds'(A)}.
	

	#preference(p2,maximize(weight)){

		1:a.
		2:not b.
		3:c.
	}.

	% preference minimize

	#preference(p3,minimize(subset)) {
		a.
		not b.
		c.
	}.

	#preference(p4,pareto){ name(p1). name(p2). name(p3). }.

	#preference(p5,g){ r > w || m. w > r || f. }.

	%#preference(term,terms){ 1,2,3:a(A) > 2,3:b(A,A,B) > 3:X*Y > 3 || a(X,Y) :- test(A,B). }.
	
	#preference(var,vars){ a(X) > b(Y) || c(X,Y) :- d(X,Y). }.
	
	#preference(weights,w){ 1,2,3:a. }.



