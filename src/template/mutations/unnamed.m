function NewChrom = unnamed(OldChrom, REPRESENTATION, ctx)
    NewChrom = OldChrom;
    % Convert to path representation
    switch REPRESENTATION
        case 'adjacency'
            NewChrom = adj2path(NewChrom);
        case 'ordinal'
            NewChrom = ord2path(NewChrom);
    end
    city = randi(length(NewChrom));
    ctx.dist(city,city) = realmax;
    [~,closest_city] = min(ctx.dist(city,:));
    left = min(city,closest_city);
    right = max(city,closest_city);
    NewChrom(left:right) = OldChrom(right:-1:left);
    % Convert back
    switch REPRESENTATION
        case 'adjacency'
            NewChrom = path2adj(NewChrom);
        case 'ordinal'
            NewChrom = path2ord(NewChrom);
    end
end