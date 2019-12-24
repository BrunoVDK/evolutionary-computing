function NewChromosome = xedge_recombination(OldChromosome, CrossoverRate)

    if nargin < 2, CrossoverRate = NaN; end
    
    % Initialise edge map
    [rows,cols] = size(OldChromosome);
    edge_map = zeros(cols,5);
    
    % Initialise new chromosome matrix
    NewChromosome = OldChromosome; 
    for row = 1:2:(rows-rem(rows,2)) % Mate parents
        if rand < CrossoverRate % Recombine with a given probability
            map = edge_map_make(OldChromosome(row,:), OldChromosome(row+1,:));
            edge_map = map;
            NewChromosome(row,:) = erx(OldChromosome(row,:));
            edge_map = map;
            NewChromosome(row+1,:) = erx(OldChromosome(row+1,:));
        end
    end
    
    % Create offspring
    function offspring = erx(parent)
        offspring = zeros(1,cols);
        offspring(1) = parent(randi(cols));
        for i = 2:cols
            offspring(i) = get_next_city(offspring(i-1));
        end
    end
    
    % Create edge map
    function [map] = edge_map_make(first, second)
        map = zeros(cols,5);
        for i = 1:cols
            el = first(i);
            j = find(second == el, 1);
            edge_list = unique([
                first((i - 1) + cols * (i == 1)) ...
                first((i + 1) - cols * (i == cols)) ...
                second((j - 1) + cols * (j == 1)) ...
                second((j + 1) - cols * (j == cols))
            ]);
            map(el,1:size(edge_list,2)+1) = [size(edge_list,2) edge_list];
        end
    end

    % Remove element from edge map
    function [next_city] = get_next_city(el) % el is current city
        neighbors = edge_map(el,1);
        if neighbors > 0
            edge_list = edge_map(el,2:1+neighbors);
            neighbors_els = edge_map(edge_list,1);
            next_cities = edge_list(neighbors_els == min(neighbors_els));
            next_city = next_cities(randi(size(next_cities)));
            for e = edge_list
                if edge_map(e,1) >= 0
                    idx = find(edge_map(e,2:end) == el, 1);
                    if ~isempty(idx) 
                        edge_map(e, 1+idx) = edge_map(e, 1+edge_map(e,1));
                    end
                end
            end
            edge_map(edge_list,1) = neighbors_els - 1;
        else
            next_cities = find(edge_map(:,1) >= 0);
            next_city = next_cities(randi(size(next_cities,1)));
%             random_idx = randi(nb_tovisit);
%             idx = 0;
%             next_city = 0;
%             while idx < random_idx
%                 next_city = next_city + 1;
%                 idx = idx + (edge_map(next_city,1) >= 0);
%             end
        end
        edge_map(el,1) = -1;
    end
   
end