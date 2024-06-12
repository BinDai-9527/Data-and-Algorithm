%% MOPSO
%% 清空环境和设置数据长度
close all
clear
clc
format long

tic
%% 1.MOPSO的参数
% 1.1.决策变量参数
% 无约束测试函数：UF1-10
FuncX = 'UF1';                     % 测试函数的名称
[ObjFunc,FuncNum,dim,lb,ub] = TestingFunc(FuncX);
TruePF = GetTrueParetoFront(FuncX); % 获取真实的Pareto前沿
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

Mut = 0.1;                         	% 变异率

Weight = 0.5;                     	% 初始权重
WeightDamp = 0.99;                	% 权重衰减率

c1 = 1;                             % 个体学习因子
c2 = 2;                             % 群体学习因子

VelMin = -2 * ones(1,dim);        	% 速度的下限
VelMax = 2 * ones(1,dim);          	% 速度的上限                    

% 1.3.评价指标
Metric = zeros(IterMax,5);

%% 2.种群初始化
% 2.1.初始化决策变量和目标函数
emptyPop.Position = [];             % 决策变量
emptyPop.Velocity = [];             % 速度
emptyPop.Fitness = [];              % 目标函数
emptyPop.Best.Position = [];        % 个体极值
emptyPop.Best.Fitness = [];         % 个体极值的目标函数
emptyPop.IsDominated = [];          % 是否被支配
emptyPop.GridIndex = [];            % 网格索引
emptyPop.GridSubIndex = [];         % 网格的次级索引
Pop = repmat(emptyPop,PopSize,1);

