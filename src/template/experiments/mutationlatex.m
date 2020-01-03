function mutationlatex
    
    mi = realmax * ones(1,4);
    ma = zeros(1,4);
    for m = ["displacement", "insertion", "inversion", "reciprocal_exchange", "scramble", "unnamed"]
        for c = ["xedge_heuristic", "xposition_based", "xseq_constructive", "xunnamed"]
            clear results;
            l = load(c + '_' + m);
            results = l.results;
            for rate = 1:4 %[20, 40, 50, 70] (mutation rate)
                r = results{rate};
                newbest = mean(r{1}); % Take the best tours (can take mean also)
                mi = min([mi ; newbest]);
                ma = max([ma ; newbest]);
            end            
        end
    end

    for c = ["xedge_heuristic", "xposition_based", "xseq_constructive", "xunnamed"]
        mat = zeros(6,4);
        idx = 1;
        for m = ["displacement", "insertion", "inversion", "reciprocal_exchange", "scramble", "unnamed"]
            clear results;
            l = load(c + '_' + m);
            results = l.results;
            for rate = 4:4 %[20, 40, 50, 70] (mutation rate) % Do all rates here for full report
                r = results{rate};
                mat(idx,:) = mean(r{1}) ./ mi; % Take the best tours (can take mean also)
                idx = idx + 1;
            end            
        end
        f = figure('visible', 'off', 'Position', [0 0 650 100]);
        bar(mat);
        xticklabels(["displacement", "insertion", "inversion", "reciprocal\_exchange", "scramble", "unnamed"]);
        yticks([1]); %#ok
        yticklabels(["Mininimum"]);
        ylim([0.9 3.0]);
        saveas(f, c + '.png');
    end

end