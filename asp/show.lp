#program always.

vehicle_on_lane(A,L) :- is_vehicle(A), is_lane(L), on_lane(A,L).

#show lonr/3.
#show lonpr/3.
#show lonro/3.
#show vehicle_on_lane/2.
% #show changing_lane_to/2.
% #show finish_lane_changing/3.
% #show keep_lane_changing/3.
% #show abort_lane_changing/3.
% #show longitudinal_changed/2.
#show rvsover/3.
#show fwdover/3.
% #show on_lane/2.
% #show on_road/2.