function NewChrom = inversion(OldChrom, REPRESENTATION, ~)
    % Convert to path representation
    switch REPRESENTATION
        case 'adjacency'
            OldChrom = adj2path(OldChrom);
        case 'ordinal'
            OldChrom = ord2path(OldChrom);
    end
    % Displace subtour
    cols = size(OldChrom,2);
    [left,right] = cut_points(cols);
    rest = [OldChrom(1:left-1) OldChrom(right+1:end)];
    insertion_point = randi(length(rest) + 1);
    NewChrom = [rest(1:insertion_point-1) OldChrom(right:-1:left) rest(insertion_point:end)];
    % Convert back
    switch REPRESENTATION
        case 'adjacency'
            NewChrom = path2adj(NewChrom);
        case 'ordinal'
            NewChrom = path2ord(NewChrom);
    end
end