#program dynamic.

% cannot decrease distance if distance is too close
:- occurs(E, dec_distance), distance(VF, E, D), D < 2, is_vehicle(VF), is_ego(E), VF != E, on_lane(VF,L), on_lane(E,L), is_lane(L), is_distance(D).

% cannot cut in if rear car is too close
:- occurs(E, cut_left), distance(E, VR, D), D < 2, is_vehicle(VR), is_ego(E), VR != E, on_lane(VR,L), on_lane(E,L), is_lane(L), is_distance(D).
:- occurs(E, cut_right), distance(E, VR, D), D < 2, is_vehicle(VR), is_ego(E), VR != E, on_lane(VR,L), on_lane(E,L), is_lane(L), is_distance(D).