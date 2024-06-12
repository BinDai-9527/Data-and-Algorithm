%% 删除一个个体
function Rep = DeleteOneRepMemebr(Rep,Gamma)

% 1.获取网格的粒子密度，按网格索引从小到大排列
GI = [Rep.GridIndex];                   % 获取所有个体的网格索引
UI = unique(GI);                        % 网格索引从小到大排列,并且不重复
GD = zeros(size(UI));                   % 存储对应索引网格中的粒子数，网格的粒子密度
for k = 1 : numel(UI)
    GD(k) = numel(find(GI == UI(k)));
end

% 2.使用轮盘赌法挑选群体极值
% 2.1.挑选概率
P = exp(Gamma * GD);                    % 网格的粒子密度越大，概率越大
P = P / sum(P);                         % 每个网格的挑选概率

% 2.2.轮盘赌法挑选网格
PC = cumsum(P);                         % 每个网格的累积挑选概率
SGI = find(PC >= rand(),1,'first');  	% 累积概率大于rand()的第一网格就是选择的对象

% 3.在挑选的网格中随机删除一个个体
SG = UI(SGI);                           % 被挑选的网格索引
SGM = find(GI == SG);                   % 被挑选的网格索引的所有个体的索引
SMI = randi([1 numel(SGM)]);            % 在被挑选的网格中随机选取一个个体
SM = SGM(SMI);
Rep(SM) = [];

end