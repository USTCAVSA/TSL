# Example 3 (Connecting Roads)

This is the example 3 in our paper. To run this example, please use the following initial configuration:

```prolog
% car.lp
#program always.
is_vehicle(c1).

#program initial.
on_lane(c1,l1).
lonpr(c1,f1,behind).

#program final.
:- not lonpr(c1,f1,ahead).
```

```prolog
% map.lp
#program always.
is_lane(l1;l2;l3).
is_road(r1;r2;r3).
has_lane(r1,l1).
has_lane(r2,l2).
has_lane(r3,l3).
is_fork(f1).
on_lane(f1,l1).
on_lane(f1,l2).
on_lane(f1,l3).
successor(l1,f1).
successor(f1,l2).
successor(f1,l3).
```

You can create `car.lp` and `map.lp` under the `asp/` folder, then run
```shell
telingo 0 map.lp car.lp rules.lp show.lp
```
You will get 2 answer sets:
```
Answer: 1
 State 0:
  debug1
  vehicle_on_lane(c1,l1)
  lonpr(c1,f1,behind)
 State 1:
  debug1
  vehicle_on_lane(c1,l1) vehicle_on_lane(c1,l2) vehicle_on_lane(c1,l3)
  lonpr(c1,f1,cover)
 State 2:
  vehicle_on_lane(c1,l2)
  lonpr(c1,f1,ahead)
Answer: 2
 State 0:
  debug1
  vehicle_on_lane(c1,l1)
  lonpr(c1,f1,behind)
 State 1:
  debug1
  vehicle_on_lane(c1,l1) vehicle_on_lane(c1,l2) vehicle_on_lane(c1,l3)
  lonpr(c1,f1,cover)
 State 2:
  vehicle_on_lane(c1,l3)
  lonpr(c1,f1,ahead)
SATISFIABLE
```
which are shown in Figure 4c in our paper.