function [stdevfrac] = stdfrac_efficiency(best_list, no_generations, window_size, efficiency_function)
%stdfrac_efficiency Get the standard deviation fraction (stdev/mean) of the efficiency
%   Get the std fraction (stdev / mean) of the efficiencies in a defined time
%   window in a list of best efficiencies of the generations. The window will
%   always end with its last element being the last completed generation and
%   the other elements being the precedent generations.
%   If a best list looks like {X X X X X 0 0 0}, no_generations is 5 and
%   window_size 3, the window within the list is shown in square brackets:
%   {X X [X X X] 0 0 0}. The std of the population in this window will
%   be calculated.
%   INPUT
%   best_list = array of best fitness values of all generations (future
%   generations can still be 0)
%   no_generations = the number of completed generations
%   window_size = the size of the time window to be used
%   efficiency_function = number of the efficiency function
%   OUTPUT
%   stdevfrac = the standard deviation fraction (stdev / mean) of the efficiencies in the time window in
%   the best list
efficiency_array = map_fitness_to_efficiency(best_list, no_generations, efficiency_function);
if no_generations == 0
    result = 0;
elseif no_generations < window_size
    result = std(efficiency_array(1:no_generations))/mean(efficiency_array(1:no_generations));
else
    result = std(efficiency_array((no_generations - window_size + 1) : no_generations))/mean(efficiency_array((no_generations - window_size + 1) : no_generations));
end
stdevfrac = result;
end

function [efficiency_array] = map_fitness_to_efficiency(best_list, no_generations, efficiency_function)
%map_fitness_to_efficiency Map an array of fitness values to efficiencies
%   Maps an array of fitness values to an array of efficiencies, with the
%   efficiency at index J being the  efficiencye takes over the J first
%   elements of the fitness array.
%   INPUT
%   best_list = array of best fitness values of all generations (future
%   generations can still be 0)
%   no_generations = the number of completed generations
%   efficiency_function = number of the efficiency function
%   OUTPUT
%   efficiency_array = array with all efficiencies
if no_generations <= 0
    efficiency_array = [];
end
i = 1;
result = zeros(1, no_generations);
while i <= no_generations
    if efficiency_function == 1
        result(i) = efficiency1(best_list, i);
    elseif efficiency_function == 2
        result(i) = efficiency2(best_list, i);
    else 
        result(i) = efficiency3(best_list, i);
    end
    i = i + 1;
end
efficiency_array = result;
end

