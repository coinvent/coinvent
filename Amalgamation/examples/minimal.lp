#program base1.

spec(s1).
hasId(s1,0).
hasOp(s1,f,1).
opHasSort(f,value,domain,1).
removableOp(s1,f).
priorityOp(s1,f,1,1).
hasOp(s1,v1,1).
opHasSort(v1,value,domain,1).
removableOp(s1,v1).
priorityOp(s1,v1,1,1).
axiom(0).
axInvolvesPredOpSort(0,f).
axInvolvesPredOpSort(0,v1).
removableAx(s1,0).
priorityAx(s1,0,2,1).
hasAxiom(s1,0,1).
hasSort(s1,value,1).
removableSort(s1,value).
prioritySort(s1,value,1,1).



spec(s2).
hasId(s2,1).
hasOp(s2,f,1).
opHasSort(f,value,domain,1).
removableOp(s2,f).
priorityOp(s2,f,1,1).
hasOp(s2,v2,1).
opHasSort(v2,value,domain,1).
removableOp(s2,v2).
priorityOp(s2,v2,1,1).
axiom(1).
axInvolvesPredOpSort(1,f).
axInvolvesPredOpSort(1,v2).
removableAx(s2,1).
priorityAx(s2,1,4,1).
hasAxiom(s2,1,1).
hasSort(s2,value,1).
removableSort(s2,value).
prioritySort(s2,value,1,1).



