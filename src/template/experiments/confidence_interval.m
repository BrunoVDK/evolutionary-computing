function [interval] = confidence_interval(x)
    standard_error = std(x) / sqrt(length(x));
    ts = tinv([0.025  0.975], length(x) - 1); % Inverse student t
    interval = mean(x) + ts * standard_error %#ok
end