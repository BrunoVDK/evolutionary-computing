function [stop] = check_stop_criterion(epsilon, best_list, no_generations, window_size, efficiency_function)
%CHECK_STOP_CRITERION Check if the stop criterion is met.
%   Check whether the stdev of the efficiency (for the gicen window_size)
%   is smaller than or equal to epsilon. If so, return true.
%   INPUT
%   epsilon = the threshold vor the stdev
%   best_list = array of best fitness values of all generations (future
%   generations can still be 0)
%   no_generations = the number of completed generations
%   window_size = the size of the time window to be used
%   efficiency_function = number of the efficiency function
%   OUTPUT
%   stop = boolean indicating of the threshold to stop was met
result = std_efficiency(best_list, no_generations, window_size, efficiency_function);
if result <= epsilon
    stop = true;
else
    stop = false;
end
end

