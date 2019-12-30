function [best,worst,average,times,gen] = test_default(NIND, MAXGEN, PR_CROSS, PR_MUT, REPETITIONS, STOP_CRITERION)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DEFAULT CONFIGURATION
    %NIND=50;		% Number of individuals
    %MAXGEN=100;		% Maximum no. of generations
    ELITIST=0.05;    % percentage of the elite population
    STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
    %PR_CROSS=.70;     % probability of crossover
    %PR_MUT=.20;       % probability of mutation
    LOCALLOOP=0;      % local loop removal
    CROSSOVER = 'xalt_edges';  % default crossover operator
    REPRESENTATION = 'adjacency'; % default representation
    MUTATION = 'simple_inversion'; % default mutation
    SCALING = false; % scale path yes or no
    HEURISTIC = "hybridisation_off"; % Local heuristic mode
    PARENT_SELECTION = 'linear_rank';
    SURVIVOR_SELECTION = 'fitness_based';
    DIVERSIFICATION = 1; % set to two for island model
    %STOP_CRITERION = 1; % set to two for our own stop criterion
    %REPETITIONS = 20;
    ADAPTIVE = 1; % 2 to set it on
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %if STOP_CRITERION > 2
     %   disp('Convergence speed test');
    %else
     %   disp('Fitness test');
    %end
    
    %display('NIND ' + num2str(NIND) + ' MAXGEN ' + num2str(MAXGEN) + ' PR_CROSS ' + PR_CROSS ...
     %   + ' PR_MUT ' + PR_MUT + ' REPETITIONS ' + REPETITIONS + ' STOP_CRITERION ' ...
      %  + STOP_CRITERION);
        

    if nargin < 1
        print = false;
    end
    
    datasets = ["datasets/rondrit051.tsp",...
            "datasets/rondrit127.tsp",...
            "datasets/bcl380.tsp"];

    sample = datasets(:);
    best = zeros(REPETITIONS,length(sample));
    worst = zeros(REPETITIONS,length(sample));
    average = zeros(REPETITIONS,length(sample));
    generations = zeros(REPETITIONS,length(sample));
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
            [bs,avg,wst,gen] = run_ga(x, ...
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
            %if print
             %   fprintf("CPU time : %.2fs\n", time);
              %  fprintf("Results for single run : best = %.2f, avg = %.2f, worst = %.2f\n", bs, avg, wst);
            %end
            totaltime = totaltime + time;
            best(r,i) = bs;
            worst(r,i) = wst;
            average(r,i) = avg;
            generations(r,i) = gen;
        end
        if STOP_CRITERION < 3 % test on fitness
            fprintf('Route:\t ' +  dataset + '\t avg best:\t' + num2str(mean(best(:,i))) + '\t stdev best:\t' + num2str(std(best(:,i))) + '\n');
        else % test on convergence speed
            fprintf('Route:\t ' +  dataset + '\t avg gen:\t' + num2str(mean(gen(:,i))) + '\t stdev gen:\t ' + num2str(std(gen(:,i))) + '\n');
        end
        times(i) = totaltime;
    end
    
    best = mean(best);
    worst = mean(worst);
    average = mean(average);
    gen = mean(generations);
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

