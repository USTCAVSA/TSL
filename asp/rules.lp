#program always.

% 对称谓词
right(A,B) :- left(B,A).
left(A,B) :- right(B,A).
behind(A,B) :- ahead(B,A).
ahead(A,B) :- behind(B,A).
cover(A,B) :- cover(B,A).

% 辅助谓词on_road
on_road(A,R) :- is_vehicle(A), is_lane(L), is_road(R), on_lane(A,L), has_lane(R,L).

% 禁止同车道cover
:- is_vehicle(A), is_vehicle(B), on_lane(A,L), on_lane(B,L), A != B, cover(A,B).

% 纵向关系排他性
% TODO: 是否一定存在？
% 同一道路任意两车必须存在唯一纵向关系
1{ ahead(A,B); behind(A,B); cover(A,B) }1 :- is_vehicle(A), is_vehicle(B), A != B, on_road(A,R), on_road(B,R), is_road(R).
% 本车道的车与本车道上的交叉点必须存在唯一纵向关系
1{ ahead(A,C); behind(A,C); cover(A,C) }1 :- is_vehicle(A), is_cross(C), is_lane(L), on_lane(A,L), on_lane(C,L).

% 纵向关系的传递性
ahead(A,B) :- ahead(A,C), ahead(C,B).
behind(A,B) :- behind(A,C), behind(C,B).
:- ahead(A,B), cover(B,C), ahead(C,A).
:- cover(A,B), ahead(B,C), ahead(C,A).

% cross point的纵向关系传递性
ahead(A,C):- ahead(A,B), cover(B,C), is_cross(C), is_vehicle(A), is_vehicle(B).

#program dynamic.

% 只能占用1至2条车道，2条车道必须相邻
% TODO: 是否可能占用3条及以上？
1{ on_lane(A,L) : is_lane(L) }2 :- is_vehicle(A).
:- on_lane(A,L1), on_lane(A,L2), L1 != L2, not left(L1,L2), not left(L2,L1), is_lane(L1), is_lane(L2), is_vehicle(A).

% 纵向关系过渡
:- ahead(A,B), 'behind(A,B).
:- behind(A,B), 'ahead(A,B).

% 车道占用过渡
% 禁止跨车道
:- on_lane(A,L2), 'on_lane(A,L1), not left(L1,L2), not left(L2,L1), is_vehicle(A), is_lane(L1), is_lane(L2), L1 != L2.
% 禁止跳过同时占用两条车道的状态
:- on_lane(A,L2), 'on_lane(A,L1), not 'on_lane(A,L2), not on_lane(A,L1), is_vehicle(A), is_lane(L1), is_lane(L2), L1 != L2.

% 交叉点最多有一辆车
:- cover(A,C), cover(B,C), is_vehicle(A), is_vehicle(B), is_cross(C), A != B.