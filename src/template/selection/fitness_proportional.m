function [selected] = fitness_proportional(chromosomes, cost_values, generational_gap)
    selected = select('sus', chromosomes, cost_values, generational_gap);
end