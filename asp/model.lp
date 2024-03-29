#program always.

% Distance:
%  0: cover
%  1: 0 ~ length
%  2: length ~ rear_safe_distance
%  3: rear_safe_distance ~ rear_safe_distance + length + ego_safe_distance
%  4: > rear_safe_distance + length + ego_safe_distance
#const max_distance = 2.
is_distance(0..max_distance).

action_of_ego(inc_distance;dec_distance;cut_left;cut_right;keep).
action_of_others(keep).

cover(VF, VR) :- distance(VF, VR, 0).
cover(VR, VF) :- distance(VF, VR, 0).
ahead(VF, VR) :- distance(VF, VR, D), D > 0, is_distance(D).
behind(VR, VF) :- ahead(VF, VR).
right(L1, L2) :- left(L2, L1).

:- 1 != #count{ D : distance(V,V1,D); D : distance(V1,V,D) }, is_vehicle(V), is_vehicle(V1), V != V1.

% aux
left_relation(A) :- is_vehicle(A), is_ego(E), A != E, on_lane(A,LA), on_lane(E,LE), left(LA,LE).
right_relation(A) :- is_vehicle(A), is_ego(E), A != E, on_lane(A,LA), on_lane(E,LE), right(LA,LE).
same_lane_relation(A) :- is_vehicle(A), is_ego(E), A != E, on_lane(A,L), on_lane(E,L).
ahead_relation(A) :- is_vehicle(A), is_ego(E), A != E, ahead(A,E).
behind_relation(A) :- is_vehicle(A), is_ego(E), A != E, behind(A,E).
cover_relation(A) :- is_vehicle(A), is_ego(E), A != E, cover(A,E).
ego_on_lane(L) :- on_lane(E, L), is_ego(E), is_lane(L).

#program dynamic.

:- distance(V1, V2, 0), is_vehicle(V1), is_vehicle(V2), V1 != V2, on_lane(V1, L), on_lane(V2, L), is_lane(L).

changed(distance(VF, VR)) :- distance(VF, VR, D), not 'distance(VF, VR, D), is_distance(D), is_vehicle(VF), is_vehicle(VR).
changed(on_lane(V)) :- on_lane(V,L), not 'on_lane(V,L), is_lane(L), is_vehicle(V).

   
1 { occurs(E, A) : action_of_ego(A) } 1 :- is_ego(E).
1 { occurs(V, A) : action_of_others(A) } 1 :- is_vehicle(V), not is_ego(V).

1 { distance(V,VR,D1) : is_distance(D1), D1 <= D } 1 :- occurs(V, inc_distance), 'distance(V, VR, D), is_vehicle(V), is_vehicle(VR), D > 0.
1 { distance(VF,V,D1) : is_distance(D1), D1 > D } 1 :- occurs(V, inc_distance), 'distance(VF, V, D), is_vehicle(V), is_vehicle(VF), D < max_distance.
distance(VF,V,max_distance) :- occurs(V, inc_distance), 'distance(VF, V, max_distance), is_vehicle(V), is_vehicle(VF).
distance(VR, V, 0) :- occurs(V, inc_distance), is_vehicle(V), is_vehicle(VR), 'distance(V, VR, 0).
on_lane(V, L) :- occurs(V, inc_distance), 'on_lane(V, L), is_vehicle(V), is_lane(L).
:- 0 = #count{ V1 : changed(distance(V,V1)); V1 : changed(distance(V1,V)) } , occurs(V, inc_distance), is_vehicle(V).
:- occurs(V, inc_distance), 'distance(V, VR, D), is_vehicle(V), is_vehicle(VR), D < 2, on_lane(V,L), on_lane(VR,L), is_lane(L).

1 { distance(V,VR,D1) : is_distance(D1), D1 > D } 1 :- occurs(V, dec_distance), 'distance(V, VR, D), is_vehicle(V), is_vehicle(VR), D < max_distance.
1 { distance(VF,V,D1) : is_distance(D1), D1 <= D } 1 :- occurs(V, dec_distance), 'distance(VF, V, D), is_vehicle(V), is_vehicle(VF), D > 0.
distance(V,VR,max_distance) :- occurs(V, dec_distance), 'distance(V, VR, max_distance), is_vehicle(V), is_vehicle(VR).
distance(V, VF, 0) :- occurs(V, dec_distance), is_vehicle(V), is_vehicle(VF), 'distance(VF, V, 0).
on_lane(V, L) :- occurs(V, dec_distance), 'on_lane(V, L), is_vehicle(V), is_lane(L).
:- 0 = #count{ V1 : changed(distance(V,V1)); V1 : changed(distance(V1,V)) } , occurs(V, dec_distance), is_vehicle(V).
:- occurs(V, dec_distance), 'distance(VF, V, D), is_vehicle(V), is_vehicle(VF), D <= 1, on_lane(V,L), on_lane(VF,L), is_lane(L).

on_lane(V, L1) :- occurs(V, cut_left), 'on_lane(V, L), left(L1, L), is_lane(L1), is_lane(L).
distance(VF, V, D) :- occurs(V, cut_left), 'distance(VF, V, D), is_vehicle(V), is_vehicle(VF), is_distance(D).
:- 0 = #count{L1:left(L1,L), is_lane(L1)}, occurs(V, cut_left), 'on_lane(V, L), is_vehicle(V), is_lane(L).

on_lane(V, L1) :- occurs(V, cut_right), 'on_lane(V, L), left(L, L1), is_lane(L1), is_lane(L).
distance(VF, V, D) :- occurs(V, cut_right), 'distance(VF, V, D), is_vehicle(V), is_vehicle(VF), is_distance(D).
:- 0 = #count{L1:left(L,L1), is_lane(L1)}, occurs(V, cut_right), 'on_lane(V, L), is_vehicle(V), is_lane(L).

distance(VF, V, D) :- occurs(V, keep), 'distance(VF, V, D), is_vehicle(V), is_vehicle(VF), is_distance(D), not occurs(VF, dec_distance), not occurs(VF, inc_distance).
on_lane(V, L) :- occurs(V, keep), 'on_lane(V, L), is_vehicle(V), is_lane(L).

#show distance/3.
#show on_lane/2.
#show occurs/2.
% #show ahead/2.
% #show behind/2.
% #show cover/2.
#show left_relation/1.
#show right_relation/1.
#show same_lane_relation/1.
#show ahead_relation/1.
#show behind_relation/1.
#show cover_relation/1.
#show ego_on_lane/1.

% #heuristic occurs(V, keep) : is_vehicle(V), not is_ego(V).  [10,level]
% #heuristic occurs(V, inc_distance) : is_vehicle(V), not is_ego(V).  [5,level]
% #heuristic occurs(V, dec_distance) : is_vehicle(V), not is_ego(V).  [5,level]
% #heuristic occurs(V, cut_left) : is_vehicle(V), not is_ego(V).  [1,level]
% #heuristic occurs(V, cut_right) : is_vehicle(V), not is_ego(V).  [1,level]
