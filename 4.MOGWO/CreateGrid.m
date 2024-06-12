%% 创建网格
function Grid = CreateGrid(Rep,FuncNum,GridNum,Alpha)

% 将目标函数赋值给新变量
FitValue = zeros(numel(Rep),FuncNum);
for i = 1 : numel(Rep)
    FitValue(i,:) = Rep(i).Fitness;
end

% 获取每一目标的最大值和最小值
FVmin = min(FitValue,[],1);
FVmax = max(FitValue,[],1);

FVDelta = FVmax - FVmin;          	% 最大最小值间隔
FVmin = FVmin - Alpha * FVDelta;    % 膨胀最小值
FVmax = FVmax + Alpha * FVDelta;    % 膨胀最大值

% 初始化网格
emptyGrid.LB = [];                  % 网格的下界
emptyGrid.UB = [];                  % 网格的上界
Grid = repmat(emptyGrid,FuncNum,1);

% 描绘每个目标的网格，从而组成超网格
for j = 1 : FuncNum
    temp = linspace(FVmin(j),FVmax(j),GridNum + 1);
    Grid(j).LB = [-Inf,temp];
    Grid(j).UB = [temp,+Inf];
end

end