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