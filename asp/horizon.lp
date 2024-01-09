% --istop=unsat
#program initial.
time_is(0).

#program always.

vehicle_on_lane(A,L) :- is_vehicle(A), is_lane(L), on_lane(A,L).

is_valid_time(T) :- time_is(T).

seen(vehicle_on_lane(A,L), T) :- vehicle_on_lane(A,L), time_is(T).
seen(ahead(A,B), T) :- ahead(A,B), time_is(T).
seen(cover(A,B), T) :- cover(A,B), time_is(T).
% seen(changing_lane_to(A,L), T) :- changing_lane_to(A,L), time_is(T).
hold_nums(M,T) :- M = #count{X:seen(X,T)}, is_valid_time(T).

#program dynamic.

time_is(T) :- T>0, 'time_is(T-1).
seen(X,T) :- 'seen(X,T).
is_valid_time(T) :- 'is_valid_time(T).

duplicate_nums(M,T) :- M = #count{X:seen(X,T), seen(X,Now)}, is_valid_time(T), time_is(Now), T < Now.

% :- hold_nums(M,T), duplicate_nums(M,T), is_valid_time(T), hold_nums(M, Now), time_is(Now), T < Now.
:- hold_nums(M,T), duplicate_nums(M,T), is_valid_time(T), hold_nums(M, Now), time_is(Now), T = Now - 1.
:- 'hold_nums(M,T), 'duplicate_nums(M,T), 'is_valid_time(T), 'hold_nums(M, Now), 'time_is(Now), T < Now.

% #show hold_nums/1.
% #show duplicate_nums/1.
% #show seen_ago/2.
