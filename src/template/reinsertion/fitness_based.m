function [chromosomes,cost_values] = fitness_based(chromosomes, selected, ...
    cost_values, selected_cost_values)
    % The code in reins.m in the toolbox does the following :
    %   sort the negative of the cost_values
    %   take the first n indices of the result (= n worst individuals)
    %   replace them
    % => == 'Replace worst' (p. 88)
    [chromosomes,cost_values] = reins(chromosomes, selected, 1, 1, cost_values, selected_cost_values);
end