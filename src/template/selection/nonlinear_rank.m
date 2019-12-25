function [selected] = nonlinear_rank(chromosomes, cost_values, generational_gap)
    fitness_values = ranking(cost_values, [2 1]); % Ranking assumes minimisation problem
    selected = select('sus', chromosomes, fitness_values, generational_gap);
end