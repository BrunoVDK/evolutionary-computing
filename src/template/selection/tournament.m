function [selected] = tournament(chromosomes, cost_values, generational_gap, k, replace, p)

    if nargin < 6; p = 0.5; end % Selection probability (larger ==> increases selective pressure)
    if nargin < 4; k = 2; end % >> selection pressure as k increases
    if nargin < 5; replace = true; end

    % Precalculated probabilities
    %   I used min before, but it lead to fast convergence
    probs = [cumsum((p*(1-p) .^ ((1:k-1)-1)) / (1 - (1-p)^k)) 1.0];

    % Init
    current = 1;
    n = size(cost_values,1);
    nb_sel = max(floor(n * generational_gap + 0.5), 2);
    possible_picks = 1:n;
    selected = zeros(nb_sel,size(chromosomes,2));
    
    % Select by playing tournaments
    while current <= nb_sel
        picks = possible_picks(randperm(n,min(n,k)));
        if k == 1
            best = picks(1);
        else
            [~,indices] = sort(cost_values(picks));
            best = picks(indices(find(rand < probs, 1)));
        end
        selected(current,:) = chromosomes(best,:);
        current = current + 1;
        if ~replace
            possible_picks = possible_picks(possible_picks ~= best);
            n = n - 1;
        end
    end
    
end