%% 计算每个非支配集合中所有个体的拥挤度
function Pop = CrowdingDistanceSorting(Pop,RankSet)

% 获取参数
FuncNum = numel(Pop(1).Fitness);                % 目标函数的个数
RankNum = numel(RankSet);                       % 非支配等级的个数，即非支配集合的个数

% 计算非支配等级为Rank的所有个体的拥挤度
for Rank = 1 : RankNum
    RankSize = numel(RankSet{Rank});            % 非支配等级为Rank的个体数
    CD = zeros(RankSize,FuncNum);               % 每一个目标函数的拥挤度初始化为0
    FitValue = zeros(RankSize,FuncNum);         % 存储非支配等级为Rank的所有个体的目标函数
    for i = 1 : RankSize
        FitValue(i,:) = Pop(RankSet{Rank}(i)).Fitness;
    end

    % 遍历每一个目标函数，计算非支配等级为Rank中每个个体的第r个函数的拥挤度
    for r = 1 : FuncNum
        if RankSize == 1
            CD(1,r) = +Inf;
        elseif RankSize == 2
            CD(1,r) = +Inf;
            CD(2,r) = +Inf;
        elseif RankSize >= 3
            % 根据第r个目标函数值对该等级的个体进行排序
            [FVr,Index] = sort(FitValue(:,r));

            % 两个边界点的拥挤度设为正无穷，以确保每次都能被选入下一代
            CD(Index(1),r) = +Inf;
            CD(Index(RankSize),r) = +Inf;
            
            % 计算边界内的点的第r个目标函数的拥挤度
            for i = 2 : RankSize - 1
                CD(Index(i),r) = (FVr(i+1) - FVr(i-1)) / (FVr(RankSize) - FVr(1) + eps);
            end            
        end
    end

    % 为非支配等级为Rank的所有个体赋值拥挤度
    for i = 1 : RankSize
        Pop(RankSet{Rank}(i)).CrowdingDistance = sum(CD(i,:));
    end

end

end