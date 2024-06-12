%% 确定个体是否被支配
function Pop = DetermineDomination(PopSize,Pop)

% 给所有个体赋默认值 0表示不被支配 1表示被支配
for i = 1 : PopSize
    Pop(i).IsDominated = 0;
end

% 两两个体进行比较，查找出被支配的个体，并赋值1
for i = 1 : PopSize - 1
    for j = i + 1 : PopSize
        % 判断个体i是否支配个体j
        if all(Pop(i).Fitness <= Pop(j).Fitness) && any(Pop(i).Fitness < Pop(j).Fitness)
            Pop(j).IsDominated = 1;
        end
        
        % 判断个体j是否支配个体i
        if all(Pop(j).Fitness <= Pop(i).Fitness) && any(Pop(j).Fitness < Pop(i).Fitness)
            Pop(i).IsDominated = 1;
        end
    end
end

end