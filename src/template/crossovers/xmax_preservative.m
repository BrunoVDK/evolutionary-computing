function NewChromosome = xmax_preservative(OldChromosome, CrossoverRate, ~)

    if nargin < 2, CrossoverRate = NaN; end
    [rows,cols] = size(OldChromosome);
    NewChromosome = OldChromosome; % Initialise new chromosome matrix
    for row = 1:2:(rows-rem(rows,2)) % Mate parents
        if rand < CrossoverRate % Recombine with a given probability
            span = floor(cols/2);
            left = randi(span+1);
            right = left + randi([min(span-1,10),span-1]);
            NewChromosome(row,:) = max_pres(OldChromosome(row,:), OldChromosome(row+1,:), left, right);
            NewChromosome(row+1,:) = max_pres(OldChromosome(row+1,:), OldChromosome(row,:), left, right);
        end
    end
    
    % Breed
    function offspring = max_pres(first, second, left, right)
        offspring = zeros(1,cols);
        cut = right - left + 1;
        subtour = first(left:right);
        offspring(1:cut) = subtour;
        offspring(cut+1:end) = second(~ismember(second,subtour));
    end
   
end