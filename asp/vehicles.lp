#program always.
is_vehicle(ego;car).

#program initial.

on_lane(ego,l1).
on_lane(car,l2).
behind(car,c1).
behind(ego,c1).


#program final.
:- not ahead(ego,c1).
:- not ahead(car,c1).