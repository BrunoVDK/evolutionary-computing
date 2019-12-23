function Path = ord2path(Ord)
    Path = Ord;
    L = 1:size(Ord,2);
    for t = L
        Path(t) = L(Path(t));
        L(Ord(t)) = [];
    end
end

