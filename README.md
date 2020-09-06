An application of evolutionary computing to the classic Travelling Salesmen Problem (TSP).

**Existing Genetic Algorithm**

To get an initial feel for what may or may not be worth it, 375 configurations (table 1) were experimented with for a total of 15,000 runs. This made it possible to draw some initial conclusions and perform some increasingly targeted experiments afterwards. All of the experiments outlined throughout this report were automated, with occasional use of parallelism (using MATLAB’s parallel computing toolbox).

<p align="center">
<img src="https://github.com/BrunoVDK/evolutionary-computing/blob/master/report/res/readme1.png?raw=true">
</p>

After selecting 4 datasets (with an increasing amount of cities) each of the resulting algorithms were ran 10 times. The resulting (best, average and worst) tour lengths and runtimes were recorded and averaged. The best tour found by each was also recorded, since the very point of the travelling salesman problem is to find the smallest possible tour. Diversity of solutions is only of indirect benefit as it increases the probability of reaching a global optimum. The minimum tour length found by every configuration is visualised in tables 10 to 14. It is calibrated against the minimum and maximum found by any of the 375 configurations (darker cells in the table indicate better solutions).

Aside from the obvious conclusion that the first benchmark is a tad too easy to resolve, two observations could be made ; larger population sizes improved results and lead to longer runtimes, and setting the rate of elitism too low is contra-productive. The first is not surprising since a larger population may increase diversity and the probability of finding a better local (or even global) minimum. At its worst it introduces redundancy and needlessly increases runtime. As for the second conclusion, retaining a reasonable proportion of the best individuals looks like a safe bet. Higher levels of elitism (> 10%) proved to be somewhat less fruitful. While better individuals may appear attractive to the greedy, some of them probably represent second-hand solutions (those that haven’t been mutated to one of the better individuals yet, or better individuals that have been unsuccessfully mutated) that may safely be disregarded.

The effect of population size was suspected - at least partially - to be due to increased speed of convergence. This was tested by running all configurations with population size of 150 for a larger number of generations which confirmed the suspicion (table 13). Therefor, future experiments use a reasonably large population size (300), fair rate of elitism (5-20%) and an appropriate stopping criterion (or the number of generations is set reasonably high).

One slightly more surprising result is that higher mutation - and crossover rates appeared to worsen results. High rates of mutation are too disruptive and the default crossover operator (alternating edges) preserves few edges from the parent. In subsequent experiments, only rates of 5% and 95% were abandoned.

It can be noted that just 10 runs and 250 generations is hardly enough (from a statistical point of view). However, only soft conclusions were drawn and limited computing power and time was available. Subsequent experiments were usually run 30 times per configuration and tend to make use of a stopping criterion (in combination with a high maximum number of generations) to avoid prematurely stopping a run. While it would be preferable no non-parametric tests were applied. Additionally, while the number of values that were tried per parameter isn’t very high, testing out more values would make for a combinatorial explosion. So only a small part of the utility landscape was explored. For a better analysis iterative methods could be used rather than this basic GENERATE-and-TEST approach.

**Stopping Criterion**

The following efficiency function E is used to calculate the algorithm’s efficiency after each generation :

<p align="center">
<img src="https://github.com/BrunoVDK/evolutionary-computing/blob/master/report/res/readme2.png?raw=true">
</p>

where T is the index of the current generation and Fi the best fitness value of generation i. This efficiency function basically calculates the average best fitness over all generations. Since the total distance is used as the fitness of an individual and the goal is to minimize this distance, E(t) is a monotonically decreasing function
(assuming elitism is used).

The stopping criterion keeps track of the efficiency of the algorithm. When the relative standard deviation of the last W efficiency values (window) drops below a certain percentage ∆, the algorithm stops. ∆ was chosen to be 0.5%. This stop criterion seems suitable, since the goal is to avoid useless generations where little to no improvement of the solution happens.

The window size W, being the only parameter not yet fixed, influences the quality of the solution and the convergence speed (in generations) of the algorithm. A small W will make the algorithm terminate sooner, possibly missing out on better solutions and decreasing the solution quality. A large W will make the algorithm terminate later, possibly increasing the solution quality but also allowing more useless generations.

An optimal value for W was determined. The algorithm was run 20 times on each small benchmark (rondrit<...>, belgiumtour, xqf131) with 500 generations (induvuduals = 50, elitism = 0.05, P_cross = 0.7, P_mut = 0.55, crossover = xalt edges, representation = adjacency, mutation = simple inversion, parent selection = linear rank, survivor selection = fitness based).

