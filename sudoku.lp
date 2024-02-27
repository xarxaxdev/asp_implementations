
% Please insert the names and email addresses of the group members:
% Guillem Gili i Bueno guillem.gili.i.bueno@uni-potsdam.de
% Delfina Jovanovich Trakal delfina.jovanovich.trakal@uni-potsdam.de

subgrid_size(3).

% Hints:
% - For subgrid_size(s), subgrids can be identified by labels 0..s*s-1
% - A cell (x,y) can be mapped to the subgrid labeled (((x-1)/s)*s + (y-1)/s)

% Your implementation please...

% Testing solutions: python asp/test.py -e  asp/sudoku.lp -t 100 
% Testing single test: clingo 0 asp/sudoku.lp asp/instances/ex00.lp
number(1..S*S) :- subgrid_size(S).
  3 % Testing solutions: python asp/test.py -e  asp/sudoku.lp -t 100
  2 % Testing single test: clingo 0 asp/sudoku.lp asp/instances/ex00.lp
  1 number(1..S*S) :- subgrid_size(S).
%subgrid(0..S*S-1) :- subgrid_size(S). %initially added this rule, since subgrids are parametrized on number it's unnecessary
sudoku(X,Y,N) :- initial(X,Y,N).

%generate
1{sudoku(X,Y,N): number(N)}1 :- number(X), number(Y).
1{sudoku(X,Y,N): number(X)}1 :- number(N), number(Y).
1{sudoku(X,Y,N): number(Y)}1 :- number(X), number(N).

%Define

subgrid(X,Y,((X-1)/S)*S+(Y-1)/S):- number(X), number(Y), subgrid_size(S).

%Test
:- subgrid(X1,Y1,G), subgrid(X2,Y2,G),sudoku(X1,Y1,N), sudoku(X2,Y2,N), X1!=X2, Y1!=Y2.

% 1 1 2 %example covered in generate but not in the test.
% 3 4 5
% 6 7 8


#show sudoku/3.
