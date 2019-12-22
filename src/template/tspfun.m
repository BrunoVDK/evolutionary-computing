%
% ObjVal = tspfun(Phen, Dist)
% Implementation of the TSP fitness function
%	Phen contains the phenocode of the matrix coded in adjacency
%	representation
%	Dist is the matrix with precalculated distances between each pair of cities
%	ObjVal is a vector with the fitness values for each candidate tour (=each row of Phen)
%   Representation is an identifier for the solution representation
%
function ObjVal = tspfun(Phen, Dist, REPRESENTATION)
    switch REPRESENTATION
        case 'adjacency'
            ObjVal = Dist(Phen(:,1),1);
            for t = 2:size(Phen,2)
                ObjVal = ObjVal + Dist(Phen(:,t),t);
            end
        case 'path'
            [M,N] = size(Phen);
            ObjVal = zeros(M,1);
            for i = 1:M
                ObjVal(i) = Dist(Phen(i,1),Phen(i,N));
                for j = 1:N-1
                    ObjVal(i) = ObjVal(i) + Dist(Phen(i,j),Phen(i,j+1));
                end
            end
        case 'ordinal'
            % TODO
    end
	
end
