disp('$$$$$$$$$$$$$$$$$$$$$$$$$$$ Starting test for task 2 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
NIND = 50;
MAXGEN = 100;
ELITIST = 0.05;
PR_CROSS = .70;
PR_MUT = .20;
REPETITIONS = 20;
STOP_CRITERION = 1;
disp('Default parameters are as follows: \n');
fprintf('NIND: %d, MAXGEN: %d, ELITIST: %f PR_CROSS: %f, PR_MUT: %f, STOP_CRITERION: %d \n',NIND,MAXGEN, ...
    ELITIST,PR_CROSS,PR_MUT,STOP_CRITERION);
fprintf('Every search will be repeated %d times \n',REPETITIONS);

fprintf('\n$$$$$ Test 1: changing NIND $$$$$\n');
NIND_test = [25,50,75,100,125,150];
i_1 = 1;
while i_1 <= size(NIND_test,2)
    fprintf('\t NIND = %d\n',NIND_test(i_1));
    test_default(NIND_test(i_1),MAXGEN,ELITIST,PR_CROSS,PR_MUT,REPETITIONS,STOP_CRITERION);
    i_1 = i_1 + 1;
end

fprintf('\n$$$$$ Test 2: changing PR_CROSS $$$$$\n');
PR_CROSS_test = [0.10,0.20,0.30,0.40,0.50,0.60,0.70,0.80,0.90,1.00];
i_2 = 1;
while i_2 <= size(PR_CROSS_test,2)
    fprintf('\t PR_CROSS = %f\n',PR_CROSS_test(i_2));
    test_default(NIND,MAXGEN,ELITIST,PR_CROSS_test(i_2),PR_MUT,REPETITIONS,STOP_CRITERION);
    i_2 = i_2 + 1;
end

fprintf('\n$$$$$ Test 3: changing MUT $$$$$\n');
PR_MUT_test = [0.05,0.10,0.20,0.35,0.50,0.60,0.70,0.80,0.90,1.00];
i_3 = 1;
while i_3 <= size(PR_MUT_test,2)
    fprintf('\t PR_MUT = %f\n',PR_MUT_test(i_3));
    test_default(NIND,MAXGEN,ELITIST,PR_CROSS,PR_MUT_test,REPETITIONS,STOP_CRITERION);
    i_3 = i_3 + 1;
end

fprintf('\n$$$$$ Test 4: changing ELITISM $$$$$\n');
ELITIST_test = [0.05,0.10,0.20,0.35,0.50,0.60,0.70,0.80,0.90,0.95];
i_4 = 1;
while i_4 <= size(ELITIST_test,2)
    fprintf('\t ELITIST = %f\n',ELITIST_test(i_4));
    test_default(NIND,MAXGEN,ELITIST_test(i_4),PR_CROSS,PR_MUT,REPETITIONS,STOP_CRITERION);
    i_4 = i_4 + 1;
end