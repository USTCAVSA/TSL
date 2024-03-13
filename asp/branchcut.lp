#program dynamic.

% Each step only one o_car can act
others_act(V) :- occurs(V,A), is_vehicle(V), not is_ego(V), not A = keep.
others_act_num(N) :- N = #count{V: others_act(V)}.
:- others_act_num(N), N > 1.

% o_car's act must change ahead/cover/behind/on_lane
longitudinal_relation_changed(V) :- is_vehicle(V), not 'ahead(V, V1), ahead(V, V1), is_vehicle(V1).
longitudinal_relation_changed(V) :- is_vehicle(V), not 'behind(V, V1), behind(V, V1), is_vehicle(V1).
longitudinal_relation_changed(V) :- is_vehicle(V), not 'cover(V, V1), cover(V, V1), is_vehicle(V1).
:- occurs(V,inc_distance), is_vehicle(V), not is_ego(V), not longitudinal_relation_changed(V).
:- occurs(V,dec_distance), is_vehicle(V), not is_ego(V), not longitudinal_relation_changed(V).

% cannot execute inc/dec twice
:- occurs(V,inc_distance), 'occurs(V,inc_distance), is_vehicle(V), not 'distance(V, VR, 0), is_vehicle(VR).
:- occurs(V,dec_distance), 'occurs(V,dec_distance), is_vehicle(V), not 'distance(VF, V, 0), is_vehicle(VF).