for i = 1 : PopSize
    Pop(i).Position = unifrnd(lb,ub);
    Pop(i).Velocity = unifrnd(VelMin,VelMax);
    Pop(i).Fitness = ObjFunc(Pop(i).Position,dim);
    Pop(i).Best.Position = Pop(i).Position;
    Pop(i).Best.Fitness = Pop(i).Fitness;
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
    Weight = Weight * WeightDamp;                       % 权重更新
    
    % 3.1.更新种群
    for i = 1 : PopSize
        % 3.1.1.挑选群体极值，每个粒子对应一个群体极值，使得解更加均匀
        GlobalBest = SelectGBest(Rep,Beta);

        % 3.1.2.更新种群的速度
        Pop(i).Velocity = Weight * Pop(i).Velocity ...
            + c1 * rand(1,dim) .* (Pop(i).Best.Position - Pop(i).Position) ...
            + c2 * rand(1,dim) .* (GlobalBest.Position - Pop(i).Position);
        Pop(i).Velocity = max(Pop(i).Velocity,VelMin);      % 速度的边界处理
        Pop(i).Velocity = min(Pop(i).Velocity,VelMax);
        
        % 3.1.3.更新种群的位置
        Pop(i).Position = Pop(i).Position + Pop(i).Velocity;
        lbFlag = Pop(i).Position < lb;                      % 位置的边界处理
        ubFlag = Pop(i).Position > ub;
        Pop(i).Position = Pop(i).Position .* (~(lbFlag + ubFlag)) + lb .* lbFlag + ub .* ubFlag;
        Pop(i).Velocity = Pop(i).Velocity .* (~(lbFlag + ubFlag)) - Pop(i).Velocity .* (lbFlag + ubFlag);
        
        % 3.1.4.更新目标函数
        Pop(i).Fitness = ObjFunc(Pop(i).Position,dim);
        
        % 3.1.5.变异操作
        Pm = (1 - (t - 1) / (IterMax - 1)) ^ (1 / Mut);
        if rand() < Pm
            NewParticle.Position = Mutate(Pop(i).Position,Pm,lb,ub,dim);
            NewParticle.Fitness = ObjFunc(NewParticle.Position,dim);
            if all(NewParticle.Fitness <= Pop(i).Fitness) && any(NewParticle.Fitness < Pop(i).Fitness)
                % 如果变异个体支配原个体
                Pop(i).Position = NewParticle.Position;
                Pop(i).Fitness = NewParticle.Fitness;
            elseif all(Pop(i).Fitness <= NewParticle.Fitness) && any(Pop(i).Fitness < NewParticle.Fitness)
                % 如果原个体支配变异个体
                % 保持原样
            else
                % 两者非支配，一半的概率进行替换
                if rand() <= 0.5
                    Pop(i).Position = NewParticle.Position;
                    Pop(i).Fitness = NewParticle.Fitness;
                end
            end
        end
   end
    
    % 3.2.更新个体极值
    for i = 1 : PopSize
        if all(Pop(i).Fitness <= Pop(i).Best.Fitness) && any(Pop(i).Fitness < Pop(i).Best.Fitness)
            % 如果新个体支配个体极值
            Pop(i).Best.Position = Pop(i).Position;
            Pop(i).Best.Fitness = Pop(i).Fitness;
        elseif all(Pop(i).Best.Fitness <= Pop(i).Fitness) && any(Pop(i).Best.Fitness < Pop(i).Fitness)
            % 如果个体极值支配新个体，保持原样
        else
            % 两者非支配，一半的概率进行替换
            if rand() <= 0.5
                Pop(i).Best.Position = Pop(i).Position;
                Pop(i).Best.Fitness = Pop(i).Fitness;
            end
        end
    end
    
    % 3.3.确定更新后的个体是否被支配
    Pop = DetermineDomination(PopSize,Pop);
    
    % 3.4.将未被支配的个体添加到档案集合Rep
    Rep = [Rep;Pop(~[Pop.IsDominated])]; %#ok<AGROW>    
    
    % 3.5.确定混合后的Rep中个体是否被支配，并保留非支配个体
    Rep = DetermineDomination(numel(Rep),Rep);
    Rep = Rep(~[Rep.IsDominated]);
    
    % 3.6.创建网格，并确定Rep中每个个体的网格索引
    Grid = CreateGrid(Rep,FuncNum,GridNum,Alpha);           % 创建网格
    for i = 1 : numel(Rep)                                  % 确定Rep中每个个体的网格索引
        Rep(i) = FindGridIndex(Rep(i),FuncNum,GridNum,Grid);
    end
    
    % 3.7.检查档案集合Rep是否满了，若超出个数则进行裁剪
    if numel(Rep) > RepSize
        Extra = numel(Rep) - RepSize;               % 需要被裁剪的个数
        for e = 1 : Extra
            Rep = DeleteOneRepMemebr(Rep,Gamma);    % 裁剪一个个体
        end
    end

    % 3.8.计算评价指标
    FitValue = zeros(numel(Rep),FuncNum);
    for i = 1 : numel(Rep)
        FitValue(i,:) = Rep(i).Fitness;
    end
    
    % 3.8.1.IGD:度量解集的收敛性和多样性,越小越好
    IGD = IGDCalculate(FitValue,TruePF);
    
    % 3.8.2.CPF:度量解集的均匀性和延展性,越大越好
    CPF = CPFCalculate(FitValue,TruePF);
    
    % 3.8.3.GD:度量解集的收敛性
    GD = GDCalculate(FitValue,TruePF);
    
    % 3.8.4.SP:度量解集的均匀性
    SP = SPCalculate(FitValue,TruePF);
    
    % 3.8.5.SD:度量解集的广泛性
    SD = SDCalculate(FitValue,TruePF);
    
    Metric(t,:) = [IGD,CPF,GD,SP,SD];    
    
    if rem(t,10) == 0
        clc;
        fprintf('Run %d\n',t);
        fprintf('Progress Rate %s%%\n',num2str(t / IterMax * 100));
    end
end
toc

%% 4.计算评价指标
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
legend('True Pareto front','MOPSO Pareto front','Location','NorthEast','FontSize',14)
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