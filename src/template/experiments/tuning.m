function [best,worst,average,times] = tuning(print)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DEFAULT CONFIGURATION
    NIND=50;		% Number of individuals
    MAXGEN=100;		% Maximum no. of generations
    ELITIST=0.05;    % percentage of the elite population
    STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
    PR_CROSS=.95;     % probability of crossover
    PR_MUT=.05;       % probability of mutation
    LOCALLOOP=0;      % local loop removal
    CROSSOVER = 'xunnamed';  % default crossover operator
    REPRESENTATION = 'path'; % default representation
    MUTATION = 'inversion'; % default mutation
    SCALING = false; % scale path yes or no
    HEURISTIC = "hybridisation off"; % Local heuristic mode
    PARENT_SELECTION = 'linear_rank';
    SURVIVOR_SELECTION = 'fitness_based';
    DIVERSIFICATION = 1;
    STOP_CRITERION = 1;
    REPETITIONS = 5;
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
            "datasets/rondrit127.tsp"];

    sample = datasets(1:5);
    best = zeros(REPETITIONS,length(sample));
    worst = zeros(REPETITIONS,length(sample));
    average = zeros(REPETITIONS,length(sample));
    times = zeros(1,length(sample));
        
    for i = 1:length(sample)
        
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
                HEURISTIC == "seeding" || HEURISTIC == "both", ...
                HEURISTIC == "2-opt" || HEURISTIC == "both", ...
                PARENT_SELECTION, ...
                SURVIVOR_SELECTION, ...
                false, ...
                DIVERSIFICATION, ...
                STOP_CRITERION);
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

