function NewChromosome = xcycle(OldChromosome, CrossoverRate)

    if nargin < 2, CrossoverRate = NaN; end
    [rows,cols] = size(OldChromosome);
    NewChromosome = OldChromosome; % Initialise new chromosome matrix
    for row = 1:2:(rows-rem(rows,2)) % Mate parents
        if rand < CrossoverRate % Recombine with a given probability
            [NewChromosome(row,:),NewChromosome(row+1,:)] = cycles(OldChromosome(row+1,:), OldChromosome(row,:));
        end
    end
    
    % Create offspring
    function [o1,o2] = cycles(left,right)
        o1 = zeros(1,cols);
        o2 = zeros(1,cols);
        idx = 1;
        while nnz(o1) < cols
            while 1
                o1(idx) = left(idx);
                o2(idx) = right(idx);
                idx = find(left == right(idx));
                if o1(idx) > 0
                    break;
                end
            end
            idx = find(o1 == 0, 1);
            [left,right] = deal(right,left);
        end
    end
   
end