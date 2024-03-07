% make sure all state transition is complete
#program dynamic.
 
% used to find the maximum step
on_lane(C,L) :- is_vehicle(C), not is_ego(C), _on_lane(C,L).


#program final.
:- is_ego(E), is_vehicle(V), E != V, ahead(V,E).