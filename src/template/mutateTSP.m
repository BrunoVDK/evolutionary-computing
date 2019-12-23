% MUTATETSP.M       (MUTATion for TSP high-level function)
%
% This function takes a matrix OldChrom containing the 
% representation of the individuals in the current population,
% mutates the individuals and returns the resulting population.
%
% Syntax:  NewChrom = mutate(MUT_F, OldChrom, MutOpt)
%
% Input parameter:
%    MUT_F     - String containing the name of the mutation function
%    OldChrom  - Matrix containing the chromosomes of the old
%                population. Each line corresponds to one individual.
%    MutOpt    - mutation rate
% Output parameter:
%    NewChrom  - Matrix containing the chromosomes of the population
%                after mutation in the same format as OldChrom.
function NewChromosome = mutateTSP(MUTATION_FUNCTION, OldChromosome, MutationRate, REPRESENTATION)
   if nargin < 2,  error('Not enough input parameters'); end
   NewChromosome = OldChromosome;
   for r = 1:size(OldChromosome,1)
       if rand < MutationRate
           NewChromosome(r,:) = feval(MUTATION_FUNCTION, OldChromosome(r,:), REPRESENTATION);
       end
   end
end