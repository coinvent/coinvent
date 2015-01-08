
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


%
% PREFERENCE STATEMENTS
%

#optimize(p5).

#preference(p1,subset){
  a(X) :- gr(X).
}.

#preference(p2,less(cardinality)){
  b(X) :- gr(X).
}.

#preference(p3,lexico){
 2: name(p1).
 1: name(p2).
}.

#preference(p4,qpref){
  a(X) :- gr(X).
  a(X) > a(Y) :- gr(X), gr(Y), X = Y - 1.
}.

#preference(p5,aso){
  a(X) > a(Y) :- gr(X), gr(Y), X = Y - 1.
}.

#preference(p6,neg){
 name(p5).
}.


%
% tproject and fproject definition 
% must be #shown to compute many preferred models
%
tproject(m(X)) :- m(X).
fproject(m(X)) :- not m(X); X=1..3.
#show tproject/1.
#show fproject/1.

