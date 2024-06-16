#program always.

% Symmetric predicates
right(A,B) :- left(B,A).
left(A,B) :- right(B,A).
lonr(A,B,behind) :- lonr(B,A,ahead).
lonr(A,B,ahead) :- lonr(B,A,behind).
lonr(A,B,cover) :- lonr(B,A,cover).
lonro(A,B,behind) :- lonro(B,A,ahead).
lonro(A,B,ahead) :- lonro(B,A,behind).
lonro(A,B,cover) :- lonro(B,A,cover).
successor(A,B) :- predecessor(B,A).
predecessor(A,B) :- successor(B,A).
successor(A,B,L) :- predecessor(B,A,L).
predecessor(A,B,L) :- successor(B,A,L).

:- left(A,B), right(A,B).
:- lonr(A,B,behind), lonr(A,B,ahead).
:- successor(A,B), predecessor(A,B).

% auxiliary predicate on_road/2
on_road(A,R) :- is_lane(L), is_road(R), on_lane(A,L), has_lane(R,L).

% auxiliary predicate forking/1
forking(A) :- is_vehicle(A), is_fork(F), lonpr(A,F,cover).

% auxiliary predicate neighbor_lane/2
neighbor_lane(L1,L2) :- is_lane(L1), is_lane(L2), left(L1,L2).
neighbor_lane(L1,L2) :- is_lane(L1), is_lane(L2), right(L1,L2).

% auxiliary predicate is_point/1
is_point(A) :- is_cross(A).
is_point(A) :- is_fork(A).
is_point(A) :- is_overlap(A).

% constraint: vehicles cannot cover on the same lane
:- is_vehicle(A), is_vehicle(B), on_lane(A,L), on_lane(B,L), A != B, lonr(A,B,cover).

% Exclusivity of longitudinal relationships
% Any two vehicles on the same road and same/adjacent lane(s) must have a unique longitudinal relationship
% 1{ ahead(A,B); behind(A,B); cover(A,B) }1 :- is_vehicle(A), is_vehicle(B), A != B, on_road(A,R), on_road(B,R), is_road(R).
1{ lonr(A,B,ahead); lonr(A,B,behind); lonr(A,B,cover) }1 :- is_vehicle(A), is_vehicle(B), A != B, on_road(A,R), on_road(B,R), is_road(R), on_lane(A,L1), on_lane(B,L2), neighbor_lane(L1,L2).
1{ lonr(A,B,ahead); lonr(A,B,behind) }1 :- is_vehicle(A), is_vehicle(B), A != B, on_road(A,R), on_road(B,R), is_road(R), on_lane(A,L), on_lane(B,L), is_lane(L).
% The vehicle on this lane and the intersection on this lane must have a unique longitudinal relationship
1{ lonpr(A,C,ahead); lonpr(A,C,behind); lonpr(A,C,cover) }1 :- is_vehicle(A), is_cross(C), is_lane(L), on_lane(A,L), on_lane(C,L).
% The vehicle must have a relationship with the point on the same road
1{ lonpr(A,P,ahead); lonpr(A,P,behind); lonpr(A,P,cover) }1 :- is_vehicle(A), is_point(P), on_road(A,R), on_road(P,R).

% Transitivity of longitudinal relationships of vehicles
lonr(A,B,ahead) :- lonr(A,C,ahead), lonr(C,B,ahead), A != B, B != C, A != C, on_road(A,R), on_road(B,R), on_road(C,R).
lonr(A,B,behind) :- lonr(A,C,behind), lonr(C,B,behind), A != B, B != C, A != C, on_road(A,R), on_road(B,R), on_road(C,R).
:- lonr(A,B,ahead), lonr(B,C,cover), lonr(C,A,ahead), A != B, B != C, A != C.
:- lonr(A,B,cover), lonr(B,C,ahead), lonr(C,A,ahead), A != B, B != C, A != C.

% Transitivity of longitudinal relationships of points
lonr(A,B,ahead) :- lonpr(A,C,ahead), lonpr(B,C,behind), A != B, on_road(A,R), on_road(B,R), on_road(C,R).
lonr(A,B,behind) :- lonpr(A,C,behind), lonpr(B,C,ahead), A != B, on_road(A,R), on_road(B,R), on_road(C,R).
lonpr(A,P,ahead) :- lonr(A,B,ahead), lonpr(B,P,cover), A != B, is_vehicle(A), is_vehicle(B), is_point(P).
lonpr(A,P,behind) :- lonr(A,B,behind), lonpr(B,P,cover), A != B, is_vehicle(A), is_vehicle(B), is_point(P).

