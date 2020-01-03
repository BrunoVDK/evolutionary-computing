function [results] = tuninglatex(print)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DEFAULT CONFIGURATION
    %NIND=300;		% Number of individuals
    MAXGEN=1000;		% Maximum no. of generations
    %ELITIST=0.05;    % percentage of the elite population
    STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
    %PR_CROSS=.95;     % probability of crossover
    %PR_MUT=.05;       % probability of mutation
    LOCALLOOP=0;      % local loop removal
    %CROSSOVER = 'xalt_edges';  % default crossover operator
    %REPRESENTATION = 'adjacency'; % default representation
    %MUTATION = 'simple_inversion'; % default mutation
    SCALING = false; % scale path yes or no
    PARENT_SELECTION = 'linear_rank';
    SURVIVOR_SELECTION = 'fitness_based';
    DIVERSIFICATION = 1; % set to two for island model
    STOP_CRITERION = 1; % set to two for our own stop criterion
    REPETITIONS = 5;
    ADAPTIVE = 1; % 2 to set it on
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if nargin < 1
        print = false;
    end
    
    datasets = ["datasets/rondrit070.tsp",...
            "datasets/rondrit100.tsp",...
            "datasets/rondrit127.tsp",...
            "datasets/xqf131.tsp"];

    sample = datasets;
    
    
    for c = ["xposition_based"]
        
        for m = ["displacement", "insertion", "inversion", "reciprocal_exchange", "scramble", "unnamed"]
                    
            best = zeros(REPETITIONS,length(sample));
            worst = zeros(REPETITIONS,length(sample));
            average = zeros(REPETITIONS,length(sample));
            times = zeros(1,length(sample));

            idx = 1;
            results = {}; % one result per configuration

            for NIND = [50] %#ok
                for PR_MUT = [20, 40, 50, 70] / 100
                    for PR_CROSS = [50] / 100 %#ok
                        for ELITIST = [5] / 100 %#ok

                            for i = 1:length(sample)

                                dataset = sample(i);
                                data = load(dataset);
                                x = data(:,1); y = data(:,2);
                                load_set(data, SCALING);
                                NVAR=size(data,1);

                                if c == "xovsp"
                                    REPRESENTATION = 'ordinal';
                                else
                                    REPRESENTATION = 'path';
                                end

                                totaltime = 0;
                                for r = 1:REPETITIONS
                                    tic;
                                    [bs,avg,wst] = run_ga(x, ...
                                        y, ...
                                        NIND, ...
                                        MAXGEN, ...
                                        NVAR, ...
                                        ELITIST, ...
                                        STOP_PERCENTAGE, ...
                                        PR_CROSS, ...
                                        PR_MUT, ...
                                        c, ... % crossover
                                        LOCALLOOP, ...
                                        NaN, ...
                                        NaN, ...
                                        NaN, ...
                                        REPRESENTATION, ...
                                        m, ...
                                        false, ... % no hybridisation
                                        false, ... % no hybridisation
                                        false, ... % no hybridisation
                                        PARENT_SELECTION, ...
                                        SURVIVOR_SELECTION, ...
                                        false, ...
                                        DIVERSIFICATION, ...
                                        STOP_CRITERION, ...
                                        ADAPTIVE);
                                    time = toc;
        %                             if print
        %                                 fprintf("CPU time : %.2fs\n", time);
        %                                 fprintf("Results for single run : best = %.2f, avg = %.2f, worst = %.2f\n", bs, avg, wst);
        %                             end
                                    totaltime = totaltime + time;
                                    best(r,i) = bs;
                                    worst(r,i) = wst;
                                    average(r,i) = avg;
                                end
                                times(i) = totaltime;
                            end

        %                     best = mean(best);
        %                     worst = mean(worst);
        %                     average = mean(average);
                            times = times / REPETITIONS;

                            results{idx} = {best, worst, average, times} %#ok
                            idx = idx + 1;

                            if print
                                fprintf("Configuration %i %.2f %.2f %.2f %s %s\n", NIND, PR_CROSS, PR_MUT, ELITIST, c, m);
                                min(best)
                                fprintf("-----\n");
                            end

                        end
                    end
                end
            end
            
            save('results/mutation/' + c + '_' + m + '.mat', 'results');
        
        end
        
    end
        
    function load_set(data, scale)
        x = data(:,1);
        y = data(:,2);
        if scale
            x = x / max([data(:,1);data(:,2)]);
            y = y / max([data(:,1);data(:,2)]);
        end
    end
    
end