For each run, the evolution of the efficiency was observed to see what the longest streak without change greater than ∆ was (excluding the last streak until termination of the run). The average streak was 30 with a standard deviation of 35.

Two window sizes were considered, namely 30 (the average) and 66 (the sum of the average and standard deviation plus one). The same setup as above was run, but with the stop criterion activated. Each time the stop criterion was met, the generation and fitness value were saved, but the run completed the full 500 generations, so the difference in quality could be observed. The results are shown in the table 2 and table 3 below.

As expected, the smaller window size (W = 30) results in faster termination and worse quality, the bigger window size in better solution quality and slower termination.

<p align="center">
<img src="https://github.com/BrunoVDK/evolutionary-computing/blob/master/report/res/readme3.png?raw=true">
</p>

<p align="center">
<img src="https://github.com/BrunoVDK/evolutionary-computing/blob/master/report/res/readme4.png?raw=true">
</p>

Another interesting observation is the quality decrease in function of the route size (number of cities). These larger routes are more complex and thus the algorithm converges slower. A small window size (W = 30) will let the algorithm terminate while the solution is still improving slowly but steadily. A larger window size (W = 66) will observe the slow progress and let the algorithm run longer. Taking the window size too large, might result in many generations with too little improvement, though.

These results show that the window size and this type of stop criterion in general, are problem specific. As a result, this criterion is only suitable for applications where only one problem or problems of similar complexity are to be solved.

**Other Representation and Appropriate Operators**

Aside from the adjacency representation, (at least) four alternative representations can be used. Two of those are binary which were avoided due to previous experiences in constraint programming where the use of binary representations for problems with integer domains is discouraged. They are the binary and matrix representations. The other two alternatives were both implemented. The ordinal representation because it allows for the use of the ‘classic’ single-point crossover. The path representation because it is probably the most ‘natural’ representation. For the latter a few crossover operators were implemented (inspired by [2] & [1]). Some of these were mentioned either in Eiben’s book or in the course notes ; the heuristic - , partially matched -, order -, cycle -, edge recombination - and sequential constructive crossovers in particular. Operators that weren’t mentioned include :

- Heuristic Edge Recombination (HERX) : equivalent to the edge recombination crossover, but with some hybridisation in that the shortest edge is picked from the edge list of the current city, rather than the edge corresponding to the city with the shortest edge list.
- Max Preservative (MPX) : similar to the partially matched crossover. A subtour of the first parent is selected and remaining cities are appended to this sequence in the order that they appear in the other parent. The subtour’s length needs to be within a specified interval.
- Order Based (OX2) : a few random cities are selected in a parent. These cities are removed from the other parent and replaced by the same cities, at the same locations, but in the order that they appear in the first parent.
- Position Based (POS) : this one also selects a few random cities but imposes their positions as well, such that the offspring is the same as the first parent with respect to the cities that were selected, after which the remaining cities are added to it in the order that they appear in the other parent.
- Unnamed Heuristic (UHX) : a city is selected randomly. Four edges connected to city are compared, the smallest is picked (if there are edges of equal length, one is picked at random). The city at the other side of this edge becomes the current city and the whole routine is repeated until all cities have been added to the offspring.

The following mutation operators were implemented :
- Insertion : a city is selected, removed and inserted at some other (random) point in the tour.
- Displacement : a subtour is selected, removed and inserted at some other point in the tour.
- Inversion : the ‘simple’ inversion was already implemented. It involves picking out two cities and inverting the subtour between them (which is what 2-opt does). Inversion adds to this by subsequently placing it somewhere else (like the displacement operator does).
- Scramble : selects a random subtour and shuffles the cities around. Clearly quite a disruptive operator.
- Unnamed : a hybridised operator, just like its accompanying crossover. A random city is selected and the subtour from this city to the one closest to it is reversed.

These operators were selected such that a general idea could be formed about them. Some are clearly less ‘respectful‘ than others, yet it wasn’t entirely clear what to expect aside from what was reported in a fairly limited amount of studies which used other benchmarks. After some manual experiments (within the GUI that was extended for this purpose) further experimentation was done with all crossovers. From the configurations that were trialed before, 9 were selected and each of the crossover operators were tested in conjunction with those parameter values (table 4). The results are displayed in figures 4 to 7 (heatmaps might have been a preferable visualisation and can be generated from the crossoverlatex script, but they were a tad less interpretable). The average best tour length was visualised as well but not included in the report, as there was no indication that the shortest tours were a matter of luck.

