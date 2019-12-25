function NewChrom = scramble(OldChrom, REPRESENTATION, ~)
    NewChrom = OldChrom;
    % Convert to path representation
    switch REPRESENTATION
        case 'adjacency'
            NewChrom = adj2path(NewChrom);
        case 'ordinal'
            NewChrom = ord2path(NewChrom);
    end
    [left,right] = cut_points(length(NewChrom));
    NewChrom(left:right) = NewChrom((left-1) + randperm(right-left+1));
    % Convert back
    switch REPRESENTATION
        case 'adjacency'
            NewChrom = path2adj(NewChrom);
        case 'ordinal'
            NewChrom = path2ord(NewChrom);
    end
end