% point's successor and predecessor
lonpr(A,P2,behind) :- is_vehicle(A), is_point(P1), is_point(P2), on_lane(A,L), lonpr(A,P1,behind), successor(P1,P2,L).
:- is_vehicle(A), is_point(P1), is_point(P2), on_lane(A,L), lonpr(A,P1,cover), successor(P1,P2,L), lonpr(A,P2,ahead).
lonpr(A,P2,ahead) :- is_vehicle(A), is_point(P1), is_point(P2), on_lane(A,L), lonpr(A,P1,ahead), predecessor(P1,P2,L).
:- is_vehicle(A), is_point(P1), is_point(P2), on_lane(A,L), lonpr(A,P1,cover), predecessor(P1,P2,L), lonpr(A,P2,behind).

% % Longitudinal relationship of fork points
% ahead(A,F):- ahead(A,B), cover(B,F), is_fork(F), is_vehicle(A), is_vehicle(B).


% When not forking, the multiple lanes occupied must be adjacent
:- on_lane(A,L1), on_lane(A,L2), L1 != L2, not left(L1,L2), not left(L2,L1), is_lane(L1), is_lane(L2), is_vehicle(A), not forking(A).
% When covering a fork, it must be on_lane all lanes where the fork is located
on_lane(A,L) :- is_vehicle(A), is_fork(F), on_lane(F,L), lonpr(A,F,cover).

% rules for overlapping lanes
fwdover(C,P1,P2) :- lonpr(C,P1,ahead), lonpr(C,P2,behind), is_vehicle(C), is_overlap(P1), is_overlap(P2), overlap(P1,P2), on_lane(C,L), on_lane(P1,L), on_lane(P2,L).
rvsover(C,P1,P2) :- lonpr(C,P1,behind), lonpr(C,P2,ahead), is_vehicle(C), is_overlap(P1), is_overlap(P2), overlap(P1,P2), on_lane(C,L), on_lane(P1,L), on_lane(P2,L).
lonro(C1,C2,ahead) :- fwdover(C1,P1,P2), fwdover(C2,P1,P2), is_vehicle(C1), is_vehicle(C2), lonr(C1,C2,ahead).
lonro(C1,C2,behind) :- fwdover(C1,P1,P2), fwdover(C2,P1,P2), is_vehicle(C1), is_vehicle(C2), lonr(C1,C2,behind).
lonro(C1,C2,cover) :- fwdover(C1,P1,P2), fwdover(C2,P1,P2), is_vehicle(C1), is_vehicle(C2), lonr(C1,C2,cover).
lonro(C1,C2,ahead) :- rvsover(C1,P1,P2), rvsover(C2,P1,P2), is_vehicle(C1), is_vehicle(C2), lonr(C1,C2,behind).
lonro(C1,C2,behind) :- rvsover(C1,P1,P2), rvsover(C2,P1,P2), is_vehicle(C1), is_vehicle(C2), lonr(C1,C2,ahead).
lonro(C1,C2,cover) :- rvsover(C1,P1,P2), rvsover(C2,P1,P2), is_vehicle(C1), is_vehicle(C2), lonr(C1,C2,cover).
1{ lonro(C1,C2,ahead); lonro(C1,C2,behind); lonro(C1,C2,cover) }1 :- is_vehicle(C1), is_vehicle(C2), C1 != C2, fwdover(C1,P1,P2), rvsover(C2,P1,P2).
:- lonro(C1,C2,cover), is_vehicle(C1), is_vehicle(C2), C1 != C2.

% behind or cover fork point when on the predecessor lane
% 1{behind(A,F); cover(A,F)}1 :- is_fork(F), is_vehicle(A), predecessor(F,L), not not on_lane(A,L).
1{lonpr(A,F,behind); lonpr(A,F,cover)}1 :- is_fork(F), is_vehicle(A), predecessor(F,L), on_lane(A,L).
% ahead or cover fork point when on the successor lane
% 1{ahead(A,F); cover(A,F)}1 :- is_fork(F), is_vehicle(A), successor(F,L), not not on_lane(A,L).
1{lonpr(A,F,ahead); lonpr(A,F,cover)}1 :- is_fork(F), is_vehicle(A), successor(F,L), on_lane(A,L).

#program dynamic.

% % lane changing target
% changing_lane_to(A,L2) :- is_vehicle(A), is_lane(L1), is_lane(L2), L1 != L2, on_lane(A,L1), on_lane(A,L2), 'on_lane(A,L1), not 'on_lane(A,L2), not forking(A).
% 1{finish_lane_changing(A, L1, L2); keep_lane_changing(A, L1, L2); abort_lane_changing(A, L1, L2)}1 :- is_vehicle(A), is_lane(L1), is_lane(L2), L1 != L2, 'on_lane(A,L1), 'on_lane(A,L2), 'changing_lane_to(A,L2).
% on_lane(A,L2) :- finish_lane_changing(A, L1, L2).
% -on_lane(A,L1) :- finish_lane_changing(A, L1, L2).

