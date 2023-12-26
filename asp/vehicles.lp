#program always.
is_vehicle(ego;car).

#program initial.
% | : car : |
% | : ego : |
on_lane(ego,l2).
on_lane(car,l2).
ahead(ego,car).

#program final.
ahead(car,ego).