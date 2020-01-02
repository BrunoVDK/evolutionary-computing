function [result] = same100(best, no_generations)
%SAME100 Check if last 100 best are the same
%   Checks the last 100 generations to see if they have all got the same best
if no_generations < 100
    result = false;
else
    best_100 = best(no_generations - 100 + 1 : no_generations);
    comp = best_100(1);
    temp = true;
    for x = best_100
        if comp ~= x
            temp = false;
            break;
        end
    end
    result = temp;
end