% on_lane(A,L1) :- keep_lane_changing(A, L1, L2).
% on_lane(A,L2) :- keep_lane_changing(A, L1, L2).
% changing_lane_to(A,L2) :- keep_lane_changing(A, L1, L2).

% on_lane(A,L1) :- abort_lane_changing(A, L1, L2).
% on_lane(A,L2) :- abort_lane_changing(A, L1, L2).
% changing_lane_to(A,L1) :- abort_lane_changing(A, L1, L2).

% auxiliary predicate longitudinal_changed/2
longitudinal_changed(A,B) :- lonr(A,B,ahead), 'lonr(A,B,cover).
longitudinal_changed(A,B) :- lonr(A,B,behind), 'lonr(A,B,cover).
longitudinal_changed(A,B) :- lonr(A,B,cover), not 'lonr(A,B,cover).
longitudinal_changed(A,B) :- not lonr(A,B,cover), 'lonr(A,B,cover).
longitudinal_changed(A,P) :- lonpr(A,P,ahead), 'lonpr(A,P,cover).
longitudinal_changed(A,P) :- lonpr(A,P,behind), 'lonpr(A,P,cover).
longitudinal_changed(A,P) :- lonpr(A,P,cover), not 'lonpr(A,P,cover).
longitudinal_changed(A,P) :- not lonpr(A,P,cover), 'lonpr(A,P,cover).
longitudinal_changed(A,B) :- lonro(A,B,ahead), 'lonro(A,B,cover).
longitudinal_changed(A,B) :- lonro(A,B,behind), 'lonro(A,B,cover).
longitudinal_changed(A,B) :- lonro(A,B,cover), not 'lonro(A,B,cover).
longitudinal_changed(A,B) :- not lonro(A,B,cover), 'lonro(A,B,cover).

% When not forking, it can only occupy 1 to 2 lanes
% TODO: It may occupy 3 or more lanes, whether to consider (prohibit continuous lane change?)
1{ on_lane(A,L) : is_lane(L) }2 :- is_vehicle(A), not forking(A).

% while forking, can occupy at most one adjacent lane of each branch lane 
0{on_lane(A,L2) : is_lane(L2), neighbor_lane(L1,L2)}1 :- is_vehicle(A), lonpr(A,F,cover), is_fork(F), is_lane(L1), on_lane(A,L1), on_lane(F,L1).

0{on_lane(A,L)}1 :- is_vehicle(A), 'on_lane(A,L).

% cannot skip the cover state
:- lonr(A,B,ahead), 'lonr(A,B,behind).
:- lonr(A,B,behind), 'lonr(A,B,ahead).
:- lonpr(A,P,ahead), 'lonpr(A,P,behind).
:- lonpr(A,P,behind), 'lonpr(A,P,ahead).
:- lonro(A,B,ahead), 'lonro(A,B,behind).
:- lonro(A,B,behind), 'lonro(A,B,ahead).

% each step only one longitudinal relationship can be changed for each vehicle
:- longitudinal_changed(A,B), longitudinal_changed(A,C), B != C, is_vehicle(A).

% only one fork point can be covered for each vehicle
% TODO: remove this constraint?
% :- cover(A,F1), cover(A,F2), is_vehicle(A), is_fork(F1), is_fork(F2), F1 != F2.

% cannot go backward wrt. a point
:- is_vehicle(A), is_point(P), 'lonpr(A,P,ahead), lonpr(A,P,cover).
:- is_vehicle(A), is_point(P), 'lonpr(A,P,cover), lonpr(A,P,behind).

% lane occupancy rules for lane transition
% only adjacent lanes can be transited to while not forking
:- on_lane(A,L2), 'on_lane(A,L1), not left(L1,L2), not left(L2,L1), is_vehicle(A), is_lane(L1), is_lane(L2), L1 != L2, not forking(A), not 'forking(A).
% cannot skip the state of occupying two lanes
:- on_lane(A,L2), 'on_lane(A,L1), not 'on_lane(A,L2), not on_lane(A,L1), is_vehicle(A), is_lane(L1), is_lane(L2), L1 != L2.

% point rules
% only one car at a point
:- lonpr(A,P,cover), lonpr(B,P,cover), is_vehicle(A), is_vehicle(B), is_point(P), A != B.

% fork point rules
% drive to the next lane after forking
&tel{ (lonpr(A,F,cover) >? lonpr(A,F,ahead)) | (>* lonpr(A,F,cover)) } :- is_vehicle(A), is_fork(F), lonpr(A,F,cover).

% overlap: cannot skip the cover state
:- lonro(A,B,ahead), 'lonro(A,B,behind).
:- lonro(A,B,behind), 'lonro(A,B,ahead).