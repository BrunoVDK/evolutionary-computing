function [selected] = exponential_rank(chromosomes, cost_values, generational_gap)
    n = size(chromosomes,1);
    c = 0.9; % 0 < c < 1, close to 1 = 'less exponential'
    cn = (c-1)/(c^n-1);
    rank_fitnesses = cn * c .^ (n - (1:n)); % Fitness to assign to each rank
    fitness_values = ranking(cost_values, rank_fitnesses); % Ranking assumes minimisation problem
    selected = select('sus', chromosomes, fitness_values, generational_gap);
end