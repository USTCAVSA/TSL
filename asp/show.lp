#program always.

vehicle_on_lane(A,L) :- is_vehicle(A), is_lane(L), on_lane(A,L).

left_relation(A) :- is_vehicle(A), is_ego(E), A != E, on_lane(A,LA), on_lane(E,LE), left(LA,LE).
right_relation(A) :- is_vehicle(A), is_ego(E), A != E, on_lane(A,LA), on_lane(E,LE), right(LA,LE).
same_lane_relation(A) :- is_vehicle(A), is_ego(E), A != E, on_lane(A,L), on_lane(E,L).
ahead_relation(A) :- is_vehicle(A), is_ego(E), A != E, ahead(A,E).
behind_relation(A) :- is_vehicle(A), is_ego(E), A != E, behind(A,E).
cover_relation(A) :- is_vehicle(A), is_ego(E), A != E, cover(A,E).
ego_on_lane(L) :- is_ego(E), on_lane(E,L).

#show ahead/2.
#show behind/2.
#show cover/2.
#show vehicle_on_lane/2.
#show on_lane/2.
% #show changing_lane_to/2.
% #show finish_lane_changing/3.
% #show keep_lane_changing/3.
% #show abort_lane_changing/3.
#show longitudinal_changed/2.
% #show lateral_dangerous/2.
% #show longitudinal_dangerous/2.
#show left_relation/1.
#show right_relation/1.
#show same_lane_relation/1.
#show ahead_relation/1.
#show behind_relation/1.
#show cover_relation/1.
#show ego_on_lane/1.