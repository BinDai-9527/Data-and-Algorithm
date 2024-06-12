%% UF系列
function [ObjFunc,FuncNum,dim,lb,ub,TruePF] = UFX(FuncX)

switch FuncX
    case 'UF1'
        ObjFunc = @UF1;
        FuncNum = 2;
        dim = 30;
        lb = [0,-1 * ones(1,dim-1)];
        ub = [1,1 * ones(1,dim-1)];
        load ('UF.mat','UF1')
        TruePF = UF1;

    case 'UF2'
        ObjFunc = @UF2;
        FuncNum = 2;
        dim = 30;
        lb = [0,-1 * ones(1,dim-1)];
        ub = [1,1 * ones(1,dim-1)];
        load ('UF.mat','UF2')
        TruePF = UF2;

    case 'UF3'
        ObjFunc = @UF3;
        FuncNum = 2;
        dim = 30;
        lb = 0 * ones(1,dim);
        ub = 1 * ones(1,dim);
        load ('UF.mat','UF3')
        TruePF = UF3;

    case 'UF4'
        ObjFunc = @UF4;
        FuncNum = 2;
        dim = 30;
        lb = [0,-2 * ones(1,dim-1)];
        ub = [1,2 * ones(1,dim-1)];
        load ('UF.mat','UF4')
        TruePF = UF4;

    case 'UF5'
        ObjFunc = @UF5;
        FuncNum = 2;
        dim = 30;
        lb = [0,-1 * ones(1,dim-1)];
        ub = [1,1 * ones(1,dim-1)];
        load ('UF.mat','UF5')
        TruePF = UF5;

    case 'UF6'
        ObjFunc = @UF6;
        FuncNum = 2;
        dim = 30;
        lb = [0,-1 * ones(1,dim-1)];
        ub = [1,1 * ones(1,dim-1)];
        load ('UF.mat','UF6')
        TruePF = UF6;

    case 'UF7'
        ObjFunc = @UF7;
        FuncNum = 2;
        dim = 30;
        lb = [0,-1 * ones(1,dim-1)];
        ub = [1,1 * ones(1,dim-1)];
        load ('UF.mat','UF7')
        TruePF = UF7;

    case 'UF8'
        ObjFunc = @UF8;
        FuncNum = 3;
        dim = 30;
        lb = [0,0,-2 * ones(1,dim-2)];
        ub = [1,1,2 * ones(1,dim-2)];
        load ('UF.mat','UF8')
        TruePF = UF8;

    case 'UF9'
        ObjFunc = @UF9;
        FuncNum = 3;
        dim = 30;
        lb = [0,0,-2 * ones(1,dim-2)];
        ub = [1,1,2 * ones(1,dim-2)];
        load ('UF.mat','UF9')
        TruePF = UF9;

    case 'UF10'
        ObjFunc = @UF10;
        FuncNum = 3;
        dim = 30;
        lb = [0,0,-2 * ones(1,dim-2)];
        ub = [1,1,2 * ones(1,dim-2)];
        load ('UF.mat','UF10')
        TruePF = UF10;

end

end

%% UF1
function f = UF1(x)

dim = numel(x);

J = 1 : dim;                                    % 数组
J1 = 3 : 2 : dim;                               % 奇数组
J2 = 2 : 2 : dim;                               % 偶数组

y = x - sin(6 * pi * x(1) + J * pi / dim);

f1 = x(1) + 2 * mean(y(J1).^2);                 % 目标函数1
f2 = 1 - sqrt(x(1)) + 2 * mean(y(J2).^2);       % 目标函数2

f = [f1,f2];

end

%% UF2
function f = UF2(x)

dim = numel(x);

J = 1 : dim;                                    % 数组
J1 = 3 : 2 : dim;                               % 奇数组
J2 = 2 : 2 : dim;                               % 偶数组

y = zeros(size(x));
y(J1) = x(J1) - (0.3 * x(1)^2 * cos(24 * pi * x(1) + 4 * J(J1) * pi / dim) + 0.6 * x(1)) .* ...
    cos(6 * pi * x(1) + J(J1) * pi / dim);
y(J2) = x(J2) - (0.3 * x(1)^2 * cos(24 * pi * x(1) + 4 * J(J2) * pi / dim) + 0.6 * x(1)) .* ...
    sin(6 * pi * x(1) + J(J2) * pi / dim);

f1 = x(1) + 2 * mean(y(J1).^2);                % 目标函数1
f2 = 1 - sqrt(x(1)) + 2 * mean(y(J2).^2);      % 目标函数2

f = [f1,f2];

end

%% UF3
function f = UF3(x)

dim = numel(x);

J = 1 : dim;                                    % 数组
J1 = 3 : 2 : dim;                               % 奇数组
J2 = 2 : 2 : dim;                               % 偶数组

y = x - x(1) .^ (0.5 * (1 + 3 * (J - 2) / (dim - 2)));

f1 = x(1) + 2 / numel(J1) * (4 * sum(y(J1).^2) - ...
    2 * prod(cos(20 * y(J1) * pi ./ sqrt(J(J1)))) + 2);     % 目标函数1
f2 = 1 - sqrt(x(1)) + 2 / numel(J2) * (4 * sum(y(J2).^2) - ...
    2 * prod(cos(20 * y(J2) * pi ./ sqrt(J(J2)))) + 2);     % 目标函数2

f = [f1,f2];

end

%% UF4
function f = UF4(x)

