function NewChromosome = xseq_constructive(OldChromosome, CrossoverRate, ctx)

    if nargin < 2, CrossoverRate = NaN; end
    [rows,cols] = size(OldChromosome);
    NewChromosome = OldChromosome; % Initialise new chromosome matrix
    for row = 1:2:(rows-rem(rows,2)) % Mate parents
        if rand < CrossoverRate % Recombine with a given probability
            NewChromosome(row,:) = scx(OldChromosome(row,:), OldChromosome(row+1,:), ctx.dist);
            NewChromosome(row+1,:) = scx(OldChromosome(row+1,:), OldChromosome(row,:), ctx.dist);
        end
    end
    
    % Breed
    function offspring = scx(first, second, dist)
        offspring = zeros(1,cols);
        idx1 = randi(cols);
        node = first(idx1);
        idx2 = find(second == node);
        offspring(1) = node;
        for i = 2:cols
            while ismember(first(idx1), offspring(1:i))
                idx1 = idx1 + 1 - cols * (idx1 == cols);
            end
            while ismember(second(idx2), offspring(1:i))
                idx2 = idx2 + 1 - cols * (idx2 == cols);
            end
            nextnode1 = first(idx1);
            nextnode2 = second(idx2);
            dist1 = dist(node, nextnode1);
            dist2 = dist(node, nextnode2);
            if dist1 < dist2
                node = nextnode1;
                idx2 = find(second == node, 1);
            else
                node = nextnode2;
                idx1 = find(first == node, 1);
            end
            offspring(i) = node;
        end
    end
   
end