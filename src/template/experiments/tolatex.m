function tolatex(results, calibration, filePath)

    if nargin < 3
        filePath = '/Users/Bruno/Desktop/output.txt';
    end

    fileID = fopen(filePath, 'w');
    
    if nargin < 2
        minima = ones(1,4) * realmax; % minima of best fitnesses
        maxima = zeros(1,4); % maxima of best fitnesses
        for x = 1:length(results)
            result = results{x};
            bests = result{1};
            mi = min(bests);
            ma = max(bests);
            for i = 1:4
                if mi(i) < minima(i); minima(i) = mi(i); end
                if ma(i) > maxima(i); maxima(i) = ma(i); end
            end
        end
    else
        minima = ones(1,4) * realmax; % minima of best fitnesses
        maxima = zeros(1,4); % maxima of best fitnesses
        for x = 1:length(calibration)
            result = calibration{x};
            bests = result{1};
            mi = min(bests);
            ma = max(bests);
            for i = 1:4
                if mi(i) < minima(i); minima(i) = mi(i); end
                if ma(i) > maxima(i); maxima(i) = ma(i); end
            end
        end
    end
        
    idx = 1;
    for NIND = [150]
        for PR_MUT = [10, 25, 50, 75, 95]
            for PR_CROSS = [5, 25, 50, 75, 95]
                for ELITIST = [10, 20, 40]
                    result = results{idx};
                    bests = result{1};
                    mibests = min(bests);
                    prop = max(1,80-floor(300 * (mibests - minima) ./ (maxima - minima))); % Use 2.^ instead of 300* for clearer difference
                    tt = sum(result{4});
                    fprintf(fileID, "%i & %i & %i & \\cellcolor{gray!%i}%.2f & \\cellcolor{gray!%i}%.2f & \\cellcolor{gray!%i}%.2f & \\cellcolor{gray!%i}%.2f & %.2f\\\\\n", PR_CROSS, PR_MUT, ELITIST, prop(1), mibests(1), prop(2), mibests(2), prop(3), mibests(3), prop(4), mibests(4), tt);
                    idx = idx + 1;
                end
            end
        end
    end
    
    fclose(fileID);

end