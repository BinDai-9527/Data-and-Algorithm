%% ZDT系列
function [ObjFunc,FuncNum,dim,lb,ub,TruePF] = ZDTX(FuncX)

switch FuncX
    case 'ZDT1'
        ObjFunc = @ZDT1;
        FuncNum = 2;
        dim = 30;
        lb = 0 * ones(1,dim);
        ub = 1 * ones(1,dim);
        load ('ZDT.mat','ZDT1')
        TruePF = ZDT1;

    case 'ZDT2'
        ObjFunc = @ZDT2;
        FuncNum = 2;
        dim = 30;
        lb = 0 * ones(1,dim);
        ub = 1 * ones(1,dim);
        load ('ZDT.mat','ZDT2')
        TruePF = ZDT2;

    case 'ZDT3'
        ObjFunc = @ZDT3;
        FuncNum = 2;
        dim = 30;
        lb = 0 * ones(1,dim);
        ub = 1 * ones(1,dim);
        load ('ZDT.mat','ZDT3')
        TruePF = ZDT3;

    case 'ZDT4'
        ObjFunc = @ZDT4;
        FuncNum = 2;
        dim = 10;
        lb = [0,-5 * ones(1,dim-1)];
        ub = [1,5 * ones(1,dim-1)];
        load ('ZDT.mat','ZDT4')
        TruePF = ZDT4;

    case 'ZDT6'
        ObjFunc = @ZDT6;
        FuncNum = 2;
        dim = 10;
        lb = 0 * ones(1,dim);
        ub = 1 * ones(1,dim);
        load ('ZDT.mat','ZDT6')
        TruePF = ZDT6;

end

end

%% ZDT1
function f = ZDT1(x)

f1 = x(1);                                      % 目标函数1

g = 1 + 9 * mean(x(2:end));
h = 1 - sqrt(f1 / g);

f2 = g * h;                                     % 目标函数2

f = [f1,f2];

end

%% ZDT2
function f = ZDT2(x)

f1 = x(1);                                      % 目标函数1

g = 1 + 9 * mean(x(2:end));
h = 1 - (f1 / g)^2;

f2 = g * h;                                     % 目标函数2

f = [f1,f2];

end

%% ZDT3
function f = ZDT3(x)

f1 = x(1);                                      % 目标函数1

g = 1 + 9 * mean(x(2:end));
h = 1 - sqrt(f1 / g) - (f1 / g) * sin(10 * pi * f1);

f2 = g * h;                                     % 目标函数2

f = [f1,f2];

end

%% ZDT4
function f = ZDT4(x)

f1 = x(1);                                      % 目标函数1

g = 1 + 10 * (numel(x) - 1) + ...
    sum(x(2:end).^2 - 10 * cos(4 * pi * x(2:end)));
h = 1 - sqrt(f1 / g);

f2 = g * h;                                     % 目标函数2

f = [f1,f2];

end

%% ZDT6
function f = ZDT6(x)

f1 = 1 - exp(-4 * x(1)) * sin(6 * pi * x(1))^6; % 目标函数1

g = 1 + 9 * mean(x(2:end))^(0.25);
h = 1 - (f1 / g)^2;

f2 = g * h;                                     % 目标函数2

f = [f1,f2];

end
