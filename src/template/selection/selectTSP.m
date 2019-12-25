function [selected] = selectTSP(SELECTION, chromosomes, cost_values, generational_gap)
    selected = feval(SELECTION, chromosomes, cost_values, generational_gap);
end

