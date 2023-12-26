#program always.

% 对称谓词
right(A,B) :- left(B,A).
behind(A,B) :- ahead(B,A).
cover(A,B) :- cover(B,A).

% 禁止同车道cover
:- is_vehicle(A), is_vehicle(B), on_lane(A,L), on_lane(B,L), A != B, cover(A,B).

% 纵向关系排他性
% TODO: 是否一定存在？
% cover(A,A) :- is_vehicle(A).
% 0{ ahead(B,A); behind(B,A); cover(B,A) }1 :- is_vehicle(A), is_vehicle(B), A != B.
% % ~相邻或相同车道必须存在纵向关系~
% 1{ ahead(B,A); behind(B,A); cover(B,A) }1 :- is_vehicle(A), is_vehicle(B), A != B, on_lane(A,L1), on_lane(B,L2), left(L1,L2).
% 1{ ahead(B,A); behind(B,A); cover(B,A) }1 :- is_vehicle(A), is_vehicle(B), A != B, on_lane(A,L), on_lane(B,L).
% 任意两车必须存在唯一纵向关系
1{ ahead(B,A); behind(B,A); cover(B,A) }1 :- is_vehicle(A), is_vehicle(B), A != B.

% 纵向关系的传递性
ahead(A,B) :- ahead(A,C), ahead(C,B).
behind(A,B) :- behind(A,C), behind(C,B).
:- ahead(B,A), cover(C,B), ahead(A,C).
:- cover(B,A), ahead(C,B), ahead(A,C).

#program dynamic.

% 只能占用1至2条车道，2条车道必须相邻
% TODO: 是否可能占用3条及以上？
1{ on_lane(A,L) : is_lane(L) }2 :- is_vehicle(A).
:- on_lane(A,L1), on_lane(A,L2), L1 != L2, not left(L1,L2), not left(L2,L1).

% 纵向关系过渡
:- ahead(B,A), 'behind(B,A), is_vehicle(A), is_vehicle(B).
:- behind(B,A), 'ahead(B,A), is_vehicle(A), is_vehicle(B).

% 车道占用过渡
% 禁止跨车道
:- on_lane(A,L2), 'on_lane(A,L1), not left(L1,L2), not left(L2,L1), is_vehicle(A), is_lane(L1), is_lane(L2), L1 != L2.
% 禁止跳过同时占用两条车道的状态
:- on_lane(A,L2), 'on_lane(A,L1), not 'on_lane(A,L2), not on_lane(A,L1), is_vehicle(A), is_lane(L1), is_lane(L2), L1 != L2.
