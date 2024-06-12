%% 变异操作
function NewParticle = Mutate(Particle,Pm,lb,ub,dim)

j = randi([1 dim]);             % 随机产生一个1-dim的位置序号
dp = Pm * (ub(j) - lb(j));    	% 位置的缩放区间

dplb = Particle(j) - dp;        % 位置的变异下限
dpub = Particle(j) + dp;        % 位置的变异上限
dplb = max(dplb,lb(j));
dpub = min(dpub,ub(j));

NewParticle = Particle;
NewParticle(j) = unifrnd(dplb,dpub);

end