function NewChromosome = xposition_based(OldChromosome, CrossoverRate)

    if nargin < 2, CrossoverRate = NaN; end
    [rows,cols] = size(OldChromosome);
    NewChromosome = OldChromosome; % Initialise new chromosome matrix
    for row = 1:2:(rows-rem(rows,2)) % Mate parents
        if rand < CrossoverRate % Recombine with a given probability
            positions = randperm(randi(cols));
            NewChromosome(row,:) = position(OldChromosome(row,:), OldChromosome(row+1,:), left, right);
            NewChromosome(row+1,:) = position(OldChromosome(row+1,:), OldChromosome(row,:), left, right);
        end
    end
    
    % Create offspring
    function offspring = position(first, second, left, right)
        
        offspring = first;
        idx = right;
        for i = right+1:cols
            idx = idx + 1 - cols * (idx == cols);
            while ismember(second(idx),first(left:right))
                idx = idx + 1 - cols * (idx == cols);
            end
            offspring(i) = second(idx);
        end
        for i = 1:left-1
            idx = idx + 1 - cols * (idx == cols);
            while ismember(second(idx),first(left:right))
                idx = idx + 1 - cols * (idx == cols);
            end
            offspring(i) = second(idx);
        end
    end
   
end