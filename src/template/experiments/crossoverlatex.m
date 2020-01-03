function [] = crossoverlatex(res, calibration, name)

    mi = realmax * ones(1,4);
    ma = zeros(1,4);
    for i = 1:length(calibration)
        test = calibration{i};
        for j = 1:length(test)
            newbest = min(test{1}); % Take the best tours (can take mean also)
            mi = min([mi ; newbest]);
            ma = max([ma ; newbest]);
        end
    end
    
    % Load colormap
    l = colormap('lines');
    
    for dataset = 1:4
        
        limits = [mi(dataset) ma(dataset)];
        
        % Determine values per configuration
        Z = realmax * ones(1,9);
        for i = 1:9
            r = res{i};
            best = min(r{1}); % min or mean for best tour or average best
            Z(i) = best(dataset);
        end
        sortedZ = sort(Z);
        Z = reshape(Z,3,3);

        % Bar chart
        fig = figure('visible','off','Position', [0 0 300 300]);
        chart = bar3(Z);
        set(chart,'facecolor',l(dataset,:)); % Change color here
        %ylabel('Crossover Rate');
        %xlabel('Mutation Rate');
        xticklabels({'0.25','0.50','0.70'});
        yticklabels({'0.25','0.50','0.70'});
        zlim(limits);
        saveas(fig,"cross_" + name + "_" + dataset + ".png");

        % Heatmap
%         figure
%         imagesc(Z);
%         % Determine colors for heatmap
%         colors = zeros(9,3);
%         for x = 1:9
%             colors(x,:) = brighten(l(dataset,:), .25 + (sortedZ(i) - limits(1))/(limits(2) - limits(1)) / 2);
%         end
%         colormap(colors)
        
    end
    
    close all;

end