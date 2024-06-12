%% 确定Rep中每个个体的网格索引
function Particle = FindGridIndex(Particle,FuncNum,GridNum,Grid)

% 找到每个目标函数所属目标网格的索引
Particle.GridSubIndex = zeros(1,FuncNum);
for j = 1 : FuncNum
    Particle.GridSubIndex(j) = find(Particle.Fitness(j) < Grid(j).UB,1,'first');
end

% 找到个体所在超网格的索引
Particle.GridIndex = Particle.GridSubIndex(1);
for j = 2 : FuncNum
    Particle.GridIndex = Particle.GridIndex - 1;
    Particle.GridIndex = GridNum * Particle.GridIndex;
    Particle.GridIndex = Particle.GridIndex + Particle.GridSubIndex(j);
end

end