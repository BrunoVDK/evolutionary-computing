% ObjVal = tspfun(Phen, Dist)
% Implementation of the TSP fitness function
%	Phen contains the phenocode of the matrix coded in adjacency
%	representation
%	Dist is the matrix with precalculated distances between each pair of cities
%	ObjVal is a vector with the fitness values for each candidate tour (=each row of Phen)
%   Representation is an identifier for the solution representation
function ObjVal = tspfun(Phen, Dist, REPRESENTATION)
    [M,N] = size(Phen);
    switch REPRESENTATION
        case 'adjacency'
            ObjVal = Dist(Phen(:,1),1);
            for t = 2:N
                ObjVal = ObjVal + Dist(Phen(:,t),t);
            end
        case 'path'
            ObjVal = zeros(M,1);
            for i = 1:M
                ObjVal(i) = Dist(Phen(i,1),Phen(i,N));
                for j = 1:N-1
                    ObjVal(i) = ObjVal(i) + Dist(Phen(i,j),Phen(i,j+1));
                end
            end
        case 'ordinal'
            for i = 1:M
                Phen(i,:) = ord2path(Phen(i,:));
                ObjVal = tspfun(Phen, Dist, 'path');
            end
    end
end
