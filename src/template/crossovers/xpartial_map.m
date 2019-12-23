function NewChromosome = xpartially_mapped(OldChromosome, CrossoverRate)

    if nargin < 2, CrossoverRate = NaN; end
    [rows,cols] = size(OldChromosome);
    NewChromosome = OldChromosome; % Initialise new chromosome matrix
    for row = 1:2:(rows-rem(rows,2)) % Mate parents
        if rand < CrossoverRate % Recombine with a given probability
            [left, right] = cut_points(cols);
            NewChromosome(row,:) = partial_map(OldChromosome(row,:), OldChromosome(row+1,:), left, right);
            NewChromosome(row+1,:) = partial_map(OldChromosome(row+1,:), OldChromosome(row,:), left, right);
        end
    end
    
    % Breed
    function offspring = partial_map(first, second, left, right)
        % Two versions : one with in-built functions, one with basic
        %   control flow
        % Second version is (quite a lot) faster but more verbose.
%         mapping = second(left:right);
%         diff = setdiff(first(left:right), mapping, 'stable');
%         cut1 = first(1:left-1);
%         duplicates = ismember(cut1,mapping);
%         cut1(duplicates) = diff(1:nnz(duplicates));
%         cut2 = first(right+1:cols);
%         cut2(ismember(cut2,mapping)) = diff(nnz(duplicates)+1:end);
%         offspring = [cut1 mapping cut2];
        offspring = zeros(1,cols);
        offspring(left:right) = second(left:right);
        idx = left;
        for i = 1:left-1
            if ismember(first(i),offspring)
                while ismember(first(idx),offspring)
                    idx = idx + 1;
                end
                offspring(i) = first(idx);
            else
                offspring(i) = first(i);
            end
        end
        for i = right+1:cols
            if ismember(first(i),offspring)
                while ismember(first(idx),offspring)
                    idx = idx + 1;
                end
                offspring(i) = first(idx);
            else
                offspring(i) = first(i);
            end
        end
    end
   
end