function [best,worst,average,times] = tuning(print)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DEFAULT CONFIGURATION
    NIND=200;		% Number of individuals
    MAXGEN=300;		% Maximum no. of generations
    ELITIST=0.05;    % percentage of the elite population
    STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
    PR_CROSS=.70;     % probability of crossover
    PR_MUT=.55;       % probability of mutation
    LOCALLOOP=0;      % local loop removal
    CROSSOVER = 'xunnamed';  % default crossover operator
    REPRESENTATION = 'path'; % default representation
    MUTATION = 'inversion'; % default mutation
    SCALING = false; % scale path yes or no
    HEURISTIC = "both"; % Local heuristic mode
    PARENT_SELECTION = 'tournament';
    SURVIVOR_SELECTION = 'fitness_based';
    DIVERSIFICATION = 1; % set to two for island model
    STOP_CRITERION = 1; % set to two for our own stop criterion
    REPETITIONS = 10;
    ADAPTIVE = 1; % 2 to set it on
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if nargin < 1
        print = false;
    end
    
    datasets = ["datasets/rondrit016.tsp",...
            "datasets/rondrit018.tsp",...
            "datasets/rondrit023.tsp",...
            "datasets/rondrit025.tsp",...
            "datasets/rondrit048.tsp",...
            "datasets/rondrit050.tsp",...
            "datasets/rondrit051.tsp",...
            "datasets/rondrit067.tsp",...
            "datasets/rondrit070.tsp",...
            "datasets/rondrit100.tsp",...
            "datasets/rondrit127.tsp",...
            "datasets/belgiumtour.tsp",...
            "datasets/xqf131.tsp"];

    sample = datasets(4:6);
    best = zeros(REPETITIONS,length(sample));
    worst = zeros(REPETITIONS,length(sample));
    average = zeros(REPETITIONS,length(sample));
    times = zeros(1,length(sample));
        
    for i = length(sample):length(sample)
        
        dataset = sample(i);
        data = load(dataset);
        x = data(:,1); y = data(:,2);
        load_set(data, SCALING);
        NVAR=size(data,1);

        totaltime = 0;
        for r = 1:REPETITIONS
            time = toc;
            [bs,avg,wst] = run_ga(x, ...
                y, ...
                NIND, ...
                MAXGEN, ...
                NVAR, ...
                ELITIST, ...
                STOP_PERCENTAGE, ...
                PR_CROSS, ...
                PR_MUT, ...
                CROSSOVER, ...
                LOCALLOOP, ...
                NaN, ...
                NaN, ...
                NaN, ...
                REPRESENTATION, ...
                MUTATION, ...
                false, ... % no hybridisation
                false, ... % no hybridisation
                false, ... % no hybridisation
                PARENT_SELECTION, ...
                SURVIVOR_SELECTION, ...
                false, ...
                DIVERSIFICATION, ...
                STOP_CRITERION, ...
                ADAPTIVE);
            if print
                fprintf("CPU time : %.2fs\n", time);
                fprintf("Results for single run : best = %.2f, avg = %.2f, worst = %.2f\n", bs, avg, wst);
            end
            totaltime = totaltime + time;
            best(r,i) = bs;
            worst(r,i) = wst;
            average(r,i) = avg;
        end
        times(i) = totaltime;
    end
    
    best = mean(best);
    worst = mean(worst);
    average = mean(average);
    times = times / REPETITIONS;
    
    function load_set(data, scale)
        x = data(:,1);
        y = data(:,2);
        if scale
            x = x / max([data(:,1);data(:,2)]);
            y = y / max([data(:,1);data(:,2)]);
        end
    end
    
end

