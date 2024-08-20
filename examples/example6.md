# Example 6 (The T-intersection)

This is the example 6 in our paper. To run this example, please use the following initial configuration:

```prolog
% car.lp
#program always.
is_vehicle(c1;c2).

#program initial.
on_lane(c1,l1).
lonpr(c1,n1,behind).
on_lane(c2,l4).
lonpr(c2,n4,behind).

#program final.
:- not on_lane(c1,l5).
:- not lonpr(c1,n5,ahead).
:- not on_lane(c2,l2).
:- not lonpr(c2,n2,ahead).
```

```prolog
% map.lp
#program always.

is_road(r1;r2;r3;r4;r5;r6;r13;r63;r45;r15;r42;r62).
is_lane(l1;l2;l3;l4;l5;l6;l13;l63;l45;l15;l42;l62).
is_fork(n1;n2;n3;n4;n5;n6).
is_cross(x1;x2;x3).
has_lane(r1,l1).
has_lane(r2,l2).
has_lane(r3,l3).
has_lane(r4,l4).
has_lane(r5,l5).
has_lane(r6,l6).
has_lane(r13,l13).
has_lane(r63,l63).
has_lane(r45,l45).
has_lane(r15,l15).
has_lane(r42,l42).
has_lane(r62,l62).

on_lane(n1,l1).
on_lane(n1,l13).
on_lane(n1,l15).
successor(l1,n1).
successor(n1,l13).
successor(n1,l15).

on_lane(n2,l2).
on_lane(n2,l42).
on_lane(n2,l62).
successor(l42,n2).
successor(l62,n2).
successor(n2,l2).

on_lane(n3,l3).
on_lane(n3,l13).
on_lane(n3,l63).
successor(l13,n3).
successor(l63,n3).
successor(n3,l3).

on_lane(n4,l4).
on_lane(n4,l42).
on_lane(n4,l45).
successor(l4,n4).
successor(n4,l42).
successor(n4,l45).

on_lane(n5,l5).
on_lane(n5,l45).
on_lane(n5,l15).
successor(l45,n5).
successor(l15,n5).
successor(n5,l5).

on_lane(n6,l6).
on_lane(n6,l62).
on_lane(n6,l63).
successor(l6,n6).
successor(n6,l62).
successor(n6,l63).

on_lane(x1,l15).
on_lane(x1,l63).
on_lane(x2,l42).
on_lane(x2,l15).
on_lane(x3,l62).
on_lane(x3,l42).

successor(n1,x1,l15).
successor(x1,x2,l15).
successor(x2,n5,l15).
successor(n6,x3,l63).
successor(x3,x1,l63).
successor(x1,n3,l63).
successor(n4,x2,l42).
successor(x2,x3,l42).
successor(x3,n2,l42).

successor(n1,n3,l13).
successor(n4,n5,l45).
successor(n6,n2,l62).
```

In this example, a vehicle (c1) is on lane l1 and is required to make a left turn to l5. Another vehicle (c2) is located on l4 and wants to drive forward to l2.

You can create `car.lp` and `map.lp` under the `asp/` folder, then run
```shell
telingo 0 map.lp car.lp rules.lp show.lp
```
You will get 64 answer sets with 9 scenes in each.