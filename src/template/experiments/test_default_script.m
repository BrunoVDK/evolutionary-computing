disp('$$$$$$$$$$$$$$$$$$$$$$$$$$$ Starting test for task 2 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
NIND = 50;
MAXGEN = 100;
PR_CROSS = .70;
PR_MUT = .20;
REPETITIONS = 10;
STOP_CRITERION = 1;
disp('Default parameters are as follows: \n');
fprintf('NIND: %d, MAXGEN: %d, PR_CROSS: %f, PR_MUT: %f, STOP_CRITERION: %d \n',NIND,MAXGEN, ...
    PR_CROSS,PR_MUT,STOP_CRITERION);
fprintf('Every search will be repeated %d times \n',REPETITIONS);

fprintf('\n$$$$$ Test 1: changing NIND $$$$$\n');
NIND_test = [25,50,75];
fprintf('\t NIND = 25\n');
test_default(NIND_test(1),MAXGEN,PR_CROSS,PR_MUT,REPETITIONS,STOP_CRITERION);

fprintf('\t NIND = 50\n');
test_default(NIND_test(2),MAXGEN,PR_CROSS,PR_MUT,REPETITIONS,STOP_CRITERION);

fprintf('\t NIND = 75\n');
test_default(NIND_test(3),MAXGEN,PR_CROSS,PR_MUT,REPETITIONS,STOP_CRITERION);

fprintf('\n$$$$$ Test 2: changing PR_CROSS $$$$$\n');
PR_CROSS_test = [0.30,0.70,0.90];
fprintf('\t PR_MUT = 0.30\n');
test_default(NIND,MAXGEN,PR_CROSS_test(1),PR_MUT,REPETITIONS,STOP_CRITERION);

fprintf('\t PR_MUT = 0.70\n');
test_default(NIND,MAXGEN,PR_CROSS_test(2),PR_MUT,REPETITIONS,STOP_CRITERION);

fprintf('\t PR_MUT = 0.90\n');
test_default(NIND,MAXGEN,PR_CROSS_test(3),PR_MUT,REPETITIONS,STOP_CRITERION);

fprintf('\n$$$$$ Test 3: changing MUT $$$$$\n');
PR_MUT_test = [0.05,0.20,0.35];
fprintf('\t PR_CROSS = 0.05\n');
test_default(NIND,MAXGEN,PR_CROSS,PR_MUT_test(1),REPETITIONS,STOP_CRITERION);

fprintf('\t PR_CROSS = 0.20\n');
test_default(NIND,MAXGEN,PR_CROSS,PR_MUT_test(2),REPETITIONS,STOP_CRITERION);

fprintf('\t PR_CROSS = 0.35\n');
test_default(NIND,MAXGEN,PR_CROSS,PR_MUT_test(3),REPETITIONS,STOP_CRITERION);