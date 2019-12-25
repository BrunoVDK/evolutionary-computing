function NewChrom = reciprocal_exchange(OldChrom, REPRESENTATION, ~)
    NewChrom=OldChrom;
    % Convert to path representation
    switch REPRESENTATION
        case 'adjacency'
            NewChrom = adj2path(NewChrom);
        case 'ordinal'
            NewChrom = ord2path(NewChrom);
    end
    % Swap two random cities in the tour
    rndi = zeros(1,2);
    while rndi(1) == rndi(2)
        rndi = rand_int(1,2,[1 size(NewChrom,2)]);
    end
    buffer = NewChrom(rndi(1));
    NewChrom(rndi(1)) = NewChrom(rndi(2));
    NewChrom(rndi(2)) = buffer;
    % Convert back
    switch REPRESENTATION
        case 'adjacency'
            NewChrom = path2adj(NewChrom);
        case 'ordinal'
            NewChrom = path2ord(NewChrom);
    end
end