function [chromosomes,cost_values] = round_robin(chromosomes, selected, ...
    cost_values, selected_cost_values, q)
    if nargin < 5; q = 2; end
    merge = [chromosomes ; selected];
    merged_values = [cost_values ; selected_cost_values];
    n = size(merge, 1);
    if q < 1 || q > n - 1; error 'Invalid q value for round robin selection.'; end
    l = n - 1; % Number of opponents to pick from
    possible_picks = 2:n+1;
    wins = zeros(n,1);
    for i = 1:n
        opponents = possible_picks(randperm(l,q));
        wins(i) = sum(merged_values(opponents) > merged_values(i));
        possible_picks(i+1) = i;
    end
    best = sus(wins, size(chromosomes,1));
    % best = randperm(n, size(chromosomes,1));
    % [~,best] = maxk(wins, size(chromosomes,1));
    chromosomes = merge(best,:);
    cost_values = merged_values(best);
end