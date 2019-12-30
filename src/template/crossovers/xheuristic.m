function NewChromosome = xheuristic(OldChromosome, CrossoverRate, ctx)

    if nargin < 2, CrossoverRate = NaN; end
    [rows,cols] = size(OldChromosome);
    NewChromosome = OldChromosome; % Initialise new chromosome matrix
    for row = 1:2:(rows-rem(rows,2)) % Mate parents
        if rand < CrossoverRate % Recombine with a given probability
            NewChromosome(row,:) = heuristic(OldChromosome(row+1,:), OldChromosome(row,:), ctx.dist);
            NewChromosome(row+1,:) = heuristic(OldChromosome(row,:), OldChromosome(row+1,:), ctx.dist);
        end
    end

    % Create offspring
    function [offspring] = heuristic(left, right, dist)
        city = randi(cols);
        first_city = city;
        offspring = zeros(1,cols);
        for i = 2:cols
            next1 = left(city);
            next2 = right(city);
            left(city) = 0;
            if  next2 == 0 || dist(city,next1) < dist(city,next2)
                next = next1;
            else
                next = next2;
            end
            if left(next) == 0 % Already visited (cycle)
                nonvisited = find(left > 0);
                next = nonvisited(randi(length(nonvisited)));
            end
            offspring(city) = next;
            city = next;
        end
        offspring(city) = first_city;
    end

end