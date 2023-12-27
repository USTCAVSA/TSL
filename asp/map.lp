#program always.
% |l1:l2|
% is_lane(l1;l2).
% left(l2,l1).

% __|l1|__
% l2 c1 l2
% --|l1|--
is_lane(l1;l2).
is_road(r1;r2).
has_lane(r1,l1).
has_lane(r2,l2).
is_cross(c1).
on_lane(c1,l1).
on_lane(c1,l2).