function NewChromosome = xposition_based(OldChromosome, CrossoverRate, ~)

    if nargin < 2, CrossoverRate = NaN; end
    [rows,cols] = size(OldChromosome);
    NewChromosome = OldChromosome; % Initialise new chromosome matrix
    for row = 1:2:(rows-rem(rows,2)) % Mate parents
        if rand < CrossoverRate % Recombine with a given probability
            positions = randperm(randi(cols));
            NewChromosome(row,:) = position(OldChromosome(row,:), OldChromosome(row+1,:), positions);
            NewChromosome(row+1,:) = position(OldChromosome(row+1,:), OldChromosome(row,:), positions);
        end
    end
    
    % Create offspring
    function offspring = position(first, second, positions)
        offspring = second;
        mask = second(positions);
        offspring(setdiff(1:cols,positions)) = first(not(ismember(first,mask)));
    end
   
end