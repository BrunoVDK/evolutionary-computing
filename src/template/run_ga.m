function run_ga(...
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
    REPRESENTATION)
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
{NIND MAXGEN NVAR ELITIST STOP_PERCENTAGE PR_CROSS PR_MUT CROSSOVER LOCALLOOP REPRESENTATION}

        GGAP = 1 - ELITIST; % generation gap (see book, proportion of pop replaced)
        
        mean_fits = zeros(1,MAXGEN+1); % mean fitness
        worst = zeros(1,MAXGEN+1); % worst fitness
        Dist = zeros(NVAR,NVAR); % distances
        for i = 1:size(x,1)
            for j=1:size(y,1)
                Dist(i,j) = sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
            end
        end
        
        % Initialize population
        gen = 0; % First generation
        Chrom = zeros(NIND,NVAR);
        for row = 1:NIND
            switch REPRESENTATION
                case 'adjacency'
                    Chrom(row,:) = path2adj(randperm(NVAR)); %rand perm is what you think it is
                case 'path'
                    Chrom(row,:) = randperm(NVAR);
                case 'ordinal'
                    % TODO
            end
        end
        
        % Number of individuals of equal fitness needed to stop (basic stop
        % criterion)
        stopN = ceil(STOP_PERCENTAGE*NIND);
        
        % Evaluate initial population (tspfun = calculates fitness based on
        % representation)
        switch REPRESENTATION
            case 'adjacency'
                ObjV = tspfun(Chrom, Dist);
            case 'path'
                % TODO
            case 'ordinal'
                % TODO
        end
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
            switch REPRESENTATION
                case 'adjacency'
                    visualizeTSP(x, y, adj2path(Chrom(t,:)), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);
                case 'path'
                    visualizeTSP(x, y, Chrom(t,:), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);
                case 'ordinal'
                    % TODO
            end

            % Basic stop criterion
            if (sObjV(stopN)-sObjV(1) <= 1e-15) % implies that stopN percent of pop has same fitness
                  break;
            end    
            
        	% Assign fitness values to entire population
            % Linear ranking with selective pressure 2
        	FitnV = ranking(ObjV);
            
        	% Select individuals for breeding (Stochastic Universal Sampling)
            % Chrom = chromosomes,
            % FitnV = corresponding fitness values
            % GGAP = rate of individuals being replaced, default 1.à
        	SelCh = select('sus', Chrom, FitnV, GGAP);
            
        	% Recombine individuals (crossover + mutation)
            % PR_* denotes probability (of crossover or mutation)
            switch REPRESENTATION
                case 'adjacency'
                    SelCh = recombin(CROSSOVER, SelCh, PR_CROSS);
                    SelCh = mutateTSP('inversion', SelCh, PR_MUT);
                case 'path'
                    % TODO
                case 'ordinal'
                    % TODO
            end
            
            % Evaluate offspring, call objective function
            switch REPRESENTATION
                case 'adjacency'
                    ObjVSel = tspfun(SelCh, Dist);
                case 'path'
                    % TODO
                case 'ordinal'
                    % TODO
            end
            
            % Reinsert offspring into population, replacing parents
        	[Chrom,ObjV] = reins(Chrom, SelCh, 1, 1, ObjV, ObjVSel);
            
            % Removes local loops (local heuristic)
            switch REPRESENTATION
                case 'adjacency'
                    Chrom = tsp_ImprovePopulation(NIND, NVAR, Chrom, LOCALLOOP, Dist);
                case 'path'
                    % TODO
                case 'ordinal'
                    % TODO
            end
        	
            % Increment generation counter
        	gen = gen+1; 
            
        end
        
end