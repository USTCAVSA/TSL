#program always.

% Symmetric predicates
right(A,B) :- left(B,A).
left(A,B) :- right(B,A).
behind(A,B) :- ahead(B,A).
ahead(A,B) :- behind(B,A).
cover(A,B) :- cover(B,A).

:- left(A,B), right(A,B).
:- behind(A,B), ahead(A,B).

% auxiliary predicate on_road/2
on_road(A,R) :- is_vehicle(A), is_lane(L), is_road(R), on_lane(A,L), has_lane(R,L).

% auxiliary predicate neighbor_lane/2
neighbor_lane(L1,L2) :- is_lane(L1), is_lane(L2), left(L1,L2).
neighbor_lane(L1,L2) :- is_lane(L1), is_lane(L2), right(L1,L2).

% constraint: vehicles cannot cover on the same lane
:- is_vehicle(A), is_vehicle(B), on_lane(A,L), on_lane(B,L), A != B, cover(A,B).

% Exclusivity of longitudinal relationships
% Any two vehicles on the same road must have a unique longitudinal relationship
1{ ahead(A,B); behind(A,B); cover(A,B) }1 :- is_vehicle(A), is_vehicle(B), A != B, on_road(A,R), on_road(B,R), is_road(R).
% 1{ ahead(A,B); behind(A,B); cover(A,B) }1 :- is_ego(A), is_vehicle(B), A != B, on_road(A,R), on_road(B,R), is_road(R).
% 1{ ahead(A,B); behind(A,B) }1 :- is_ego(A), is_vehicle(B), A != B, on_road(A,R), on_road(B,R), is_road(R), on_lane(A,L), on_lane(B,L), is_lane(L).

% Transitivity of longitudinal relationships
% at least one of them is a vehicle
ahead(A,B) :- ahead(A,C), ahead(C,B), A != B, B != C, A != C, not &tel{~ is_vehicle(A) & ~ is_vehicle(B)}.
behind(A,B) :- behind(A,C), behind(C,B), A != B, B != C, A != C, not &tel{~ is_vehicle(A) & ~ is_vehicle(B)}.
:- ahead(A,B), cover(B,C), ahead(C,A), A != B, B != C, A != C.
:- cover(A,B), ahead(B,C), ahead(C,A), A != B, B != C, A != C.

#program dynamic.

% auxiliary predicate longitudinal_changed/2
% longitudinal_changed(A,B) :- ahead(A,B), not 'ahead(A,B).
% longitudinal_changed(A,B) :- behind(A,B), not 'behind(A,B).
% longitudinal_changed(A,B) :- cover(A,B), not 'cover(A,B).
% longitudinal_changed(A,B) :- ahead(A,B), 'cover(A,B).
% longitudinal_changed(A,B) :- behind(A,B), 'cover(A,B).
% longitudinal_changed(A,B) :- cover(A,B), not 'cover(A,B).
% longitudinal_changed(A,B) :- not cover(A,B), 'cover(A,B).

% can only occupy 1 lane
1{ on_lane(A,L) : is_lane(L) }1 :- is_vehicle(A).

0{on_lane(A,L)}1 :- is_vehicle(A), 'on_lane(A,L).

% cannot skip the cover state
:- ahead(A,B), 'behind(A,B).
:- behind(A,B), 'ahead(A,B).

ahead(A,B) :- 'ahead(A,B), not is_ego(A), not is_ego(B).
behind(A,B) :- 'behind(A,B), not is_ego(A), not is_ego(B).
cover(A,B) :- 'cover(A,B), not is_ego(A), not is_ego(B).

% each step only one longitudinal relationship can be changed for each vehicle
% :- longitudinal_changed(A,B), longitudinal_changed(A,C), B != C, is_ego(E).

% lane occupancy rules for lane transition
% only adjacent lanes can be transited to
:- on_lane(A,L2), 'on_lane(A,L1), not left(L1,L2), not left(L2,L1), is_vehicle(A), is_lane(L1), is_lane(L2), L1 != L2.
