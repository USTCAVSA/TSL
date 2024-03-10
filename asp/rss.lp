#program always.

% 0{lateral_dangerous(E,C) : is_ego(E), E != C}1 :- is_vehicle(C).
lateral_dangerous(E,C) :- is_ego(E), is_vehicle(C), C != E, on_lane(E,L), on_lane(C,L), is_lane(L).
lateral_dangerous(E,C) :- is_ego(E), is_vehicle(C), C != E, 'on_lane(E,L), on_lane(C,L), is_lane(L).
lateral_dangerous(E,C) :- is_ego(E), is_vehicle(C), C != E, on_lane(E,L), 'on_lane(C,L), is_lane(L).

% 0{longitudinal_dangerous(E,C) : is_ego(E), E != C}1 :- is_vehicle(C).
longitudinal_dangerous(E,C) :- is_ego(E), is_vehicle(C), C != E, cover(C,E).
longitudinal_dangerous(E,C) :- is_ego(E), is_vehicle(C), C != E, 'cover(C,E).

:- lateral_dangerous(E,C), longitudinal_dangerous(E,C), is_ego(E), is_vehicle(C), E != C.

#program dynamic.
:- is_ego(E), is_vehicle(C), C != E, not 'lateral_dangerous(E,C), on_lane(E,L), on_lane(C,L), is_lane(L).
:- is_ego(E), is_vehicle(C), C != E, not 'longitudinal_dangerous(E,C), cover(C,E).