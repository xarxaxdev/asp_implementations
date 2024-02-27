% Please insert the names and email addresses of the group members:
% Guillem Gili i Bueno: giliibueno@potsdam-uni.de

%
% Input:
%   #const n: the time steps range from 0 to n
%   edge(N1,N2): there is an (undirected) edge between nodes N1 and N2
%   robot(R,C,N): robot R is of class C and starts at node N
%   job(J,C,D): job J is of class C and its deadline is D 
%   operation(J,O,N): J's operation O takes place at node N (O >= 1)
%
% Output:
%   at(R,N,T): robot R is at node N at time step T
%   assign(R,J,I): assign to R the job J at index I (in the sequence of jobs assigned to R) (I >= 1)
%

time(0..n).

% Your encoding please...


% Testing solutions: 
% python asp/test.py -e asp/robots.lp -i asp/instances -s asp/solutions -t 180 -opt
% Testing single test: 
% clingo 3 asp/robots.lp asp/instances/grid-03.lp --opt-mode=optN 0

% OBVIOUS IMPLICATIONS
edge(N1,N2) :- edge(N2,N1).%edges are bidirectional
at(R,N,0) :- robot(R,_,N).% The first at is where the robots begin in.


% ASSIGNING JOBS
%Problem description guarantees I>= 1.
{assign(R,J,1): job(J,C,_) }1 :-   robot(R,C,_) . %  There can only be one first task per robot
%jobs(C):- N=#count{J:job(J,_,_)}.% This as a constant looks cleaner
jobs(C,N):- job(_,C,_),N=#count{J:job(J,C,_)}.% This as a constant looks cleaner
:- assign(R1 ,J,I1), assign(R2,J,I2),(R1,I1)!=(R2,I2).% same job cannot be done twice
:- job(J,_,_), not assign(_,J,_).% A job unassigned is not a solution
:- assign(R,J1,I),assign(R,J2,I), J1!=J2.% There cannot be 2 assigns on the I on a robot
{assign(R,J2,I+1)} :- 
	%jobs(N),I<N, %Controlling recursion
	jobs(C,N),I<N, %Controlling recursion
	job(J2,C,_),robot(R,C,_),% Given a robot and a job 
	assign(R,J1,I). % There is a Ith assignment



% MOVEMENT CODE
%robot movement generation. They stay in the same position or move adjacently
{at(R,N2,T): edge(N1,N2);at(R,N1,T)}=1 :- at(R,N1,T-1),time(T).
:- at(R1,N,T),at(R2,N,T),R1!= R2. % No collisions
:- at(R1,N1,T), at(R1,N2,T+1),not edge(N1,N2),N1!= N2. % No teleporting
%This rule seems redundant, but it speeds up a lot the corridor-04 case, 
% without it takes 3 seconds, with it less than 1s
move(N1,N2,T):- at(R,N1,T),at(R,N2,T+1),edge(N1,N2).
:- move(N1,N2,T), move(N2,N1,T).
%:- at(R1,N1,T), at(R2,N2,T), at(R1,N2,T+1), at(R2,N1, T+1),R1!=R2,N1!=N2. %No swapping




%DO ALL OPERATIONS GET DONE?
%we create the done(J,O,T). Operation O of job J is done at T.
operations(J,C) :-job(J,_,_),C = #count{O:operation(J,O,N)}.

% A job is done when its last  operation is done
done_job(J,T):- done_job(J,T-1),time(T).
done_job(J,T):- done(J,C,T), operations(J,C).

% Test whether its previous job was finished BEFORE
%done_job_prev(R,J2,T):- assign(R,J2,I),assign(R,J1,I-1) ,done_job(J1,T-1).


done(J,O,T) :- done(J,O,T-1),time(T).
% An operation is done at a time T when:
done(J,O,T):-
	%The previous assigned job is done or this is the first job
	assign(R,J,I),
	{I==1;done_job(J1,T-1): assign(R,J1,I-1)}=1,
	%The robot that it is assigned to it is in the position necessary in time T. 
	operation(J,O,N),at(R,N,T), 
	%T is not beyond the deadline of the job
	job(J,_,D),D>=T,
	%The previous operation is done(or this is the first operation)
	{O==1;done(J,O-1,T-1)}=1. 

%:- job(J,O,_),not done_job(J,_). % All operations for all jobs must be done
:- operation(J,O,N),not done(J,O,_). % All operations for all jobs must be done



% ONLY OPTIMAL PATHS
%cost(R,T):- at(R,N2,T+1),at(R,N1,T),edge(N1,N2). 
%#minimize{1@1,(N,T):cost(R,T) }.
%:~ at(R,N2,T+1),at(R,N1,T),N1!=N2. [1]

#minimize{1@1,(N,T):move(N,_,T) }.
%:~ move(N,N2,T). [1]
%#show count/1.
%#show cost/4.
%#show error/2.
#show at/3.
#show assign/3.