dim = numel(x);

J = 1 : dim;                                    % 数组
J1 = 3 : 2 : dim;                               % 奇数组
J2 = 2 : 2 : dim;                               % 偶数组

y = x - sin(6 * pi * x(1) + J * pi / dim);
h = abs(y) ./ (1 + exp(2 * abs(y)));

f1 = x(1) + 2 * mean(h(J1));                 % 目标函数1
f2 = 1 - x(1)^2 + 2 * mean(h(J2));           % 目标函数2

f = [f1,f2];

end

%% UF5
function f = UF5(x)

dim = numel(x);

J = 1 : dim;                                    % 数组
J1 = 3 : 2 : dim;                               % 奇数组
J2 = 2 : 2 : dim;                               % 偶数组

y = x - sin(6 * pi * x(1) + J * pi / dim);
h = 2 * y.^2 - cos(4 * pi * y) + 1;

f1 = x(1) + (1/20 + 0.1) * abs(sin(20 * pi * x(1))) + 2 * mean(h(J1));      % 目标函数1
f2 = 1 - x(1) + (1/20 + 0.1) * abs(sin(20 * pi * x(1))) + 2 * mean(h(J2));  % 目标函数2

f = [f1,f2];

end

%% UF6
function f = UF6(x)

dim = numel(x);

J = 1 : dim;                                    % 数组
J1 = 3 : 2 : dim;                               % 奇数组
J2 = 2 : 2 : dim;                               % 偶数组

y = x - sin(6 * pi * x(1) + J * pi / dim);

f1 = x(1) + max(0,2 * (1/4 + 0.1) * sin(4 * pi * x(1))) + ...
    2 / numel(J1) * (4 * sum(y(J1).^2) - 2 * prod(cos(20 * y(J1) * pi ./ sqrt(J(J1)))) + 2);    % 目标函数1
f2 = 1 - x(1) + max(0,2 * (1/4 + 0.1) * sin(4 * pi * x(1))) + ...
    2 / numel(J2) * (4 * sum(y(J2).^2) - 2 * prod(cos(20 * y(J2) * pi ./ sqrt(J(J2)))) + 2);    % 目标函数2

f = [f1,f2];

end

%% UF7
function f = UF7(x)

dim = numel(x);

J = 1 : dim;                                    % 数组
J1 = 3 : 2 : dim;                               % 奇数组
J2 = 2 : 2 : dim;                               % 偶数组

y = x - sin(6 * pi * x(1) + J * pi / dim);

f1 = x(1)^0.2 + 2 * mean(y(J1).^2);             % 目标函数1
f2 = 1 - x(1)^0.2 + 2 * mean(y(J2).^2);         % 目标函数2

f = [f1,f2];

end

%% UF8
function f = UF8(x)

dim = numel(x);

J = 1 : dim;                                    % 数组
J1 = 4 : 3 : dim;                               % 除以3余1
J2 = 5 : 3 : dim;                               % 除以3余2
J3 = 3 : 3 : dim;                               % 被3整除

y = x - 2 * x(2) * sin(2 * pi * x(1) + J * pi / dim);

f1 = cos(0.5 * x(1) * pi) * cos(0.5 * x(2) * pi) + 2 * mean(y(J1).^2);  % 目标函数1
f2 = cos(0.5 * x(1) * pi) * sin(0.5 * x(2) * pi) + 2 * mean(y(J2).^2);  % 目标函数2
f3 = sin(0.5 * x(1) * pi) + 2 * mean(y(J3).^2);                         % 目标函数3

f = [f1,f2,f3];

end

%% UF9
function f = UF9(x)

dim = numel(x);

J = 1 : dim;                                    % 数组
J1 = 4 : 3 : dim;                               % 除以3余1
J2 = 5 : 3 : dim;                               % 除以3余2
J3 = 3 : 3 : dim;                               % 被3整除

y = x - 2 * x(2) * sin(2 * pi * x(1) + J * pi / dim);

f1 = 0.5 * (max(0,(1 + 0.1) * (1 - 4 * (2 * x(1) - 1)^2)) + 2 * x(1)) * x(2) + ...
    2 * mean(y(J1).^2);                         % 目标函数1
f2 = 0.5 * (max(0,(1 + 0.1) * (1 - 4 * (2 * x(1) - 1)^2)) - 2 * x(1) + 2) * x(2) + ...
    2 * mean(y(J2).^2);                         % 目标函数2
f3 = 1 - x(2) + 2 * mean(y(J3).^2);             % 目标函数3

f = [f1,f2,f3];

end

%% UF10
function f = UF10(x)

dim = numel(x);

J = 1 : dim;                                    % 数组
J1 = 4 : 3 : dim;                               % 除以3余1
J2 = 5 : 3 : dim;                               % 除以3余2
J3 = 3 : 3 : dim;                               % 被3整除

y = x - 2 * x(2) * sin(2 * pi * x(1) + J * pi / dim);
h = 4 * y.^2 - cos(8 * pi * y) + 1;

f1 = cos(0.5 * x(1) * pi) * cos(0.5 * x(2) * pi) + 2 * mean(h(J1));  % 目标函数1
f2 = cos(0.5 * x(1) * pi) * sin(0.5 * x(2) * pi) + 2 * mean(h(J2));  % 目标函数2
f3 = sin(0.5 * x(1) * pi) + 2 * mean(h(J3));                         % 目标函数3

f = [f1,f2,f3];

end