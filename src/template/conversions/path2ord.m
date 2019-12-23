function Ord = path2ord(Path)
	Ord = Path;
    L = 1:size(Path,2);
    for t = L
        Ord(t) = find(L == Path(t),1);
        L(Ord(t)) = [];
    end
end

