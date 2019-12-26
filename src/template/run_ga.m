function [best,average,worst] = run_ga(...
    x, ...
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
    ah1, ah2, ah3, ...
    REPRESENTATION, ...
    MUTATION, ...
    SEEDING, ...
    TWOOPT, ...
    PARENT_SELECTION, ...
    SURVIVOR_SELECTION, ...
    VISUAL)
% usage: run_ga(x, y,
%               NIND, MAXGEN, NVAR,
%               ELITIST, STOP_PERCENTAGE,
%               PR_CROSS, PR_MUT, CROSSOVER,
%               ah1, ah2, ah3)
%
%
% x, y: coordinates of the cities
% NIND: number of individuals
% MAXGEN: maximal number of generations
% ELITIST: percentage of elite population
% STOP_PERCENTAGE: percentage of equal fitness (stop criterium)
% PR_CROSS: probability for crossover
% PR_MUT: probability for mutation
% CROSSOVER: the crossover operator
% calculate distance matrix between each pair of cities
% ah1, ah2, ah3: axes handles to visualise tsp
% {NIND MAXGEN NVAR ELITIST STOP_PERCENTAGE PR_CROSS PR_MUT CROSSOVER LOCALLOOP REPRESENTATION}

    fprintf("Starting run with representation '%s', crossover '%s' and mutation '%s' (%i generations).\n", REPRESENTATION, CROSSOVER, MUTATION, MAXGEN);

    GGAP = 1 - ELITIST; % generation gap (see book, proportion of pop replaced)

    mean_fits = zeros(1,MAXGEN+1); % mean fitness
    worst = zeros(1,MAXGEN+1); % worst fitness
    Dist = zeros(NVAR,NVAR); % distances
    for i = 1:size(x,1)
        for j=1:size(y,1)
            Dist(i,j) = sqrt((x(i)-x(j))^2+(y(i)-y(j))^2); % symmetrical ... (efficiency not important)
        end
    end

    % Initialize population
    gen = 0; % First generation
    Chrom = zeros(NIND,NVAR);
    if SEEDING
        seed = nearest_neighbor(Dist);
    end
    for row = 1:NIND
        if row < floor(NIND/20) && SEEDING
            individual = seed; % (local heuristic)
        else
            individual = randperm(NVAR);
        end
        switch REPRESENTATION
            case 'adjacency'
                Chrom(row,:) = path2adj(individual);
            case 'path'
                Chrom(row,:) = individual;
            case 'ordinal'
                Chrom(row,:) = path2ord(individual);
        end
    end
    if TWOOPT
        Chrom = twoopt(Chrom, size(Chrom,1), size(Dist,1), Dist, REPRESENTATION);
    end
    
    % Create context
    ctx = context;
    ctx.dist = Dist;

    % Number of individuals of equal fitness needed to stop (basic stop
    % criterion)
    stopN = ceil(STOP_PERCENTAGE*NIND);

    % Evaluate initial population (tspfun = calculates fitness based on
    % representation)
    ObjV = tspfun(Chrom, Dist, REPRESENTATION);
    best = zeros(1,MAXGEN);

    % Generational loop
    while gen < MAXGEN

        sObjV = sort(ObjV); % Sorted fitness values
        best(gen+1) = min(ObjV); % Highest fitness (smallest dist)
        minimum = best(gen+1); % Shorthand
        mean_fits(gen+1) = mean(ObjV); % Mean fitness
        worst(gen+1) = max(ObjV); % Worst fitness (maximum dist)
        for t=1:size(ObjV,1) % Set t to the index of the minimum (could be done with min ...)
            if (ObjV(t) == minimum)
                break;
            end
        end

        % Visualise mean, best, ...
        if VISUAL
            switch REPRESENTATION
                case 'adjacency'
                    visualizeTSP(x, y, adj2path(Chrom(t,:)), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);
                case 'path'
                    visualizeTSP(x, y, Chrom(t,:), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);
                case 'ordinal'
                    visualizeTSP(x, y, ord2path(Chrom(t,:)), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);
            end
        end

        % Basic stop criterion
        if (sObjV(stopN) - sObjV(1) <= 1e-15) % implies that stopN percent of pop has same fitness
            break;
        end

        % Parent selection according to chosen method
        % Chrom = chromosomes,
        % FitnV = corresponding fitness values
        % GGAP = rate of individuals being replaced, default 1.
        SelCh = selectTSP(PARENT_SELECTION, Chrom, ObjV, GGAP);

        % Recombine individuals (crossover + mutation)
        % PR_* denotes probability/rate (of crossover or mutation)
        SelCh = recombineTSP(CROSSOVER, SelCh, PR_CROSS, 1, ctx);
        SelCh = mutateTSP(MUTATION, SelCh, PR_MUT, REPRESENTATION, ctx);

        % Evaluate offspring, call objective function
        ObjVSel = tspfun(SelCh, Dist, REPRESENTATION);

        % Apply 2-opt
        if TWOOPT && (NVAR < 350 || rem(gen,20) == 0) 
            SelCh = twoopt(SelCh, size(SelCh,1), size(Dist,1), Dist, REPRESENTATION);
        end
        
        % Reinsert offspring into population, replacing parents
        [Chrom,ObjV] = reinsTSP(SURVIVOR_SELECTION, Chrom, SelCh, ObjV, ObjVSel);

        % Removes local loops
        Chrom = improve_population(NIND, NVAR, Chrom, LOCALLOOP, Dist, REPRESENTATION);

        % Increment generation counter
        gen = gen+1;

    end
    
    best = best(gen);
    worst = worst(gen);
    average = mean_fits(gen);
    fprintf("Results : best = %.2f, avg = %.2f, worst = %.2f\n", best, average, worst);
    
end