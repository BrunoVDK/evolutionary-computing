function NewChromosome = xtemplate(OldChromosome, CrossoverRate)
   if nargin < 2, CrossoverRate = NaN; end
   rows = size(OldChromosome,1);
   NewChromosome = OldChromosome; % Initialise new chromosome matrix
   for row = 1:2:(rows-rem(rows,2)) % Mate parents
        if rand < CrossoverRate % Recombine with a given probability
            NewChromosome(row,:) = NewChromosome(row,:); % TODO fill in appropriate function (first kid)
            NewChromosome(row+1,:) = NewChromosome(row+1,:); % TODO fill in appropriate function (second kid)
        end
   end
end