% determine the optimal window size for the custom stopping criterion. To
% determine this, we let the GA run on every route 10 times with a certain
% fixed parameter configuration. We will allow each run to only have 100
% generations. In each run, we will determine the longest streak of having
% the same best value before an improvement happens. With this data, we
% determine a threshold, such that we know with 95% confidence that there will
% not be another improvement of the best value, once the threshold is
% reached.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONFIGURATION
NIND=50;		% Number of individuals
MAXGEN=500;		% Maximum no. of generations
ELITIST=0.05;    % percentage of the elite population
STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
PR_CROSS=.70;     % probability of crossover
PR_MUT=.55;       % probability of mutation
LOCALLOOP=0;      % local loop removal
CROSSOVER = 'xalt_edges';  % default crossover operator
REPRESENTATION = 'adjacency'; % default representation
MUTATION = 'simple_inversion'; % default mutation
SCALING = false; % scale path yes or no
HEURISTIC = "hybridisation_off"; % Local heuristic mode
PARENT_SELECTION = 'linear_rank';
SURVIVOR_SELECTION = 'fitness_based';
DIVERSIFICATION = 1; % set to two for island model
STOP_CRITERION = 1; % set to two for our own stop criterion
REPETITIONS = 20;
ADAPTIVE = 1; % 2 to set it on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
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

sample = datasets(:);
avg_default = zeros(1,13);
std_default = zeros(1,13);
avg_window = zeros(1,13);
std_window = zeros(1,13);
gen_default = zeros(1,13);
gen_window = zeros(1,13);

for i = 1:length(sample) 

    fprintf('%d / 13',i); 
    dataset = sample(i);
    data = load(dataset);
    x = data(:,1); y = data(:,2);
    load_set(data, SCALING);
    NVAR=size(data,1);
    
    best_l = zeros(1,REPETITIONS);
    gen_l = zeros(1,REPETITIONS);
    stop_best_l = zeros(1,REPETITIONS);
    stop_gen_l = zeros(1,REPETITIONS);

    totaltime = 0;
    for r = 1:REPETITIONS
        time = tic;
        [bs,avg,wst,gen,stop_gen,stop_best] = adapted_run_ga(x, ...
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
            2, ...
            ADAPTIVE);

        best_l(r) = bs(MAXGEN);
        gen_l(r) = gen;
        stop_best_l(r) = stop_best;
        stop_gen_l(r) = stop_gen;
    end
    avg_default(i) = mean(best_l);
    std_default(i) = std(best_l);
    gen_default(i) = mean(gen_l);
    avg_window(i) = mean(stop_best_l);
    std_window(i) = std(stop_best_l);
    gen_window(i) = mean(stop_gen_l);
end

result = zeros(size(datasets,2)+1,8);
result(1,:) = ['Route','# gen','avg best','std best','# gen (window)','avg best (window)','std best (window)','decrease quality'];
result(2:size(dataset,2)+1,1) = sample;
result(2:size(dataset,2)+1,2) = transpose(gen_default);
result(2:size(dataset,2)+1,3) = transpose(avg_default);
result(2:size(dataset,2)+1,4) = transpose(std_default);
result(2:size(dataset,2)+1,5) = transpose(gen_window);
result(2:size(dataset,2)+1,6) = transpose(avg_window);
result(2:size(dataset,2)+1,7) = transpose(std_window);
result(2:size(dataset,2)+1,8) = transpose(ones(1,13) - (avg_window / avg_default));





fprintf("DONE");
disp(result);

function load_set(data, scale)
    x = data(:,1);
    y = data(:,2);
    if scale
        x = x / max([data(:,1);data(:,2)]);
        y = y / max([data(:,1);data(:,2)]);
    end
end