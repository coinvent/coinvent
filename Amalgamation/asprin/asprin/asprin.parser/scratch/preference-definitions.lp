
% preference files

#program preference.

	% doesn't make sense 
	better(X) :- a(A), 1#count{w1,b:holds'(b,w2),holds(A,w1),c(C)}.

	sum(SUM) :- SUM = #sum{X,a(X)}.

	count(C) :- C = #count{1,a(X)}.

	:- a(X).

	#preference(p1,minimize(weight)){
		1:a.
		2:not b.
		3:c.
	}

