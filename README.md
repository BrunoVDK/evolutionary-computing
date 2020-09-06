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
