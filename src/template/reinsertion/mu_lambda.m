% (µ + ¬) selection
function [chromosomes,cost_values] = mu_lambda(chromosomes, selected, ...
    cost_values, selected_cost_values)
    merge = [chromosomes ; selected];
    merged_values = [cost_values ; selected_cost_values];
    [~,best] = mink(merged_values,size(chromosomes,1));
    chromosomes = merge(best,:);
    cost_values = merged_values(best);
end