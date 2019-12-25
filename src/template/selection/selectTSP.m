function [SelCh] = selectTSP(SELECTION, Chrom, ObjV, GGAP)
    SelCh = feval(SELECTION, Chrom, ObjV, GGAP);
end

