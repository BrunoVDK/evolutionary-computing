function NewChromosome = xunnamed(OldChromosome, CrossoverRate, ctx)

    if nargin < 2, CrossoverRate = NaN; end
    [rows,cols] = size(OldChromosome);
    NewChromosome = OldChromosome; % Initialise new chromosome matrix
    for row = 1:2:(rows-rem(rows,2)) % Mate parents
        if rand < CrossoverRate % Recombine with a given probability
            NewChromosome(row,:) = unnamed(OldChromosome(row,:), OldChromosome(row+1,:), ctx.dist);
            NewChromosome(row+1,:) = unnamed(OldChromosome(row+1,:), OldChromosome(row,:), ctx.dist);
        end
    end
    
    % Create offspring
    function offspring = unnamed(first, second, dist)
        city = randi(cols);
        offspring = [city zeros(1,cols-1)];
        for i = 2:cols
            idx1 = find(first == city);
            idx2 = find(second == city);
            newcity = next(idx1,first);
            d = dist(city,newcity);
            potcity = prev(idx1,first);
            if dist(city,potcity) < d
                newcity = potcity;
                d = dist(city,newcity);
            end
            potcity = next(idx2,second);
            if dist(city,potcity) < d
                newcity = potcity;
                d = dist(city,newcity);
            end
            potcity = prev(idx2,second);
            if dist(city,potcity) < d
                newcity = potcity;
            end
            first(idx1) = 0;
            second(idx2) = 0;
            offspring(i) = newcity;
            city = newcity;
        end
        function n = next(idx, chromosome)
            idx = idx + 1 - cols * (idx == cols);
            while chromosome(idx) == 0
                idx = idx + 1 - cols * (idx == cols);
            end
            n = chromosome(idx);
        end
        function p = prev(idx, chromosome)
            idx = idx - 1 + cols * (idx == 1);
            while chromosome(idx) == 0
                idx = idx - 1 + cols * (idx == 1);
            end
            p = chromosome(idx);
        end
    end
   
end