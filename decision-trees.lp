% Please insert the names and email addresses of the group members:
% Guillem Gili i Bueno, guillem.gili.i.bueno@uni-potsdam.de
% Delfina Jovanovich Trakal, delfina.jovanovich.trakal@uni-potsdam.de

node(1..n).


% Your encoding please...

% TEST:clingo 0 asp/decision-trees.lp asp/instances/instance-02-03.lp
% python asp/test.py -e asp/decision-trees.lp -i asp/instances -s asp/solutions -t 180
% TEST1:
% clingo 0 asp/decision-trees.lp asp/instances/instance-02-03.lp 


%evident solution facts
attribute(1..22).
edge(1,2).edge(1,3).
classified(E,1):- example(E,_).



{decision(X,A):attribute(A)}:- node(X).
{edge(X,Y): node(X)} = 1 :- node(Y), 1<Y.
{edge(X,Y): node(Y)} = 2 :- node(X),decision(X,A) .
X<Y:- edge(X,Y).
Y2-Y1==1:- Y1<Y2,edge(X,Y1),edge(X,Y2).
A1<B1 :- A<B, edge(A,A1), edge(B,B1).
:- decision(X,A),edge(X,Y1),edge(X,Y2),Y1>Y2,
	holds(E,A),classified(E,Y2).
:- node(X), 2 {decision(X,_)}.
:- node(X), not decision(X,_), edge(X,_).



classified(E,Y2):- 
	classified(E,X),
	decision(X,A),holds(E,A),
	edge(X,Y1),edge(X,Y2),Y1<Y2.
classified(E,Y1):- 
	classified(E,X),
	decision(X,A),not holds(E,A),
	edge(X,Y1),edge(X,Y2),Y1<Y2.

{positive(X)}:-	node(X), not decision(X,_).
:- example(E,pos), classified(E,X), not positive(X), not decision(X,_).
:- example(E,neg), classified(E,X), positive(X).

#show edge/2.
#show decision/2.
#show positive/1.
%#show classified/2.
%#show negative/1.
%#show visited/1.
