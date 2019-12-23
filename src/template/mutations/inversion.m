% low level function for TSP mutation
% reciprocal exchange : two random cities in a tour are swapped
function NewChrom = inversion(OldChrom, REPRESENTATION)
    NewChrom = OldChrom;
    switch REPRESENTATION
        case 'adjacency'
            NewChrom = adj2path(NewChrom);
        case 'ordinal'
            % TODO
    end
    % select two positions in the tour
    rndi=zeros(1,2);
    while rndi(1)==rndi(2)
        rndi=rand_int(1,2,[1 size(NewChrom,2)]);
    end
    rndi = sort(rndi);
    NewChrom(rndi(1):rndi(2)) = NewChrom(rndi(2):-1:rndi(1));
    %buffer=NewChrom(rndi(1));
    %NewChrom(rndi(1))=NewChrom(rndi(2));
    %NewChrom(rndi(2))=buffer;
    switch REPRESENTATION
        case 'adjacency'
            NewChrom = path2adj(NewChrom);
        case 'ordinal'
            % TODO
    end
end