As for the runtimes ; the edge recombination crossovers (both the classical and heuristic one) involve construction of an edge map which makes them the slowest in our list. The sequential crossover is a tad slower too, as is the classic single-point crossover (probably because the associated ordinal representation requires conversion to a path representation upon mutation). It’s the latter, SCX, HERX and UHX operators who converge more rapidly. The last three are hybrid which makes this unsurprising.

<p align="center">
<img src="https://github.com/BrunoVDK/evolutionary-computing/blob/master/report/res/readme5.png?raw=true">
</p>

After selection of the 4 more promising crossovers they were tested in combination with all of the 6 remaining mutation operators (all but simple inversion). The results are visualised in figures 8 and 9. To some extent an assumption is made that the performance of mutation operators can be gauged separately from the crossover operator in the sense that it wasn’t tested if the other 9 crossover operators perform better than others when combined with a particular mutation operator. Again, given the multitude of possible combinations some simplification is in order. Ideally a meta-algorithm would be used to automate the parameter tuning.

<p align="center">
<img src="https://github.com/BrunoVDK/evolutionary-computing/blob/master/report/res/readme6.png?raw=true">
</p>

The insertion, simple inversion and reciprocal exchange mutations appeared to be a safe bet in this limited number of experiments. They’re not particularly disruptive in comparison with, say, the scramble and displacement mutation operators. Performance of algorithms didn’t differ much between runs ; the results for mean shortest tour length (rather than minimum shortest tour across runs) is about equivalent. Of the four mutation rates that were tested the middle 2 (40% and 50%) appeared to be appropriate for future use. The scramble mutation turned out to be the most unpredictable. Mutations can get one out of a local optimum or just improve the value of the best solution found so far, but getting towards the optimum is clearly still not guaranteed.

**Local Optimisation**

In addition to the loop detection heuristic which was already part of the toolbox, two of the more simple heuristics were applied to the benchmarks. Two-opt and Or-opt in particular. While not as powerful as the Lin-Kernighan heuristic (which even has some efficient implementations), they’re easy to implement and provide good results. Their time complexity is O(N2) (per tour). The experiments turned out to be fairly uninteresting in that apparently optimal results were found for each of the smaller tours. One of the better crossovers was tested in combination with these heuristics on XQF131. A near-optimal tour was found with just one erroneous sequence in the bottom left corner. The value of the heuristics is visualised more clearly in the experiments at the end of this report.

Or-opt is a restricted version of 3-opt in which subtours of length 1, 2 or 3 are displaced. If the resulting tour is shorter it is picked for further processing. While 2-opt makes the simple inversion mutation redundant, Or-opt obviously overlaps with some mutation operators as well. Results obtained with this heuristic were typically inferior to those obtained with 2-opt.

**Benchmark Problems**

Tests on benchmarks were run without any local heuristic (results where they are activated are visualised at the end of this report). Parameters used are listed in table 6. The results are displayed below.

<p align="center">
<img src="https://github.com/BrunoVDK/evolutionary-computing/blob/master/report/res/readme7.png?raw=true">
</p>

<p align="center">
<img src="https://github.com/BrunoVDK/evolutionary-computing/blob/master/report/res/readme8.png?raw=true">
</p>

<p align="center">
<img src="https://github.com/BrunoVDK/evolutionary-computing/blob/master/report/res/readme9.png?raw=true">
</p>

**Other Tasks**

Until now, most of the analysis was done with the purpose of finding a good solution for every benchmark. Other facets that were neglected to some extent are selective pressure and diversity. Those can be crucial to prevent premature convergence and increase the probability of finding the better - or even the optimal - solution(s). Therefor, some attention was given to strategies like tournament selection.

*Parent Selection*

The most interesting parent selection strategy that was implemented is probably tournament selection. Both tournament selection with - and without replacement were implemented. Results of some basic experiments are displayed in tabel 8.

While the rank-based method may appear preferable, in all runs where it was used the algorithm stopped early on because the stopping criterion was met (no improvement was seen for 100 generations in a row). Whereas when tournament selection with replacement (k = 2) was used this was not the case.

<p align="center">
<img src="https://github.com/BrunoVDK/evolutionary-computing/blob/master/report/res/readme10.png?raw=true">
</p>

To elaborate on this : what’s not shown is the number of generations it took for the stopping criterion to be met. In the case of the (linear) rank-based selection it was met in all runs, often fairly early on (within 400 generations). In the case of fitness-proportionate selection it was frequently met (especially in the shorter tour of 25 cities). And in the case of tournament selection it depended on the value of k and whether or not replacement was used. For k = 10 it was met within 300 generations in most cases, for k = 20 within 200 generations. Clearly, the value of k influences selective pressure and setting it too high may lead to premature convergence. When tournament selection without replacement was used, the number of generations before the stopping criterion was met increased sharply (sometimes it wasn’t even met within 1000 generations). This is not surprising since lesser individuals get a higher chance of surviving (as noted in Eiben’s book).

