%% 选择: 二元锦标赛
function LeaderIndex = TournamentSelection(Pop)

PopSize = numel(Pop);                   % 种群数量

RandIndex = randperm(PopSize);          % 在种群中产生随机位置

% 随机2个候选者中评出优胜者，作为领导者
if Pop(RandIndex(1)).Rank < Pop(RandIndex(2)).Rank          % 参赛者1优于参赛者2
    LeaderIndex = RandIndex(1);
elseif Pop(RandIndex(1)).Rank > Pop(RandIndex(2)).Rank      % 参赛者2优于参赛者1
    LeaderIndex = RandIndex(2);
else                                                        % 参赛者1与参赛者2的非支配等级相同
    if Pop(RandIndex(1)).CrowdingDistance >= Pop(RandIndex(2)).CrowdingDistance         
        LeaderIndex = RandIndex(1);                         % 参赛者1的拥挤度大于等于参赛者2
    else                                                    % 参赛者1的拥挤度小于参赛者2
        LeaderIndex = RandIndex(2);
    end
end

end
