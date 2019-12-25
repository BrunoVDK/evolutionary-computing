function [selected] = sigma_scaling(chromosomes, cost_values, generational_gap)
    geom_mean = mean(cost_values);
    dev = std(cost_values);
    fitness_values = max(0, cost_values - (geom_mean - 2 * dev));
    selected = select('sus', chromosomes, fitness_values, generational_gap);
end