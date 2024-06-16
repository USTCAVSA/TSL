# Example 5 (Overtake on the opposite side)

This is the example 5 in our paper. To run this example, please use the following initial configuration:

```prolog
% car.lp
#program always.
is_vehicle(c1;c2;c3).
on_lane(c2,l1).
:- on_lane(c2,l2).
lonpr(c1,p1,ahead).
lonpr(c1,p2,behind).
lonpr(c2,p2,behind).
lonpr(c2,p1,ahead).
lonpr(c3,p2,ahead).
lonpr(c3,p1,behind).

#program initial.
on_lane(c1,l1).
on_lane(c2,l1).
on_lane(c3,l3).
lonr(c2,c1,ahead).

#program final.
lonr(c1,c2,ahead).
:- on_lane(c1,l2).
```

```prolog
% map.lp
#program always.
is_lane(l1;l2;l3).
is_road(r1;r2).
has_lane(r1,l1).
has_lane(r1,l2).
has_lane(r2,l3).
is_overlap(p1;p2).
on_lane(p1,l2).
on_lane(p1,l3).
on_lane(p2,l2).
on_lane(p2,l3).
left(l2,l1).
successor(p1,p2,l2).
successor(p2,p1,l3).
overlap(p1,p2).
```

You can create `car.lp` and `map.lp` under the `asp/` folder, then run
```shell
telingo 0 map.lp car.lp rules.lp show.lp
```
You will get 2 answer sets:
```
Answer: 1
 State 0:
  vehicle_on_lane(c1,l1) vehicle_on_lane(c2,l1) vehicle_on_lane(c3,l3)
  lonpr(c1,p1,ahead) lonpr(c1,p2,behind) lonpr(c2,p1,ahead) lonpr(c2,p2,behind) lonpr(c3,p1,behind) lonpr(c3,p2,ahead)
  lonr(c1,c2,behind) lonr(c2,c1,ahead)
  rvsover(c3,p1,p2)
 State 1:
  vehicle_on_lane(c1,l1) vehicle_on_lane(c1,l2) vehicle_on_lane(c2,l1) vehicle_on_lane(c3,l3)
  fwdover(c1,p1,p2)
  lonpr(c1,p1,ahead) lonpr(c1,p2,behind) lonpr(c2,p1,ahead) lonpr(c2,p2,behind) lonpr(c3,p1,behind) lonpr(c3,p2,ahead)
  lonr(c1,c2,behind) lonr(c2,c1,ahead)
  lonro(c1,c3,behind) lonro(c3,c1,ahead)
  rvsover(c3,p1,p2)
 State 2:
  longitudinal_changed(c1,c2) longitudinal_changed(c2,c1)
  vehicle_on_lane(c1,l2) vehicle_on_lane(c2,l1) vehicle_on_lane(c3,l3)
  fwdover(c1,p1,p2)
  lonpr(c1,p1,ahead) lonpr(c1,p2,behind) lonpr(c2,p1,ahead) lonpr(c2,p2,behind) lonpr(c3,p1,behind) lonpr(c3,p2,ahead)
  lonr(c1,c2,cover) lonr(c2,c1,cover)
  lonro(c1,c3,behind) lonro(c3,c1,ahead)
  rvsover(c3,p1,p2)
 State 3:
  longitudinal_changed(c1,c2) longitudinal_changed(c2,c1)
  vehicle_on_lane(c1,l1) vehicle_on_lane(c1,l2) vehicle_on_lane(c2,l1) vehicle_on_lane(c3,l3)
  fwdover(c1,p1,p2)
  lonpr(c1,p1,ahead) lonpr(c1,p2,behind) lonpr(c2,p1,ahead) lonpr(c2,p2,behind) lonpr(c3,p1,behind) lonpr(c3,p2,ahead)
  lonr(c1,c2,ahead) lonr(c2,c1,behind)
  lonro(c1,c3,behind) lonro(c3,c1,ahead)
  rvsover(c3,p1,p2)
 State 4:
  vehicle_on_lane(c1,l1) vehicle_on_lane(c2,l1) vehicle_on_lane(c3,l3)
  lonpr(c1,p1,ahead) lonpr(c1,p2,behind) lonpr(c2,p1,ahead) lonpr(c2,p2,behind) lonpr(c3,p1,behind) lonpr(c3,p2,ahead)
  lonr(c1,c2,ahead) lonr(c2,c1,behind)
  rvsover(c3,p1,p2)
Answer: 2
 State 0:
  vehicle_on_lane(c1,l1) vehicle_on_lane(c2,l1) vehicle_on_lane(c3,l3)
  lonpr(c1,p1,ahead) lonpr(c1,p2,behind) lonpr(c2,p1,ahead) lonpr(c2,p2,behind) lonpr(c3,p1,behind) lonpr(c3,p2,ahead)
  lonr(c1,c2,behind) lonr(c2,c1,ahead)
  rvsover(c3,p1,p2)
 State 1:
  vehicle_on_lane(c1,l1) vehicle_on_lane(c1,l2) vehicle_on_lane(c2,l1) vehicle_on_lane(c3,l3)
  fwdover(c1,p1,p2)
  lonpr(c1,p1,ahead) lonpr(c1,p2,behind) lonpr(c2,p1,ahead) lonpr(c2,p2,behind) lonpr(c3,p1,behind) lonpr(c3,p2,ahead)
  lonr(c1,c2,behind) lonr(c2,c1,ahead)
  lonro(c1,c3,ahead) lonro(c3,c1,behind)
  rvsover(c3,p1,p2)
 State 2:
  longitudinal_changed(c1,c2) longitudinal_changed(c2,c1)
  vehicle_on_lane(c1,l2) vehicle_on_lane(c2,l1) vehicle_on_lane(c3,l3)
  fwdover(c1,p1,p2)
  lonpr(c1,p1,ahead) lonpr(c1,p2,behind) lonpr(c2,p1,ahead) lonpr(c2,p2,behind) lonpr(c3,p1,behind) lonpr(c3,p2,ahead)
  lonr(c1,c2,cover) lonr(c2,c1,cover)
  lonro(c1,c3,ahead) lonro(c3,c1,behind)
  rvsover(c3,p1,p2)
 State 3:
  longitudinal_changed(c1,c2) longitudinal_changed(c2,c1)
  vehicle_on_lane(c1,l1) vehicle_on_lane(c1,l2) vehicle_on_lane(c2,l1) vehicle_on_lane(c3,l3)
  fwdover(c1,p1,p2)
  lonpr(c1,p1,ahead) lonpr(c1,p2,behind) lonpr(c2,p1,ahead) lonpr(c2,p2,behind) lonpr(c3,p1,behind) lonpr(c3,p2,ahead)
  lonr(c1,c2,ahead) lonr(c2,c1,behind)
  lonro(c1,c3,ahead) lonro(c3,c1,behind)
  rvsover(c3,p1,p2)
 State 4:
  vehicle_on_lane(c1,l1) vehicle_on_lane(c2,l1) vehicle_on_lane(c3,l3)
  lonpr(c1,p1,ahead) lonpr(c1,p2,behind) lonpr(c2,p1,ahead) lonpr(c2,p2,behind) lonpr(c3,p1,behind) lonpr(c3,p2,ahead)
  lonr(c1,c2,ahead) lonr(c2,c1,behind)
  rvsover(c3,p1,p2)
SATISFIABLE
```
which are shown in Figure 4e in our paper.