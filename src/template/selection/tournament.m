function [selected] = tournament(chromosomes, cost_values, generational_gap, k, replace)

    % Init
    current = 1;
    n = size(cost_values,1);
    nb_sel = max(floor(n * generational_gap + 0.5), 2);
    if nargin < 4; k = 10; end % >> selection pressure as k increases
    if nargin < 5; replace = true; end
    possible_picks = 1:n;
    selected = zeros(nb_sel,size(chromosomes,2));
    
    % Select by playing tournaments
    while current <= nb_sel
        picks = possible_picks(randperm(n,min(n,k)));
        [~,idx] = min(cost_values(picks));
        best = picks(idx);
        selected(current,:) = chromosomes(best,:);
        current = current + 1;
        if ~replace
            possible_picks = possible_picks(possible_picks ~= best);
            n = n - 1;
        end
    end
    
end