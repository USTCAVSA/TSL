# Example 4 (A vehicle passes two intersection points)

This is the example 4 in our paper. To run this example, please use the following initial configuration:

```prolog
% car.lp
#program always.
is_vehicle(c1).

#program initial.
on_lane(c1,l1).
lonpr(c1,x1,behind).

#program final.
:- not lonpr(c1,x2,ahead).
```

```prolog
% map.lp
#program always.
is_lane(l1;l2;l3).
is_road(r1;r2;r3).
has_lane(r1,l1).
has_lane(r2,l2).
has_lane(r3,l3).
is_cross(x1;x2).
on_lane(x1,l1).
on_lane(x1,l2).
on_lane(x2,l1).
on_lane(x2,l3).
successor(x1,x2,l1).
```

You can create `car.lp` and `map.lp` under the `asp/` folder, then run
```shell
telingo 0 map.lp car.lp rules.lp show.lp
```
You will get 2 answer sets:
```
Answer: 1
 State 0:
  vehicle_on_lane(c1,l1)
  lonpr(c1,x1,behind) lonpr(c1,x2,behind)
 State 1:
  longitudinal_changed(c1,x1)
  vehicle_on_lane(c1,l1)
  lonpr(c1,x1,cover) lonpr(c1,x2,behind)
 State 2:
  longitudinal_changed(c1,x2)
  vehicle_on_lane(c1,l1)
  lonpr(c1,x1,cover) lonpr(c1,x2,cover)
 State 3:
  longitudinal_changed(c1,x1)
  vehicle_on_lane(c1,l1)
  lonpr(c1,x1,ahead) lonpr(c1,x2,cover)
 State 4:
  longitudinal_changed(c1,x2)
  vehicle_on_lane(c1,l1)
  lonpr(c1,x1,ahead) lonpr(c1,x2,ahead)
Answer: 2
 State 0:
  vehicle_on_lane(c1,l1)
  lonpr(c1,x1,behind) lonpr(c1,x2,behind)
 State 1:
  longitudinal_changed(c1,x1)
  vehicle_on_lane(c1,l1)
  lonpr(c1,x1,cover) lonpr(c1,x2,behind)
 State 2:
  longitudinal_changed(c1,x1)
  vehicle_on_lane(c1,l1)
  lonpr(c1,x1,ahead) lonpr(c1,x2,behind)
 State 3:
  longitudinal_changed(c1,x2)
  vehicle_on_lane(c1,l1)
  lonpr(c1,x1,ahead) lonpr(c1,x2,cover)
 State 4:
  longitudinal_changed(c1,x2)
  vehicle_on_lane(c1,l1)
  lonpr(c1,x1,ahead) lonpr(c1,x2,ahead)
SATISFIABLE
```
which are shown in Figure 4d in our paper.