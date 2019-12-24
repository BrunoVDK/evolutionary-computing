% Find two cut points for a given number of columns and return them in
% sorted order
% (stochastic)
function [left,right] = cut_points(cols)
%     left = randi(cols); right = randi(cols-1);
%     if left <= right
%         right = right + 1; 
%     else
%         [left,right] = deal(right,left);
%     end
    points = rand_int(1, 2, [1 cols]);
    while points(1) == points(2)
        points = rand_int(1, 2, [1 cols]);
    end
    left = min(points);
    right = max(points);
    % randi is much slower
end