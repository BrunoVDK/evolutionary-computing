function NewChrom = insertion(OldChrom, REPRESENTATION)
    % Convert to path representation
    switch REPRESENTATION
        case 'adjacency'
            OldChrom = adj2path(OldChrom);
        case 'ordinal'
            OldChrom = ord2path(OldChrom);
    end
    NewChrom = OldChrom;
    cols = size(OldChrom,2);
    city = randi(cols);
    insertion_point = randi(cols);
    while insertion_point == city; insertion_point = randi(cols); end
    if city < insertion_point
        NewChrom(city:insertion_point-1) = OldChrom(city+1:insertion_point);
    else
        NewChrom(insertion_point+1:city) = OldChrom(insertion_point:city-1);
    end
    NewChrom(insertion_point) = OldChrom(city);
    % Convert back
    switch REPRESENTATION
        case 'adjacency'
            NewChrom = path2adj(NewChrom);
        case 'ordinal'
            NewChrom = path2ord(NewChrom);
    end
end