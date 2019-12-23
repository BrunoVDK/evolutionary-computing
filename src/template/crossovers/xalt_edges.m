% Alternating edge crossover
%   Adaptation of Tim's code :
%   KULeuven, december 2002 
%   email: Tim.Volodine@cs.kuleuven.ac.be
function NewChromosome = xalt_edges(OldChromosome, CrossoverRate)
   if nargin < 2, CrossoverRate = NaN; end
   rows = size(OldChromosome,1);
   NewChromosome = OldChromosome; % Initialise new chromosome matrix
   for row = 1:2:(rows-rem(rows,2)) % Mate parents
        if rand < CrossoverRate % Recombine with a given probability
            NewChromosome(row,:) = cross_alternate_edges([OldChromosome(row,:) ; OldChromosome(row+1,:)]);
            NewChromosome(row+1,:) = cross_alternate_edges([OldChromosome(row+1,:) ; OldChromosome(row,:)]);
        end
   end
end