Non-linear ranking turned out to be fairly useful as well, but tournament selection looked most likeable as a strategy as it can be run in parallel and its arguments allow one to control selective pressure quite easily (higher k values clearly increased the average versus best fitness value which is an - admittedly somewhat poor - metric for diversity).

*Survivor Selection*

Out of the three survivor selection strategies that were implemented - μ + λ, round robin and uniform selection -
the first two led to premature convergence and the latter was highly unpredictable. Any of the parent selection
methods can be used for survivor selection as well. μ + λ considers the merged offspring - and parent population
and has a large selective pressure. Round robin considers the merged populations as well, selecting parents
more and more often (because as the algorithm converges these tend to have higher fitness values). Eventually
there's a large amount of highly-fit local optima and exploration is decreased starkly. Using stochastic universal selection (based on the number of wins) instead of basing selection directly on the number of wins themselves is only of limited benefit.

*Diversity Preservation*

An island model was implemented in which the population is divided into islands if it is large enough. Every island hosts at least 25 individuals and the best ones are transferred from one to the other every so often (leading to periodic drops in average and worst fitness values throughout the generations). It obviously helped with diversity but not in the way tournament selection does ; if there was premature convergence in some algorithm, using the island model tends to transfer that problem to most of the islands themselves (as in, most islands experience a similar degree of convergence). After migration the degree of convergence drops (this is based on visual analysis of the graphs in the GUI).

One way to measure diversity is by counting the number of unique fitness values in the population (admittedly not a perfect measure since different genotypes may have the same fitness value). The median number of uniques across generations typically turned out to be higher when using the island model. Even the mean was nearly higher despite the fact that during migration the worst individuals in islands are replaced by the best individuals in other islands, which leads to a stark but short-lived drop in the number of unique fitness values, followed by an increase (until it reaches a value that’s typically higher than what it was before migration). For example, the average of the median of the number of unique fitness values across 250 generations (for 30 runs on the belgian tour) was calculated to be 75 and 63 (with and without island model).

*Adaptive Parameter Tuning*

It would seem that, as several good solutions have been found after quite a few generations, increased frequency of mutation and reduced frequency of local optimisation (if hybridisation is activated) would prove useful by allowing for a more liberal exploration of the search space. Therefor, an adaptive parameter strategy was implemented which does just that. Instead of seeing interesting new solutions emerge, the average fitness just kept on diverging. Probably because the search became equivalent to a rather random search. A more interesting approach would be to increase the mutation rate if diversity sinks too low.

*Further Hybridisation*

Seeding is a frequently used technique to give a head start. There’s several possible approximate solutions for the TSP that can be used for this purpose. One of them is a nearest neighbour solution where a random city is picked and a tour is formed by repeatedly selecting the city nearest to the current one until all of them have been selected. This works well until at the end the remaining edges have to be added, often at high cost. It provides a decent initial solution which is retained through elitism and may provide inspiration for subsequent tours (or lead the algorithm towards a local optimum). In most experiments the resulting initial tour turned out to have a length that’s within 15% of the optimal one, and the genetic algorithm caused further improvements until (in a typical run) the resulting tour ended up within about 6% of the optimum. No kd-tree was used as a seed is only constructed once for every run which (in comparison to a whole run) takes little time. Unsurprisingly, however, it barely helped with finding a truly good tour. Instead it improved the average best tour found across runs.

***

**Books**

- [Introduction to Evolutionary Computing (Eiben & Smith)](/books/Introduction%20to%20Evolutionary%20Computing%20(Eiben,%20Smith).pdf).
- [Genetic algorithms, constraints, and the knapsack problem (book chapter)](/books/constraints.pdf).

**Other Material**

- [Effective search for genetic-based machine learning systems](/papers/yang.pdf).
- [Evolving 3D Morphology and Behavior by Competition](/papers/sims.pdf).
- [Successful Lecture Timetabling with Evolutionary Algorithms](/papers/ross.pdf).
- [Using Genetic Algorithms For Supervised Concept Learning](/papers/spears.pdf).
- [GA Toolbox Manual](/papers/manual.pdf).

**Research**

 - [LibGen](http://gen.lib.rus.ec)
 - [LIMO](http://limo.libis.be)
 - [Google Scholar](http://scholar.google.com)
