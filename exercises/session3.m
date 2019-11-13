% Warning : shitty code below
%% 1
% Probability should be p((1-p)^(i-1))
% Probabilities don't add up to one, but get close
% 3 strategies to tackle it ; correction (+c), normalization or modifying
% equation
hold on
plottsfor(5, 0.8, 'b')
plottsfor(5, 0.5, 'r')
plottsfor(5, 0.1, 'g')
hold off
figure
hold on
plottsfor(15, 0.8, 'b')
plottsfor(15, 0.5, 'r')
plottsfor(15, 0.1, 'g')
hold off
clear
%% 2
run_1 = [1 3 5 7 6 2 5 9 9 9];
run_2 = [1 3 6 6 6 6 7 7 7 7];
E1 = 1:length(run_1); E2 = E1; E3 = E1;
X = E1;
for i = 1:length(run_1)
    E1(i) = max(run_1(1:i));
    E2(i) = sum(run_1(1:i)) / i;
    E3(i) = E1(i) / i;
end
subplot(2,3,1);
plot(X, E1);
subplot(2,3,2);
plot(X, E2);
subplot(2,3,3);
plot(X, E3);
for i = 1:length(run_2)
    E1(i) = max(run_2(1:i));
    E2(i) = sum(run_2(1:i)) / i;
    E3(i) = E1(i) / i;
end
subplot(2,3,4);
plot(X, E1);
subplot(2,3,5);
plot(X, E2);
subplot(2,3,6);
plot(X, E3);
clear
% Possible stop criteria :
% - total cost of algorithm exceeds predefined limit
% - efficiency : E_2 drops below predefined limit
% - diversity : in the phenotype space is lower than limit
% - diversity in the genotype space is below some limit
% - maximal improvement of the solution over last N generations is lower
% than given value
% - average rate of improvement over last N generations dropbs below given
% rate
% - quality of the solution surpasses a predefined threshold
% - ...
%% 3
% Fitness sharing is a type of Niching, where the fitness of each 
%  individual is scaled based on its proximity to others. 
%  This means that good solutions in densely populated regions are given 
%  a lower fitness value than comparably good solutions in sparsely 
%  populated regions. In effect, the algorithm's selection technique 
%  places less emphasis on these high-quality, high-density solutions. 

%% Helper functions
function [] = plottsfor(k, prob, style)
    p = 1:k;
    for i = 1:k
        p(i) = prob * ((1 - prob)^i);
    end
    plot(1:k, p, style)
end