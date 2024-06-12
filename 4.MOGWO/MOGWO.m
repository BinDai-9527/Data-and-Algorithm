%% MOGWO
%% 清空环境和设置数据长度
close all
clear
clc
format long

tic
%% 1.初始化参数
% 1.1.决策变量参数
% 无约束测试函数：UF1-10
FuncX = 'UF1';                      % 测试函数的名称
[ObjFunc,FuncNum,dim,lb,ub] = TestingFunc(FuncX);
TruePF = GetTrueParetoFront(FuncX);	% 获取真实的Pareto前沿
% ObjFunc: 目标函数
% FuncNum: 目标函数的个数; dim: 变量的个数
% lb: 变量的下界; ub: 变量的上界

% 1.2.种群参数
PopSize = 100;                    	% 种群大小
RepSize = 100;                    	% Archive的大小
IterMax = 2000;                    	% 最大的迭代次数

GridNum = 10;                      	% 划分的网格数
Alpha = 0.1;                        % 网格膨胀率，以容纳极端解

Beta = 2;                           % 群体极值的选择压力
Gamma = 2;                          % Archive的删除选择压力

% 1.3.评价指标
Metric = zeros(IterMax,5);

%% 2.种群初始化
% 2.1.初始化决策变量和目标函数
emptyPop.Position = [];             % 决策变量
emptyPop.Fitness = [];              % 目标函数
emptyPop.IsDominated = [];          % 是否被支配
emptyPop.GridIndex = [];            % 网格索引
emptyPop.GridSubIndex = [];         % 网格的坐标
Pop = repmat(emptyPop,PopSize,1);

for i = 1 : PopSize
    Pop(i).Position = unifrnd(lb,ub);
    Pop(i).Fitness = ObjFunc(Pop(i).Position,dim);
end

% 2.2.确定个体是否被支配
Pop = DetermineDomination(PopSize,Pop);

% 2.3.将所有未被支配的个体存入档案集合Rep
Rep = Pop(~[Pop.IsDominated]);

% 2.4.创建网格，并确定Rep中每个个体的网格索引
Grid = CreateGrid(Rep,FuncNum,GridNum,Alpha);           % 创建网格
for i = 1 : numel(Rep)                                  % 确定Rep中每个个体的网格索引
    Rep(i) = FindGridIndex(Rep(i),FuncNum,GridNum,Grid);
end

