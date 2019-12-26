function [interval] = thompson_savur(x)
    n = length(x);
    b = binoinv(.05, n, .5);
    l = b / (n-1);
    u = 1 - l;
    interval = [prctile(x,l*100), prctile(x,u*100)];
end