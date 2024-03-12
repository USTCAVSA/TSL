#program dynamic.

% Must increase distance if distance < 3 between ego and front car
occurs(ego, inc_distance) :- distance(VF, E, D), D < 3, is_vehicle(VF), is_vehicle(E), VF != E, on_lane(VF,L), on_lane(E,L), is_lane(L), is_distance(D).
