% A little word about this function...
% It is pretty much identical to the one in the toolbox, but we did not want
%   to alter the toolbox (or updating only the toolbox might break things).
function NewChrom = recombineTSP(CROSSOVER, Parents, CrossoverRate, NbSubPopulations, ctx)

    if nargin < 2, error('Not enough input parameter'); end

    [Nind,~] = size(Parents);

    if nargin < 4, NbSubPopulations = 1; end
    if nargin > 3
        if isempty(NbSubPopulations), NbSubPopulations = 1;
        elseif isnan(NbSubPopulations), NbSubPopulations = 1;
        elseif length(NbSubPopulations) ~= 1, error('SUBPOP must be a scalar'); 
        end
    end

    if (Nind/NbSubPopulations) ~= fix(Nind/NbSubPopulations) % fix = round towards zero
        error('Chrom and SUBPOP disagree'); 
    end
    Nind = Nind/NbSubPopulations;  % Compute number of individuals per subpopulation

    if nargin < 3, CrossoverRate = 0.7; end
    if nargin > 2
        if isempty(CrossoverRate), CrossoverRate = 0.7;
        elseif isnan(CrossoverRate), CrossoverRate = 0.7;
        elseif length(CrossoverRate) ~= 1, error('Crossover rate must be a scalar');
        elseif (CrossoverRate < 0 || CrossoverRate > 1), error('Crossover rate must be a scalar in [0, 1]'); 
        end
    end
    
    NewChrom = zeros(size(Parents));
    for irun = 1:NbSubPopulations
        indices = (irun-1)*Nind+1:irun*Nind; % Indices for subpopulation
        SubPopulation = Parents(indices,:); % Chromosomes for subpopulation
        NewChrom(indices,:) = feval(CROSSOVER, SubPopulation, CrossoverRate, ctx);
    end
    
end