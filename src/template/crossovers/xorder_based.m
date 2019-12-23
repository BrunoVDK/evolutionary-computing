function NewChromosome = xorder_based(OldChromosome, CrossoverRate)

    if nargin < 2, CrossoverRate = NaN; end
    [rows,cols] = size(OldChromosome);
    NewChromosome = OldChromosome; % Initialise new chromosome matrix
    for row = 1:2:(rows-rem(rows,2)) % Mate parents
        if rand < CrossoverRate % Recombine with a given probability
            positions = randperm(randi(cols));
            NewChromosome(row,:) = order(OldChromosome(row,:), OldChromosome(row+1,:), positions);
            NewChromosome(row+1,:) = order(OldChromosome(row+1,:), OldChromosome(row,:), positions);
        end
    end
    
    % Create offspring
    function offspring = order(first, second, positions)
        offspring = first;
        matches = second(positions);
        mask = ismember(offspring,matches);
        offspring(mask) = second(ismember(second,first(mask)));
    end
   
end