function [] = crossoverlatex(res, limits)

    if nargin < 2
        limits = [550 750];
    end
    
    % Load colormap
    l = colormap('lines');
    
    % Determine values per configuration
    Z = realmax * ones(1,9);
    %for tour = 1:4
        for i = 1:9
            r = res{i};
            best = min(r{1}); % min or mean for best tour or average best
            if best < Z(i)
                Z(i) = best(1);
            end
        end
    %end
    sortedZ = sort(Z);
    Z = reshape(Z,3,3);
    
    b = bar3(Z);
    set(b,'facecolor',l(1,:)); % Change color here
    ylabel('Mutation Rate');
    xlabel('Crossover Rate');
    xticklabels({'0.25','0.50','0.70'});
    yticklabels({'0.25','0.50','0.70'});
    zlim(limits);

    figure
    imagesc(Z);
    
    % Determine colors for heatmap
    colors = zeros(9,3);
    for x = 1:9
        colors(x,:) = brighten(l(1,:), .25 + (sortedZ(i) - limits(1))/(limits(2) - limits(1)) / 2);
    end
    colormap(colors)

end