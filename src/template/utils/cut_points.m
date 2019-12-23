% Find two cut points for a given number of columns and return them in
% sorted order
% (stochastic)
function [left,right] = cut_points(cols)
    left = randi(cols); right = randi(cols-1);
    if left <= right
        right = right + 1; 
    else
        [left,right] = deal(right,left);
    end
end