#program always.

% 对称谓词
right(A,B) :- left(B,A).
left(A,B) :- right(B,A).
behind(A,B) :- ahead(B,A).
ahead(A,B) :- behind(B,A).
cover(A,B) :- cover(B,A).
successor(A,B) :- predecessor(B,A).
predecessor(A,B) :- successor(B,A).

:- left(A,B), right(A,B).
:- behind(A,B), ahead(A,B).
:- successor(A,B), predecessor(A,B).

% 辅助谓词on_road
on_road(A,R) :- is_vehicle(A), is_lane(L), is_road(R), on_lane(A,L), has_lane(R,L).

% 辅助谓词forking
forking(A) :- is_vehicle(A), is_fork(F), cover(A,F).

% 辅助谓词neighbor_lane/2
neighbor_lane(L1,L2) :- is_lane(L1), is_lane(L2), left(L1,L2).
neighbor_lane(L1,L2) :- is_lane(L1), is_lane(L2), right(L1,L2).

% 禁止同车道cover
:- is_vehicle(A), is_vehicle(B), on_lane(A,L), on_lane(B,L), A != B, cover(A,B).

% 纵向关系排他性
% 同一道路任意两车必须存在唯一纵向关系
1{ ahead(A,B); behind(A,B); cover(A,B) }1 :- is_vehicle(A), is_vehicle(B), A != B, on_road(A,R), on_road(B,R), is_road(R).
% % 不同道路任意两车不存在纵向关系
% :- ahead(A,B), is_vehicle(A), is_vehicle(B), on_road(A,R1), on_road(B,R2), is_road(R1), is_road(R2), R1 != R2.
% :- behind(A,B), is_vehicle(A), is_vehicle(B), on_road(A,R1), on_road(B,R2), is_road(R1), is_road(R2), R1 != R2.
% :- cover(A,B), is_vehicle(A), is_vehicle(B), on_road(A,R1), on_road(B,R2), is_road(R1), is_road(R2), R1 != R2.
% 本车道的车与本车道上的交叉点必须存在唯一纵向关系
1{ ahead(A,C); behind(A,C); cover(A,C) }1 :- is_vehicle(A), is_cross(C), is_lane(L), on_lane(A,L), on_lane(C,L).



% 纵向关系的传递性
ahead(A,B) :- ahead(A,C), ahead(C,B), A != B, B != C, A != C.
behind(A,B) :- behind(A,C), behind(C,B), A != B, B != C, A != C.
:- ahead(A,B), cover(B,C), ahead(C,A), A != B, B != C, A != C.
:- cover(A,B), ahead(B,C), ahead(C,A), A != B, B != C, A != C.

% cross point的纵向关系传递性
ahead(A,C):- ahead(A,B), cover(B,C), is_cross(C), is_vehicle(A), is_vehicle(B).

% fork点的纵向关系
ahead(A,F):- ahead(A,B), cover(B,F), is_fork(F), is_vehicle(A), is_vehicle(B).


% 未forking时占用多条车道必须相邻
:- on_lane(A,L1), on_lane(A,L2), L1 != L2, not left(L1,L2), not left(L2,L1), is_lane(L1), is_lane(L2), is_vehicle(A), not forking(A).
% cover fork时同时on_lane所有fork所在车道
on_lane(A,L) :- is_vehicle(A), is_fork(F), on_lane(F,L), cover(A,F).

#program dynamic.

% 未forking时只能占用1至2条车道
% TODO: 可能占用3条及以上，是否考虑(禁止连续变道?)
1{ on_lane(A,L) : is_lane(L) }2 :- is_vehicle(A), not forking(A).

% forking时每条分支车道最多占用一个相邻车道
0{on_lane(A,L2):is_lane(L2),neighbor_lane(L1,L2)}1 :- is_vehicle(A), cover(A,F), is_fork(F), is_lane(L1), on_lane(A,L1), on_lane(F,L1).

% 在fork点一个前驱车道上，则behind它或cover它
1{behind(A,F); cover(A,F)}1 :- is_fork(F), is_vehicle(A), predecessor(F,L), not not on_lane(A,L).
% 在fork点一个后继车道上，则ahead它或cover它
1{ahead(A,F); cover(A,F)}1 :- is_fork(F), is_vehicle(A), successor(F,L), not not on_lane(A,L).

% 纵向关系过渡
:- ahead(A,B), 'behind(A,B).
:- behind(A,B), 'ahead(A,B).

% 车道占用过渡
% 未cover fork点禁止切换到非相邻车道
:- on_lane(A,L2), 'on_lane(A,L1), not left(L1,L2), not left(L2,L1), is_vehicle(A), is_lane(L1), is_lane(L2), L1 != L2, not forking(A), not 'forking(A).
% 禁止跳过同时占用两条车道的状态
:- on_lane(A,L2), 'on_lane(A,L1), not 'on_lane(A,L2), not on_lane(A,L1), is_vehicle(A), is_lane(L1), is_lane(L2), L1 != L2.

% cross点规则
% cross点最多有一辆车
:- cover(A,C), cover(B,C), is_vehicle(A), is_vehicle(B), is_cross(C), A != B.

% fork点规则
% fork点最多有一辆车
:- cover(A,F), cover(B,F), is_vehicle(A), is_vehicle(B), is_fork(F), A != B.
% cover fork后切换lane
&tel{ (cover(A,F) >? ahead(A,F)) | (>* cover(A,F)) } :- is_vehicle(A), is_fork(F), cover(A,F).

% cover(ego,f1).