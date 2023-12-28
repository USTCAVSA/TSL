#program always.
is_vehicle(ego).
% cover(ego,f1).

#program initial.

on_lane(ego,l1).
behind(ego,f1).
% cover(ego,f1).


#program final.
:- not ahead(ego,f1).