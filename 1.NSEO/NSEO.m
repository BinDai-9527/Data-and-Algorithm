%% NSEO
%% 清空环境和设置数据长度
close all
clear
clc
format long

tic
%% 1.NSEO的参数
% 1.1.决策变量参数
% 选择测试函数系列
TestFuncNum = 'IMOP';
switch TestFuncNum
    case 'ZDT'      % 无约束测试函数: ZDT1-4,6
        FuncX = 'ZDT1';             % 测试函数的名称
        [ObjFunc,FuncNum,dim,lb,ub,TruePF] = ZDTX(FuncX);
    case 'UF'       % 无约束测试函数: UF1-10
        FuncX = 'UF1';              % 测试函数的名称
        [ObjFunc,FuncNum,dim,lb,ub,TruePF] = UFX(FuncX);
    case 'IMOP'     % 无约束测试函数: IMOP1-8
        FuncX = 'IMOP4';            % 测试函数的名称
        [ObjFunc,FuncNum,dim,lb,ub,TruePF] = IMOPX(FuncX);
end
% ObjFunc: 目标函数; FuncNum: 目标函数的个数
% dim: 变量的个数; lb: 变量的下界; ub: 变量的上界
% TruePF: 真实的Pareto前沿

% 1.2.种群参数
PopSize = 100;                    	% 种群大小
IterMax = 2000;                    	% 最大的迭代次数

a1 = 2;                             % 探索能力控制参数
a2 = 1;                             % 开发能力控制参数
GP = 0.5;                           % 生产概率
V = 1;

%% 2.种群初始化
% 2.1.初始化决策变量和目标函数
emptyPop.Position = [];             % 决策变量
emptyPop.Fitness = [];              % 目标函数
emptyPop.Rank = [];                 % 非支配等级
emptyPop.CrowdingDistance = [];     % 拥挤度
Pop = repmat(emptyPop,PopSize,1);

for i = 1 : PopSize                 % 初始化种群
    Pop(i).Position = unifrnd(lb,ub);
    Pop(i).Fitness = ObjFunc(Pop(i).Position);
end

% 2.2.计算种群的非支配等级
[Pop,RankSet] = NonDominationSorting(Pop);                  % RankSet为所有非支配等级的集合

% 2.3.计算每个非支配集合中所有个体的拥挤度
Pop = CrowdingDistanceSorting(Pop,RankSet);

%% 3.主循环
for t = 1 : IterMax
    Ft = (1 - t / IterMax) ^ (a2 * t / IterMax);

    LeaderPool = EquilibriumPool(Pop);                      % 构建均衡池  

    % 3.1.更新种群
    NewAgent = repmat(emptyPop,PopSize,1);
    for i = 1 : PopSize
        Leader = LeaderPool(randi(5));      % 挑选领导者

        Lambda = rand(1,dim);
        r = rand(1,dim);
        F = a1 * sign(r - 0.5) .* (exp(- Ft * Lambda) - 1); % 指数项
        GCP = 0.5 * rand() * ones(1,dim) * (rand() >= GP);  % 生成速率控制参数
        G0 = GCP .* (Leader.Position - Lambda .* Pop(i).Position);
        G = G0 .* F;                        % 生成速率
        % 更新位置
        NewAgent(i).Position = Leader.Position + (Pop(i).Position - Leader.Position) .* F + ...
            (G ./ (Lambda * V)) .* (1 - F);
        % 位置的边界处理
        NewAgent(i).Position = max(NewAgent(i).Position,lb);
        NewAgent(i).Position = min(NewAgent(i).Position,ub);
        % 计算适应度
        NewAgent(i).Fitness = ObjFunc(NewAgent(i).Position);
    end

    % 3.2.精英保留策略
    PopCom = [Pop;NewAgent];                            % 将上一代和这一代合并
    [PopCom,RankSet] = NonDominationSorting(PopCom);    % 计算种群的非支配等级
    PopCom = CrowdingDistanceSorting(PopCom,RankSet);   % 计算每个非支配集合中所有个体的拥挤度   
    Pop = Elitism(PopCom,PopSize,RankSet);              % 精英策略

    if rem(t,10) == 0
        clc;
        fprintf('Run %d\n',t);
        fprintf('Progress Rate %s%%\n',num2str(t / IterMax * 100));
    end
end
toc

%% 4.计算评价指标
% 4.1.获取目标函数值
Archive = Pop(~([Pop.Rank] - 1));                       % 将非支配等级为1的所有个体提取出来
FitValue = zeros(numel(Archive),FuncNum);
for i = 1 : numel(Archive)
    FitValue(i,:) = Archive(i).Fitness;
end

% 4.2.IGD:度量解集的收敛性和多样性,越小越好
IGD = CalculateIGD(FitValue,TruePF);

% 4.3.CPF:度量解集的均匀性和延展性,越大越好
CPF = CalculateCPF(FitValue,TruePF);

Metric = [IGD,CPF];

disp(['IGD = ',num2str(IGD)])
disp(['CPF = ',num2str(CPF)])

%% 5.数据可视化
% Pareto曲线
figure(1)
if FuncNum == 2
    plot(TruePF(:,1),TruePF(:,2),'.','MarkerSize',20);hold on
    plot(FitValue(:,1),FitValue(:,2),'r.','MarkerSize',20);hold on
    xlabel('\it{f_1}')
    ylabel('\it{f_2}')
elseif FuncNum == 3
    plot3(TruePF(:,1),TruePF(:,2),TruePF(:,3),'.','MarkerSize',20);hold on
    plot3(FitValue(:,1),FitValue(:,2),FitValue(:,3),'r.','MarkerSize',20);
    xlabel('\it{f_1}')
    ylabel('\it{f_2}')
    zlabel('\it{f_3}')
    grid on
end
legend('True Pareto front','NSEO Pareto front','Location','NorthEast','FontSize',14)
set(gca,'LineWidth',1.5,'FontName','Times New Roman','FontSize',14,'FontWeight','bold')