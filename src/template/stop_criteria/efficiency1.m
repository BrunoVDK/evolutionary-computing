function [efficiency] = efficiency1(best_list, no_generations)
%EFFICIENCY1 First efficiency function
%   Based on the first efficiency function of exercise session 3. Takes the
%   best fitness value from a given array of best fitness from every
%   generation.
%   INPUT
%   best_list = array of best fitness values of all generations (future
%   generations can still be 0)
%   no_generations = the number of completed generations
%   OUTPUT
%   efficiency = the best efficiency value of all the completed generations
bests = best_list(1,1:no_generations);
efficiency = max(bests(1));
end

