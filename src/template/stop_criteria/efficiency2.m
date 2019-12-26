function [efficiency] = efficiency2(best_list, no_generations)
%EFFICIENCY2 Second efficiency function
%   Based on the second efficiency function of exercise session 3. Takes the
%   average fitness value of a given array of best fitness from every
%   generation.
%   INPUT
%   best_list = array of best fitness values of all generations (future
%   generations can still be 0)
%   no_generations = the number of completed generations
%   OUTPUT
%   efficiency = the average efficiency value of all the completed generations
bests = best_list(1,1:no_generations);
efficiency = mean(bests(1));
end

