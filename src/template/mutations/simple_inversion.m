function NewChrom = inversion(OldChrom, REPRESENTATION)
    NewChrom = OldChrom;
    % Convert to path representation
    switch REPRESENTATION
        case 'adjacency'
            NewChrom = adj2path(NewChrom);
        case 'ordinal'
            NewChrom = ord2path(NewChrom);
    end
    % Select two positions in the tour
    rndi = zeros(1,2);
    while rndi(1) == rndi(2)
        rndi = rand_int(1,2,[1 size(NewChrom,2)]);
    end
    rndi = sort(rndi);
    NewChrom(rndi(1):rndi(2)) = NewChrom(rndi(2):-1:rndi(1));
    % Convert back
    switch REPRESENTATION
        case 'adjacency'
            NewChrom = path2adj(NewChrom);
        case 'ordinal'
            NewChrom = path2ord(NewChrom);
    end
end