#program initial.
time_is(0).

#program dynamic.
time_is(T) :- T>0, 'time_is(T-1).

% % only 1 o_car can act
% others_act(V,T) :- occurs(V,A), is_vehicle(V), not is_ego(V), not A = keep, time_is(T).
% % others_act_num(N) :- N = #count{V: others_act(V)}.
% % :- others_act_num(N), N > 1.

% % o_car's act must change ahead/cover/behind/on_lane
% longitudinal_relation_changed(V) :- is_vehicle(V), not 'ahead(V, V1), ahead(V, V1), is_vehicle(V1).
% longitudinal_relation_changed(V) :- is_vehicle(V), not 'behind(V, V1), behind(V, V1), is_vehicle(V1).
% longitudinal_relation_changed(V) :- is_vehicle(V), not 'cover(V, V1), cover(V, V1), is_vehicle(V1).
% :- occurs(V,inc_distance), is_vehicle(V), not is_ego(V), not longitudinal_relation_changed(V).
% :- occurs(V,dec_distance), is_vehicle(V), not is_ego(V), not longitudinal_relation_changed(V).

% % cannot execute inc/dec twice
% :- occurs(V,inc_distance), 'occurs(V,inc_distance), is_vehicle(V), not is_ego(V), not 'distance(V, VR, 0), is_vehicle(VR).
% :- occurs(V,dec_distance), 'occurs(V,dec_distance), is_vehicle(V), not is_ego(V), not 'distance(VF, V, 0), is_vehicle(VF).

next_occurs_ego(A) :- occurs(E, A), is_ego(E), time_is(1).
next_distance_ego(E, VR, D) :- distance(E, VR, D), is_ego(E), is_vehicle(VR), time_is(1).
next_distance_ego(VF, E, D) :- distance(VF, E, D), is_ego(E), is_vehicle(VF), time_is(1).
next_on_lane_ego(L) :- on_lane(E,L), is_ego(E), time_is(1).

next_occurs_ego(A) :- 'next_occurs_ego(A).
next_distance_ego(E, V, D) :- 'next_distance_ego(E, V, D).
next_on_lane_ego(L) :- 'next_on_lane_ego(L).


#program final.
% others_act_count(N) :- N = #count{V,T: others_act(V, T)}.
% :- others_act_count(N), N > 1.

#program always.
#project next_occurs_ego/1.
#project next_distance_ego/3.
#project next_on_lane_ego/1.
#show next_occurs_ego/1.
#show next_distance_ego/3.
#show next_on_lane_ego/1.
% #project left_relation/1.
% #project right_relation/1.
% #project same_lane_relation/1.
% #project ahead_relation/1.
% #project behind_relation/1.
% #project cover_relation/1.
% #project ego_on_lane/1.