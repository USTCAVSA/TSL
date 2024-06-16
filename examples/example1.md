# Example 1 (Highway Scenario)

This is the example 1 in our paper. To run this example, please use the following initial configuration:

```prolog
% car.lp
#program always.
is_vehicle(c1;c2).

#program initial.
on_lane(c1,l2).
on_lane(c2,l2).
lonr(c1,c2,behind).

#program final.
:- lonr(c2,c1,ahead).
```

```prolog
% map.lp
#program always.

is_road(r1).
is_lane(l1;l2).
has_lane(r1,l1).
has_lane(r1,l2).
left(l1,l2).
```

You can create `car.lp` and `map.lp` under the `asp/` folder, then run
```shell
telingo 0 map.lp car.lp rules.lp show.lp
```
You will get 4 answer sets:
```
Answer: 1
 State 0:
  vehicle_on_lane(c1,l2) vehicle_on_lane(c2,l2)
  lonr(c1,c2,behind) lonr(c2,c1,ahead)
 State 1:
  vehicle_on_lane(c1,l1) vehicle_on_lane(c1,l2) vehicle_on_lane(c2,l2)
  lonr(c1,c2,behind) lonr(c2,c1,ahead)
 State 2:
  longitudinal_changed(c1,c2) longitudinal_changed(c2,c1)
  vehicle_on_lane(c1,l1) vehicle_on_lane(c2,l2)
  lonr(c1,c2,cover) lonr(c2,c1,cover)
Answer: 2
 State 0:
  vehicle_on_lane(c1,l2) vehicle_on_lane(c2,l2)
  lonr(c1,c2,behind) lonr(c2,c1,ahead)
 State 1:
  vehicle_on_lane(c1,l1) vehicle_on_lane(c1,l2) vehicle_on_lane(c2,l1) vehicle_on_lane(c2,l2)
  lonr(c1,c2,behind) lonr(c2,c1,ahead)
 State 2:
  longitudinal_changed(c1,c2) longitudinal_changed(c2,c1)
  vehicle_on_lane(c1,l1) vehicle_on_lane(c2,l2)
  lonr(c1,c2,cover) lonr(c2,c1,cover)
Answer: 3
 State 0:
  vehicle_on_lane(c1,l2) vehicle_on_lane(c2,l2)
  lonr(c1,c2,behind) lonr(c2,c1,ahead)
 State 1:
  vehicle_on_lane(c1,l1) vehicle_on_lane(c1,l2) vehicle_on_lane(c2,l1) vehicle_on_lane(c2,l2)
  lonr(c1,c2,behind) lonr(c2,c1,ahead)
 State 2:
  longitudinal_changed(c1,c2) longitudinal_changed(c2,c1)
  vehicle_on_lane(c1,l2) vehicle_on_lane(c2,l1)
  lonr(c1,c2,cover) lonr(c2,c1,cover)
Answer: 4
 State 0:
  vehicle_on_lane(c1,l2) vehicle_on_lane(c2,l2)
  lonr(c1,c2,behind) lonr(c2,c1,ahead)
 State 1:
  vehicle_on_lane(c1,l2) vehicle_on_lane(c2,l1) vehicle_on_lane(c2,l2)
  lonr(c1,c2,behind) lonr(c2,c1,ahead)
 State 2:
  longitudinal_changed(c1,c2) longitudinal_changed(c2,c1)
  vehicle_on_lane(c1,l2) vehicle_on_lane(c2,l1)
  lonr(c1,c2,cover) lonr(c2,c1,cover)
SATISFIABLE
```
which are shown in Figure 4a in our paper.