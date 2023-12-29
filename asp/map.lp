#program always.
% |l1:l2|
% is_lane(l1;l2).
% left(l2,l1).

% __|l1|__
% l2 c1 l2
% --|l1|--
% is_lane(l1;l2).
% is_road(r1;r2).
% has_lane(r1,l1).
% has_lane(r2,l2).
% is_cross(c1).
% on_lane(c1,l1).
% on_lane(c1,l2).

% ------------
%  l1      l2
% ---- f1 ----
%     \    l3
%      -------
% is_lane(l1;l2;l3).
% is_road(r1;r2;r3).
% has_lane(r1,l1).
% has_lane(r2,l2).
% has_lane(r3,l3).
% is_fork(f1).
% on_lane(f1,l1).
% on_lane(f1,l2).
% on_lane(f1,l3).
% successor(l1,f1).
% successor(f1,l2).
% successor(f1,l3).

% ------------
%  l1       l3
% ---- f1 ----
%  l2    /
% -------
% is_lane(l1;l2;l3).
% is_road(r1;r2;r3).
% has_lane(r1,l1).
% has_lane(r2,l2).
% has_lane(r3,l3).
% is_fork(f1).
% on_lane(f1,l1).
% on_lane(f1,l2).
% on_lane(f1,l3).
% successor(l1,f1).
% successor(l2,f1).
% successor(f1,l3).

% __|l1|__
% l3 c2 l3
% --|  |--
% __|l1|__
% l2 c1 l2
% --|l1|--
is_lane(l1;l2;l3).
is_road(r1;r2;r3).
has_lane(r1,l1).
has_lane(r2,l2).
has_lane(r3,l3).
is_cross(c1;c2).
on_lane(c1,l1).
on_lane(c1,l2).
on_lane(c2,l1).
on_lane(c2,l3).
successor(c1,c2,l1).
