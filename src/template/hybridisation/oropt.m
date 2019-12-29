function [newpopulation] = oropt(population, popsize, ncities, dist, REPRESENTATION)

    for t = 1:popsize
        switch REPRESENTATION
            case 'adjacency'
                result = applyoropt(adj2path(population(t,:)));
                population(t,:) = path2adj(result);
            case 'path'
                population(t,:) = applyoropt(population(t,:));
            case 'ordinal'
                result = applyoropt(ord2path(population(t,:)));
                population(t,:) = path2ord(result);
        end
    end
    newpopulation = population;
    
    function [result] = applyoropt(chromosome)
        for l = 3:-1:1
            for i = 2:ncities-l
                for j = i+l:ncities-1
                    if  dist(chromosome(i-1),chromosome(i)) + ...
                        dist(chromosome(i+l-1),chromosome(i+l)) + ...
                        dist(chromosome(j),chromosome(j+1)) > ...
                        dist(chromosome(j),chromosome(i)) + ...
                        dist(chromosome(i+l-1),chromosome(j+1)) + ...
                        dist(chromosome(i-1),chromosome(i+l))
                        chromosome = [chromosome(1:i-1) chromosome(i+l:j) chromosome(i:i+l-1) chromosome(j+1:end)];
                        i = i-1;
                        break;
                    end
                end
            end
        end
        result = chromosome;
    end
    
end