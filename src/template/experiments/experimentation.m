%% PMX
xpartial_map([(1:8);[3 7 5 1 6 8 2 4]],1)
%% CX (example from book)
xcycle([1:9 ; [9 3 7 8 2 6 5 1 4]], 1)
xcycle([1:8 ; [2 4 6 8 7 5 3 1]], 1)
%% Order (O1)
xorder([1:8 ; [2 4 6 8 7 5 3 1]], 1)
%% Order-Based (O2)
xorder_based([[8 7 6 5 4 3 2 1] ; [2 4 6 8 7 5 3 1]], 1)
%% Position
xposition_based([1:8 ; [2 4 6 8 7 5 3 1]], 1)
%% Heuristic

%% Single-Point (built-in)
xovsp([1:8 ; [2 4 6 8 7 5 3 1]], 1)
% good for ordinal representation
%% Edge Recombination (ERX)
xedge_recombination([[1 2 3 4 5 6] ; [2 4 3 1 5 6]], 1)
%% Maximal Preservative (MPX)
xmax_preservative([(1:8);[2 4 6 8 7 5 3 1]],1)
%% Sequential Constructive (SCX)
ctx = context;
ctx.dist = ones(8);
xseq_constructive([(1:8);[2 4 6 8 7 5 3 1]],1,ctx)
%% Unnamed Heuristic Crossover (UHX)
ctx = context;
ctx.dist = ones(8);
xunnamed([[4 5 7 3 1 2 6 8] ; [3 1 7 5 6 4 2 8]],1,ctx)
%% Displacement Mutator
displacement(1:10,'path')
%% Insertion Mutator
insertion([2 4 6 8 7 5 3 1],'path')
%% Simple Inversion Mutator
inversion([2 4 6 8 7 5 3 1],'path')
%% Scramble Mutator
scramble([2 4 6 8 7 5 3 1],'path')
%% Unnamed Mutator
ctx = context;
ctx.dist = ones(8);
unnamed([4 5 7 3 1 2 6 8], path)
%% Round Robin
X = randi(10,10) %#ok
Y = randi(10,5,10) %#ok
[c,cost] = round_robin(X, Y, (1:10)', (15 + zeros(1,5))') %#ok
%% µ + ¬ Selection
X = randi(10,10) %#ok
Y = randi(10,5,10) %#ok
[c,cost] = mu_lambda(X, Y, (1:10)', (15 + zeros(1,5))') %#ok
%% T-test
% https://nl.mathworks.com/matlabcentral/answers/159417-how-to-calculate-the-confidence-interval
x = randi(50, 1, 1000000) - .5;             % Create Data
SEM = std(x)/sqrt(length(x));               % Standard Error
ts = tinv([0.025  0.975],length(x)-1);      % T-Score
CI = mean(x) + ts*SEM                       %#ok Confidence Intervals
confidence_intervals(x)