# Example 2 (Intersection)

This is the example 2 in our paper. To run this example, please use the following initial configuration:

```prolog
% car.lp
#program always.
is_vehicle(c1;c2).

#program initial.
on_lane(c1,l1).
on_lane(c2,l2).
lonpr(c1,x1,behind).
lonpr(c2,x1,behind).

#program final.
:- not lonpr(c1,x1,ahead).
:- not lonpr(c2,x1,ahead).
```

```prolog
% map.lp
#program always.

is_road(r1;r2).
is_lane(l1;l2).
has_lane(r1,l1).
has_lane(r2,l2).
is_cross(x1).
on_lane(x1,l1).
on_lane(x1,l2).
```

You can create `car.lp` and `map.lp` under the `asp/` folder, then run
```shell
telingo 0 map.lp car.lp rules.lp show.lp
```
You will get 2 answer sets:
```
Answer: 1
 State 0:
  vehicle_on_lane(c1,l1) vehicle_on_lane(c2,l2)
  lonpr(c1,x1,behind) lonpr(c2,x1,behind)
 State 1:
  vehicle_on_lane(c1,l1) vehicle_on_lane(c2,l2)
  lonpr(c1,x1,cover) lonpr(c2,x1,behind)
 State 2:
  vehicle_on_lane(c1,l1) vehicle_on_lane(c2,l2)
  lonpr(c1,x1,ahead) lonpr(c2,x1,cover)
 State 3:
  vehicle_on_lane(c1,l1) vehicle_on_lane(c2,l2)
  lonpr(c1,x1,ahead) lonpr(c2,x1,ahead)
Answer: 2
 State 0:
  vehicle_on_lane(c1,l1) vehicle_on_lane(c2,l2)
  lonpr(c1,x1,behind) lonpr(c2,x1,behind)
 State 1:
  vehicle_on_lane(c1,l1) vehicle_on_lane(c2,l2)
  lonpr(c1,x1,behind) lonpr(c2,x1,cover)
 State 2:
  vehicle_on_lane(c1,l1) vehicle_on_lane(c2,l2)
  lonpr(c1,x1,cover) lonpr(c2,x1,ahead)
 State 3:
  vehicle_on_lane(c1,l1) vehicle_on_lane(c2,l2)
  lonpr(c1,x1,ahead) lonpr(c2,x1,ahead)
SATISFIABLE
```
which are shown in Figure 4b in our paper.