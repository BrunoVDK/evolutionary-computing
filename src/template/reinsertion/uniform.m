function [chromosomes,cost_values] = uniform(chromosomes, selected, ...
    cost_values, selected_cost_values)
    [chromosomes,cost_values] = reins(chromosomes, selected, 1, 0, cost_values, selected_cost_values);
end