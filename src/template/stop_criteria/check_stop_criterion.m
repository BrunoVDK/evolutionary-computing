function [stop] = check_stop_criterion(delta, best_list, no_generations, window_size, efficiency_function)
%CHECK_STOP_CRITERION Check if the stop criterion is met.
%   Check whether the stdev fraction (stdev/mean) of the efficiency (for the gicen window_size)
%   is smaller than or equal to delta. If so, return true.
%   INPUT
%   delta = the threshold for the stdev fraction in percent
%   best_list = array of best fitness values of all generations (future
%   generations can still be 0)
%   no_generations = the number of completed generations
%   window_size = the size of the time window to be used
%   efficiency_function = number of the efficiency function
%   OUTPUT
%   stop = boolean indicating of the threshold to stop was met
result = stdfrac_efficiency(best_list, no_generations, window_size, efficiency_function);
%display(['Generation ', num2str(no_generations), ' stdev ', num2str(result)])
%if ((no_generations > 1) || (no_generations == size(best_list, 2))) && (result <= epsilon)
if (no_generations > window_size) && (result <= delta)
    stop = true;
else
    stop = false;
end
end

