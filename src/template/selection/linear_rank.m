function [selected] = linear_rank(chromosomes, cost_values, generational_gap)
    fitness_values = ranking(cost_values); % Linear ranking, selective pressure = 2
    selected = select('sus', chromosomes, fitness_values, generational_gap);
end