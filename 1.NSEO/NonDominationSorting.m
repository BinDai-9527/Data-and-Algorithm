%% 计算种群的非支配等级
function [Pop,RankSet] = NonDominationSorting(Pop)

% 初始化参数
PopSize = numel(Pop);                   % 种群数量

% 创建结构体P
emptyP.DominationSet = [];              % 个体i支配的所有个体
emptyP.DominatedCount = 0;              % 支配个体i的个体数
P = repmat(emptyP,PopSize,1);

Rank = 1;                               % 非支配等级
RankSet{Rank} = [];                     % 非支配等级Rank = 1的解的集合

% 1.判断每个个体是否被支配
for i = 1 : PopSize - 1
    for j = i + 1 : PopSize
        % 判断个体i是否支配个体j
        if all(Pop(i).Fitness <= Pop(j).Fitness) && any(Pop(i).Fitness < Pop(j).Fitness)
            P(i).DominationSet = [P(i).DominationSet,j];
            P(j).DominatedCount = P(j).DominatedCount + 1;
        end
        
        % 判断个体j是否支配个体i
        if all(Pop(j).Fitness <= Pop(i).Fitness) && any(Pop(j).Fitness < Pop(i).Fitness)
            P(j).DominationSet = [P(j).DominationSet,i];
            P(i).DominatedCount = P(i).DominatedCount + 1;
        end
    end
end

% 2.求出非支配等级Rank = 1的所有个体
for i = 1 : PopSize
    if P(i).DominatedCount == 0
        Pop(i).Rank = 1;
        RankSet{Rank} = [RankSet{Rank},i];
    end
end

% 3.求出非支配等级Rank = 2,3,4,...的集合
while true
    Q = [];                             % 存储非支配等级为Rank + 1的所有个体
    for i = RankSet{Rank}               % 遍历非支配等级为Rank的所有个体
        for j = P(i).DominationSet      % 遍历非支配等级为Rank的个体i所支配的所有个体
            P(j).DominatedCount = P(j).DominatedCount - 1;  % 因为支配个体j的个体i已经标记好了非支配等级，故减1
            if P(j).DominatedCount == 0 % 支配个体j的已标记非支配等级的个体全部遍历完了
                Pop(j).Rank = Rank + 1; 
                Q = [Q,j];              %#ok<AGROW> 
            end
        end
    end

    % 最后一个非支配等级的个体没有支配个体，其DominationSet为空，故Q为空
    % 这也意味着循环结束了
    if isempty(Q)                       
        break;
    end

    Rank = Rank + 1;
    RankSet{Rank} = Q;
end

end