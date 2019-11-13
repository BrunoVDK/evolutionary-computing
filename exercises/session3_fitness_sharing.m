%% Genetic Algorithms and Evolutionanry Computing: Exercise Session 3 
% ---------------------------------------------------------------------------------------
% Fitness Sharing 
% Based on Section 5.5.3 (p. 93) of the book "Introduction to Evolutionary
% Computing (2nd Edition)" by A.E. Eiben and J.E. Smith
% ---------------------------------------------------------------------------------------
%% Initialization%
clear all
close all 
clc 
%% Sigma? Population size?
sigma = 2; % for sqrt function goes from 0 to sqrt(xend)
n = 200;
%% OPTION 1 : Sqrt function for individuals 
% function's derivative decreases so highly fit individuals = higher
% density
xbeg = 0;
xend = 5^2;
h= (xend-xbeg)/n;
for i = 1:n
   x(i) = sqrt(xbeg + (i-1)*h);
end
%% OPTION 2 : Linearly changing x
x = 1:n; % should do nothing? no clusters whatsoever
%% OPTION 3 : Random distribution
x = rand(1,n);
%% Visualise

d = zeros(n,n);
sh = zeros(n,n);
for i=1 : n
 for j=1 : n
   d(i,j) = abs(x(i) - x(j));
   if d(i,j) < sigma
     sh(i,j) = 1 - d(i,j)/sigma;
   end
 end
end

sum = 0;
for i=1:n
  f(i) = abs( x(i) * sin(x(i)*pi));
  denominator(i) = 0;
  for j = 1:n
   denominator(i) = denominator(i) + sh(i,j);
  end
  fprime(i) = f(i) / denominator(i) ;
  sum = sum + fprime(i);
end 

for i = 1:n
prob(i) = fprime(i)/sum;
end


subplot(4,1,1); plot(x)
plot(x, '+'); title('x');
subplot(4,1,2); 
plot(x, f, 'o'); title('f');
subplot(4,1,3); 
plot(x, fprime, '+'); title('fprime');
subplot(4,1,4); 
plot(x, prob, '+'); title('probability');