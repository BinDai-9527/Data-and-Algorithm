%% 构建均衡池
function LeaderPool = EquilibriumPool(Pop)

LeaderPool = repmat(Pop(1),5,1);

Index1 = TournamentSelection(Pop);
LeaderPool(1) = Pop(Index1);

Pop(Index1) = [];
Index2 = TournamentSelection(Pop);
LeaderPool(2) = Pop(Index2);

Pop(Index2) = [];
Index3 = TournamentSelection(Pop);
LeaderPool(3) = Pop(Index3);

Pop(Index3) = [];
Index4 = TournamentSelection(Pop);
LeaderPool(4) = Pop(Index4);

LeaderPool(5) = LeaderPool(1);      % 结构初始化
LeaderPool(5).Position = (LeaderPool(1).Position + LeaderPool(2).Position + ...
    LeaderPool(3).Position + LeaderPool(4).Position) / 4;

end