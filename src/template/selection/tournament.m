function [SelCh] = linear_rank(Chrom, ObjV, GGAP)
    FitnV = ranking(ObjV);
    % Chrom = chromosomes,
    % FitnV = corresponding fitness values
    % GGAP = rate of individuals being replaced, default 1.
    SelCh = select('sus', Chrom, FitnV, GGAP);
end