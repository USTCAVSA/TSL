#program always.

vehicle_on_lane(A,L) :- is_vehicle(A), is_lane(L), on_lane(A,L).

#show ahead/2.
% #show behind/2.
#show cover/2.
#show vehicle_on_lane/2.
#show changing_lane_to/2.
% #show finish_lane_changing/3.
% #show keep_lane_changing/3.
% #show abort_lane_changing/3.
#show longitudinal_changed/2.