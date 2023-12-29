#program always.
is_vehicle(ego;car1;car2).

#program initial.

on_lane(ego,l1).
behind(ego,c1).

on_lane(car1,l2).
behind(car1,c1).

on_lane(car2,l3).
behind(car2,c2).


#program final.
:- not ahead(ego,c2).
:- not ahead(car1,c1).
:- not ahead(car2,c2).