%% 3.主循环
for t = 1 : IterMax
    a = 2 * (1 - t / IterMax);
    
    % 3.1.更新种群
    for i = 1 : PopSize
        clear Rep1
        clear Rep2
        
        % 挑选出Alpha，Beta和Delta三匹狼每个粒子对应一个群体极值，使得解更加均匀
        AlphaWolf = SelectGBest(Rep,Beta);
        BetaWolf = SelectGBest(Rep,Beta);
        DeltaWolf = SelectGBest(Rep,Beta);
        
        % 在去除了DeltaWolf的Archive中挑选BetaWolf
        if size(Rep,1) > 1
            Counter = 0;
            for k = 1 : size(Rep,1)
                if sum(DeltaWolf.Position ~= Rep(k).Position) ~= 0
                    Counter = Counter + 1;
                    Rep1(Counter,1) = Rep(k);           %#ok<SAGROW>
                end
            end
        	BetaWolf = SelectGBest(Rep1,Beta);
        end
        
        % 在去除了DeltaWolf和BetaWolf的Archive中挑选AlphaWolf
        if size(Rep,1)>2
            Counter = 0;
            for k = 1 : size(Rep1,1)
                if sum(BetaWolf.Position ~= Rep1(k).Position) ~= 0
                    Counter = Counter + 1;
                    Rep2(Counter,1) = Rep1(k);           %#ok<SAGROW>
                end
            end
            AlphaWolf = SelectGBest(Rep2,Beta);
        end        
        
        % Alpha狼的协同系数A1与C1
        A1 = 2 * a * rand(1,dim) - a;
        C1 = 2 * rand(1,dim);
        D1 = abs(C1 .* AlphaWolf.Position - Pop(i).Position);	% 当前的Alpha狼与其他狼之间的距离（包括自己）
        X1 = AlphaWolf.Position - A1 .* D1;
        
        % Beta狼的协同系数A2与C2
        A2 = 2 * a * rand(1,dim) - a;
        C2 = 2 * rand(1,dim);
        D2 = abs(C2 .* BetaWolf.Position - Pop(i).Position);	% 当前的Beta狼与其他狼之间的距离（包括自己）
        X2 = BetaWolf.Position - A2 .* D2;
        
        % Delta狼的协同系数A3与C3
        A3 = 2 * a * rand(1,dim) - a;
        C3 = 2 * rand(1,dim);
        D3 = abs(C3 .* DeltaWolf.Position - Pop(i).Position);	% 当前的Delta狼与其他狼之间的距离（包括自己）
        X3 = DeltaWolf.Position - A3 .* D3;        
        
        Pop(i).Position = (X1 + X2 + X3) / 3;                   % 更新个体位置
        Pop(i).Position = max(Pop(i).Position,lb);              % 边界处理
        Pop(i).Position = min(Pop(i).Position,ub);
        
        Pop(i).Fitness = ObjFunc(Pop(i).Position,dim);          % 更新目标函数
    end
    
    % 3.2.确定更新后的个体是否被支配
    Pop = DetermineDomination(PopSize,Pop);
    
    % 3.3.将未被支配的个体添加到档案集合Rep
    Rep = [Rep;Pop(~[Pop.IsDominated])];                        %#ok<AGROW>
    
    % 3.4.确定混合后的Rep中个体是否被支配，并保留非支配个体
    Rep = DetermineDomination(numel(Rep),Rep);
    Rep = Rep(~[Rep.IsDominated]);
    
    % 3.5.创建网格，并确定Rep中每个个体的网格索引
    Grid = CreateGrid(Rep,FuncNum,GridNum,Alpha);           % 创建网格
    for i = 1 : numel(Rep)                                  % 确定Rep中每个个体的网格索引
        Rep(i) = FindGridIndex(Rep(i),FuncNum,GridNum,Grid);
    end
    
    % 3.6.检查档案集合Rep是否满了，若超出个数则进行裁剪
    if numel(Rep) > RepSize
        Extra = numel(Rep) - RepSize;               % 需要被裁剪的个数
        for e = 1 : Extra
            Rep = DeleteOneRepMemebr(Rep,Gamma);    % 裁剪一个个体
        end
    end
    
    % 3.7.计算评价指标
    FitValue = zeros(numel(Rep),FuncNum);
    for i = 1 : numel(Rep)
        FitValue(i,:) = Rep(i).Fitness;
    end
    
    % 3.7.1.IGD:度量解集的收敛性和多样性,越小越好
    IGD = IGDCalculate(FitValue,TruePF);
    
    % 3.7.2.CPF:度量解集的均匀性和延展性,越大越好
    CPF = CPFCalculate(FitValue,TruePF);
    
    % 3.7.3.GD:度量解集的收敛性
    GD = GDCalculate(FitValue,TruePF);
    
    % 3.7.4.SP:度量解集的均匀性
    SP = SPCalculate(FitValue,TruePF);
    
    % 3.7.5.SD:度量解集的广泛性
    SD = SDCalculate(FitValue,TruePF);
    
    Metric(t,:) = [IGD,CPF,GD,SP,SD];    
    
    if rem(t,10) == 0
        clc;
        fprintf('Run %d\n',t);
        fprintf('Progress Rate %s%%\n',num2str(t / IterMax * 100));
    end
end
toc

%% 4.评价指标
% 4.1.IGD:度量解集的收敛性和多样性,越小越好
disp(['Inverted Generational Distance = ',num2str(Metric(end,1))])

% 4.2.CPF:度量解集的均匀性和延展性,越大越好
disp(['Coverage over Pareto front = ',num2str(Metric(end,2))])

% 4.3.GD:度量解集的收敛性
disp(['Generational Distance = ',num2str(Metric(end,3))])

% 4.4.SP:度量解集的均匀性
disp(['Spacing = ',num2str(Metric(end,4))])

% 4.5.SD:度量解集的广泛性
disp(['Spread = ',num2str(Metric(end,5))])

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
legend('True Pareto front','MOGWO Pareto front','Location','NorthEast','FontSize',14)
set(gca,'LineWidth',1.5,'FontName','Times New Roman','FontSize',14,'FontWeight','bold')

% IGD的变化曲线
figure(2)
plot(1 : IterMax,Metric(:,1),'LineWidth',2);
xlabel('Iteration');
ylabel('IGD');
set(gca,'LineWidth',2,'FontName','Times New Roman','FontSize',14,'FontWeight','bold');

% CPF的变化曲线
figure(3)
plot(1 : IterMax,Metric(:,2),'LineWidth',2);
xlabel('Iteration');
ylabel('CPF');
set(gca,'LineWidth',2,'FontName','Times New Roman','FontSize',14,'FontWeight','bold');

% GD的变化曲线
figure(4)
plot(1 : IterMax,Metric(:,3),'LineWidth',2);
xlabel('Iteration');
ylabel('GD');
set(gca,'LineWidth',2,'FontName','Times New Roman','FontSize',14,'FontWeight','bold');

% SP的变化曲线
figure(5)
plot(1 : IterMax,Metric(:,4),'LineWidth',2);
xlabel('Iteration');
ylabel('SP');
set(gca,'LineWidth',2,'FontName','Times New Roman','FontSize',14,'FontWeight','bold');

% SD的变化曲线
figure(6)
plot(1 : IterMax,Metric(:,5),'LineWidth',2);
xlabel('Iteration');
ylabel('SD');
set(gca,'LineWidth',2,'FontName','Times New Roman','FontSize',14,'FontWeight','bold');
