%% IMOP系列
function [ObjFunc,FuncNum,dim,lb,ub,TruePF] = IMOPX(FuncX)

switch FuncX
    case 'IMOP1'
        ObjFunc = @IMOP1;
        FuncNum = 2;
        dim = 10;
        lb = 0 * ones(1,dim);
        ub = 1 * ones(1,dim);
        load ('IMOP.mat','IMOP1')
        TruePF = IMOP1;

    case 'IMOP2'
        ObjFunc = @IMOP2;
        FuncNum = 2;
        dim = 10;
        lb = 0 * ones(1,dim);
        ub = 1 * ones(1,dim);
        load ('IMOP.mat','IMOP2')
        TruePF = IMOP2;

    case 'IMOP3'
        ObjFunc = @IMOP3;
        FuncNum = 2;
        dim = 10;
        lb = 0 * ones(1,dim);
        ub = 1 * ones(1,dim);
        load ('IMOP.mat','IMOP3')
        TruePF = IMOP3;

    case 'IMOP4'
        ObjFunc = @IMOP4;
        FuncNum = 3;
        dim = 10;
        lb = 0 * ones(1,dim);
        ub = 1 * ones(1,dim);
        load ('IMOP.mat','IMOP4')
        TruePF = IMOP4;

    case 'IMOP5'
        ObjFunc = @IMOP5;
        FuncNum = 3;
        dim = 10;
        lb = 0 * ones(1,dim);
        ub = 1 * ones(1,dim);
        load ('IMOP.mat','IMOP5')
        TruePF = IMOP5;

    case 'IMOP6'
        ObjFunc = @IMOP6;
        FuncNum = 3;
        dim = 10;
        lb = 0 * ones(1,dim);
        ub = 1 * ones(1,dim);
        load ('IMOP.mat','IMOP6')
        TruePF = IMOP6;

    case 'IMOP7'
        ObjFunc = @IMOP7;
        FuncNum = 3;
        dim = 10;
        lb = 0 * ones(1,dim);
        ub = 1 * ones(1,dim);
        load ('IMOP.mat','IMOP7')
        TruePF = IMOP7;

    case 'IMOP8'
        ObjFunc = @IMOP8;
        FuncNum = 3;
        dim = 10;
        lb = 0 * ones(1,dim);
        ub = 1 * ones(1,dim);
        load ('IMOP.mat','IMOP8')
        TruePF = IMOP8;
end

end

%% IMOP1
function f = IMOP1(x)

dim = length(x);

a1 = 0.05;
K = 5;

y1 = mean(x(1:K))^a1;
g = sum((x(K+1:dim) - 0.5).^2);

f1 = g + cos(pi/2*y1)^8;                        % 目标函数1
f2 = g + sin(pi/2*y1)^8;                        % 目标函数2

f = [f1,f2];

end

%% IMOP2
function f = IMOP2(x)

dim = length(x);

a1 = 0.05;
K = 5;

y1 = mean(x(1:K))^a1;
g = sum((x(K+1:dim) - 0.5).^2);

f1 = g + cos(pi/2*y1)^0.5;                      % 目标函数1
f2 = g + sin(pi/2*y1)^0.5;                      % 目标函数2

f = [f1,f2];

end

%% IMOP3
function f = IMOP3(x)

dim = length(x);

a1 = 0.05;
K = 5;

y1 = mean(x(1:K))^a1;
g = sum((x(K+1:dim) - 0.5).^2);

f1 = g + 1 + 1/5 * cos(10*pi*y1) - y1;          % 目标函数1
f2 = g + y1;                                    % 目标函数2

f = [f1,f2];

end

%% IMOP4
function f = IMOP4(x)

dim = length(x);

a1 = 0.05;
K = 5;

y1 = mean(x(1:K))^a1;
g = sum((x(K+1:dim) - 0.5).^2);

f1 = (g + 1) * y1;                              % 目标函数1
f2 = (g + 1) * (y1 + 1/10 * sin(10*pi*y1));     % 目标函数2
f3 = (g + 1) * (1 - y1);                      	% 目标函数3

f = [f1,f2,f3];

end

%% IMOP5
function f = IMOP5(x)

dim = length(x);

a2 = 0.05;
a3 = 10;
K = 5;

y2 = mean(x(1:2:K))^a2;
y3 = mean(x(2:2:K))^a3;
g = sum((x(K+1:dim) - 0.5).^2);

h1 = 0.4 * cos(pi/4 * ceil(8 * y2)) + 0.1 * y3 * cos(16 * pi * y2);
h2 = 0.4 * sin(pi/4 * ceil(8 * y2)) + 0.1 * y3 * sin(16 * pi * y2);

f1 = g + h1;                                    % 目标函数1
f2 = g + h2;                                    % 目标函数2
f3 = g + 0.5 - h1 - h2;                      	% 目标函数3

f = [f1,f2,f3];

end

%% IMOP6
function f = IMOP6(x)

dim = length(x);

a2 = 0.05;
a3 = 10;
K = 5;

y2 = mean(x(1:2:K))^a2;
y3 = mean(x(2:2:K))^a3;
g = sum((x(K+1:dim) - 0.5).^2);

r  = max(0,min(sin(3*pi*y2)^2,sin(3*pi*y3)^2)-0.05);

f1 = (1 + g) * y2 + ceil(r);                  	% 目标函数1
f2 = (1 + g) * y3 + ceil(r);                   	% 目标函数2
f3 = (0.5 + g) * (2 - y2 - y3) + ceil(r);     	% 目标函数3

f = [f1,f2,f3];

end

%% IMOP7
function f = IMOP7(x)

dim = length(x);

a2 = 0.05;
a3 = 10;
K = 5;

y2 = mean(x(1:2:K))^a2;
y3 = mean(x(2:2:K))^a3;
g = sum((x(K+1:dim) - 0.5).^2);

h1 = (1 + g) * cos(1/2*pi*y2) * cos(1/2*pi*y3);
h2 = (1 + g) * cos(1/2*pi*y2) * sin(1/2*pi*y3);
h3 = (1 + g) * sin(1/2*pi*y2);
r  = min(min(abs(h1-h2),abs(h2-h3)),abs(h3-h1));

f1 = h1 + 10 * max(0,r-0.1);                  	% 目标函数1
f2 = h2 + 10 * max(0,r-0.1);                   	% 目标函数2
f3 = h3 + 10 * max(0,r-0.1);                    % 目标函数3

f = [f1,f2,f3];

end

%% IMOP8
function f = IMOP8(x)

dim = length(x);

a2 = 0.05;
a3 = 10;
K = 5;

y2 = mean(x(1:2:K))^a2;
y3 = mean(x(2:2:K))^a3;
g = sum((x(K+1:dim) - 0.5).^2);

f1 = y2;                                      	% 目标函数1
f2 = y3;                                        % 目标函数2
f3 = (1 + g) * (3 - (y2 * (1 + sin(19 * pi * y2)) / (1 + g) + ...
    y3 * (1 + sin(19 * pi * y3)) / (1 + g)));	% 目标函数3

f = [f1,f2,f3];

end