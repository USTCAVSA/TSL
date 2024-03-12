% make sure all state transition is complete
#program always.
:- longitudinal_changed(A,1), longitudinal_changed(B,1), A != B.
:- longitudinal_changed(A,2), longitudinal_changed(B,2), A != B.
:- lateral_changed(A,1), lateral_changed(B,1), A != B.
:- lateral_changed(A,2), lateral_changed(B,2), A != B.

#program initial.
time_is(0).

#program dynamic.
time_is(T) :- T>0, 'time_is(T-1).

lateral_changed(C,T) :- is_vehicle(C), not is_ego(C), on_lane(C,L1), 'on_lane(C,L2), L1 != L2, time_is(T).
lateral_changed(C,T) :- 'lateral_changed(C,T).
longitudinal_changed(C,T) :- is_vehicle(C), not is_ego(C), is_ego(E), ahead(C,E), not 'ahead(C,E), time_is(T).
longitudinal_changed(C,T) :- is_vehicle(C), not is_ego(C), is_ego(E), cover(C,E), not 'cover(C,E), time_is(T).
longitudinal_changed(C,T) :- is_vehicle(C), not is_ego(C), is_ego(E), behind(C,E), not 'behind(C,E), time_is(T).
longitudinal_changed(C,T) :- 'longitudinal_changed(C,T).

% :- lateral_changed(A,T), lateral_changed(B,T), A != B, time_is(T).
% :- longitudinal_changed(A,T), longitudinal_changed(B,T), A != B, time_is(T).

% used to find the maximum step
% on_lane(C,L) :- is_vehicle(C), not is_ego(C), _on_lane(C,L).

longitudinal_changed_at_1(N):- #count{A : longitudinal_changed(A,1)} = N.
:- longitudinal_changed_at_1(0).
#show longitudinal_changed_at_1/1.

#program final.

lateral_change_count(N) :- N = #count{C,T: lateral_changed(C,T)}.
longitudinal_changed_count(N) :- N = #count{C,T: longitudinal_changed(C,T)}.
:- lateral_change_count(N), N > 1.
% :- longitudinal_changed_count(N), N > 6.

% #show lateral_changed/2.
% #show longitudinal_changed/2.
% #show lateral_change_count/1.
% #show longitudinal_changed_count/1.
