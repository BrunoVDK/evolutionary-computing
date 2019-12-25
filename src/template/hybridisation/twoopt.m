function [newpopulation] = twoopt(population, popsize, ncities, dist, REPRESENTATION)

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
        for i = 1:ncities
            if i == ncities
                i2 = i;
            else
                i2 = i+1;
            end
            for j = i+1:ncities
                if j == ncities
                    j2 = j;
                else
                    j2 = j+1;
                end
                if  (dist(chromosome(i),chromosome(j)) + dist(chromosome(i2),chromosome(j2)))...
                    < (dist(chromosome(i),chromosome(i2)) + dist(chromosome(j),chromosome(j2)))
                    temp = chromosome(i2);
                    chromosome(i2) = chromosome(j);
                    chromosome(j) = temp;
                end
            end
        end
        result = chromosome;
    end
    
end