function [chromosomes,cost_values] = uniform(chromosomes, selected, ...
    cost_values, selected_cost_values)
    % The code in reins.m in the toolbox does the following :
    %   sort n random values
    %   take the first n indices of the result (= corresponding to n lowest values)
    %   replace the individuals at these indices
    % => == 'Uniform parent selection' (p. 86) here applied as survivor selection
    [chromosomes,cost_values] = reins(chromosomes, selected, 1, 0, cost_values, selected_cost_values);
end