%% 精英策略
function Pop = Elitism(PopCom,PopSize,RankSet)

% 获取参数
Pop = PopCom(1:PopSize);                        % 初始化Pop的结构
RankNum = numel(RankSet);                       % 非支配等级的个数，即非支配集合的个数

% 根据偏序PopCom中挑选出排名前PopSize个个体
EndIndex = 0;                                   % 非支配等级为Rank的最后一个个体的索引
for Rank = 1 : RankNum
    StartIndex = EndIndex + 1;                  % 非支配等级为Rank的第一个个体的索引
    EndIndex = EndIndex + numel(RankSet{Rank});
    if EndIndex < PopSize                       % 个体数未达到PopSize，直接放入
        Pop(StartIndex : EndIndex) = PopCom(RankSet{Rank});
    elseif EndIndex == PopSize                  % 个体数刚好达到PopSize，直接放入
        Pop(StartIndex : EndIndex) = PopCom(RankSet{Rank});
        return
    else                                        % 个体数将达到PopSize，需要截断
        NewPop = PopCom(RankSet{Rank});         % 存储这部分所有个体
        CrowdingDistance = [NewPop(1:end).CrowdingDistance];
        [~,CDIndex] = sort(CrowdingDistance,'descend'); % 拥挤度从大到小排列
        RestNum = PopSize - StartIndex + 1;     % 剩余个体数
        Pop(StartIndex : PopSize) = NewPop(CDIndex(1 : RestNum));
        return
    end
end

end