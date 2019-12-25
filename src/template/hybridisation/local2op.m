function [newpopulation] = local2op(population, popsize, ncities, dist, REPRESENTATION)

    for t = 1:popsize
        switch REPRESENTATION
            case 'adjacency'
                result = apply2opt(adj2path(population(t,:)));
                population(t,:) = path2adj(result);
            case 'path'
                population(t,:) = apply2opt(population(t,:));
            case 'ordinal'
                result = apply2opt(ord2path(population(t,:)));
                population(t,:) = path2ord(result);
        end
    end
    newpopulation = population;
    
    function [result] = apply2opt(chromosome)
        for i = 1:ncities-1
            for j = i+1:ncities-1
                if  (dist(chromosome(i),chromosome(j)) + dist(chromosome(i+1),chromosome(j+1)))...
                    < (dist(chromosome(i),chromosome(i+1)) + dist(chromosome(j),chromosome(j+1)))
                    temp = chromosome(i+1);
                    chromosome(i+1) = chromosome(j);
                    chromosome(j) = temp;
                end
            end
        end
        result = chromosome;
    end
    
end