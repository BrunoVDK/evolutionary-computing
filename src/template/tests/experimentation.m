%% PMX
xpartial_map([(1:8);[3 7 5 1 6 8 2 4]],1)
%% CX (example from book)
xcycle([1:9 ; [9 3 7 8 2 6 5 1 4]], 1)
xcycle([1:8 ; [2 4 6 8 7 5 3 1]], 1)
%% O1
xorder([1:8 ; [2 4 6 8 7 5 3 1]], 1)
%% O2
xorder_based([8:-1:1 ; [2 4 6 8 7 5 3 1]], 1)
%% Position
xposition_based([1:8 ; [2 4 6 8 7 5 3 1]], 1)
%% Heuristic

%% Single-Point (built-in)
xovsp([1:8 ; [2 4 6 8 7 5 3 1]], 1)
% good for ordinal representation