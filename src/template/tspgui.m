function tspgui(run_it)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT CONFIGURATION
NIND=50;		% Number of individuals
MAXGEN=100;		% Maximum no. of generations
NVAR=26;		% No. of variables
PRECI=1;		% Precision of variables
ELITIST=0.05;    % percentage of the elite population
GGAP=1-ELITIST;		% Generation gap
STOP_PERCENTAGE=.95;    % percentage of equal fitness individuals for stopping
PR_CROSS=.95;     % probability of crossover
PR_MUT=.05;       % probability of mutation
LOCALLOOP=0;      % local loop removal
CROSSOVER = 'xseq_constructive';  % default crossover operator
REPRESENTATION = 'path'; % default representation
MUTATION = 'scramble'; % default mutation
SCALING = false; % scale path yes or no
HEURISTIC = 'hybridisation off'; % Local heuristic mode
PARENT_SELECTION = 'linear_rank';
SURVIVOR_SELECTION = 'fitness_based';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% read an existing population
% 1 -- to use the input file specified by the filename
% 0 -- click the cities yourself, which will be saved in the file called
%USE_FILE=0;
%FILENAME='data/cities.xy';
%if (USE_FILE==0)
%    % get the input cities
%    fg1 = figure(1);clf;
%    %subplot(2,2,2);
%    axis([0 1 0 1]);
%    title(NVAR);
%    hold on;
%    x=zeros(NVAR,1);y=zeros(NVAR,1);
%    for v=1:NVAR
%        [xi,yi]=ginput(1);
%        x(v)=xi;
%        y(v)=yi;
%        plot(xi,yi, 'ko','MarkerFaceColor','Black');
%        title(NVAR-v);
%    end
%    hold off;
%    set(fg1, 'Visible', 'off');
%    dlmwrite(FILENAME,[x y],'\t');
%else
%    XY=dlmread(FILENAME,'\t');
%    x=XY(:,1);
%    y=XY(:,2);
%end

if nargin < 1; run_it = 1; end

% Load all the data sets
datasetslist = dir('datasets/');
datasets=cell( size(datasetslist,1)-2,1);
for i=1:size(datasets,1);
    datasets{i} = datasetslist(i+2).name;
end

% Load a particular dataset
data = load(['datasets/' datasets{size(datasets,1) - 1}]);
x = data(:,1); y = data(:,2);
load_set(data, SCALING);
NVAR=size(data,1);

% initialise the user interface
fh = figure('Visible','off','Name','TSP Tool','Position',[0,0,1024,768]);
ah1 = axes('Parent',fh,'Position',[.1 .55 .4 .4]);
plot(x,y,'ko')
ah2 = axes('Parent',fh,'Position',[.55 .55 .4 .4]);
axes(ah2);
xlabel('Generation');
ylabel('Distance (Min. - Gem. - Max.)');
ah3 = axes('Parent',fh,'Position',[.1 .1 .4 .4]);
axes(ah3);
%title('Histogram');
xlabel('Distance');
ylabel('Number');

ph = uipanel('Parent',fh,'Title','Settings','Position',[.55 .05 .45 .45]);
datasetpopuptxt = uicontrol(ph,'Style','text','String','Dataset','Position',[0 290 80 20]);
datasetpopup = uicontrol(ph,'Style','popupmenu','String',datasets,'Value',size(datasets,1)-1,'Position',[60 292 130 20],'Callback',@datasetpopup_Callback);
llooppopuptxt = uicontrol(ph,'Style','text','String','Loop Detection','Position',[190 290 80 20]);
llooppopup = uicontrol(ph,'Style','popupmenu','String',{'off','on'},'Value',1,'Position',[270 292 70 20],'Callback',@llooppopup_Callback); 
ncitiesslidertxt = uicontrol(ph,'Style','text','String','# Cities','Position',[0 260 130 20]);
%ncitiesslider = uicontrol(ph,'Style','slider','Max',128,'Min',4,'Value',NVAR,'Sliderstep',[0.012 0.05],'Position',[130 230 150 20],'Callback',@ncitiesslider_Callback);
ncitiessliderv = uicontrol(ph,'Style','text','String',NVAR,'Position',[110 260 50 20]);
nindslidertxt = uicontrol(ph,'Style','text','String','# Individuals','Position',[0 230 130 20]);
nindslider = uicontrol(ph,'Style','slider','Max',1000,'Min',10,'Value',NIND,'Sliderstep',[0.001 0.05],'Position',[130 230 150 20],'Callback',@nindslider_Callback);
nindsliderv = uicontrol(ph,'Style','text','String',NIND,'Position',[280 230 50 20]);
genslidertxt = uicontrol(ph,'Style','text','String','# Generations','Position',[0 200 130 20]);
genslider = uicontrol(ph,'Style','slider','Max',3000,'Min',10,'Value',MAXGEN,'Sliderstep',[0.001 0.05],'Position',[130 200 150 20],'Callback',@genslider_Callback);
gensliderv = uicontrol(ph,'Style','text','String',MAXGEN,'Position',[280 200 50 20]);
mutslidertxt = uicontrol(ph,'Style','text','String','Pr. Mutation','Position',[0 170 130 20]);
mutslider = uicontrol(ph,'Style','slider','Max',100,'Min',0,'Value',round(PR_MUT*100),'Sliderstep',[0.01 0.05],'Position',[130 170 150 20],'Callback',@mutslider_Callback);
mutsliderv = uicontrol(ph,'Style','text','String',round(PR_MUT*100),'Position',[280 170 50 20]);
crossslidertxt = uicontrol(ph,'Style','text','String','Pr. Crossover','Position',[0 140 130 20]);
crossslider = uicontrol(ph,'Style','slider','Max',100,'Min',0,'Value',round(PR_CROSS*100),'Sliderstep',[0.01 0.05],'Position',[130 140 150 20],'Callback',@crossslider_Callback);
crosssliderv = uicontrol(ph,'Style','text','String',round(PR_CROSS*100),'Position',[280 140 50 20]);
elitslidertxt = uicontrol(ph,'Style','text','String','% elite','Position',[0 110 130 20]);
elitslider = uicontrol(ph,'Style','slider','Max',100,'Min',0,'Value',round(ELITIST*100),'Sliderstep',[0.01 0.05],'Position',[130 110 150 20],'Callback',@elitslider_Callback);
elitsliderv = uicontrol(ph,'Style','text','String',round(ELITIST*100),'Position',[280 110 50 20]);

% Popups at the bottom
representation = uicontrol(ph,'Style','popupmenu', 'String',{'path', 'adjacency', 'ordinal'}, 'Value',1,'Position',[180 262 180 20],'Callback',@representation_Callback);
crossover = uicontrol(ph,'Style','popupmenu', 'String',{'xseq_constructive', 'xalt_edges', 'xpartial_map', 'xcycle', 'xorder', 'xorder_based', 'xposition_based', 'xovsp', 'xedge_recombination', 'xmax_preservative', 'xunnamed'}, 'Value',1,'Position',[10 80 160 20],'Callback',@crossover_Callback);
stop = uicontrol(ph,'Style','popupmenu', 'String', {'default stopping criterion'}, 'Value',1,'Position',[10 50 160 20],'Callback',@crossover_Callback);
heuristic = uicontrol(ph,'Style','popupmenu', 'String',{'hybridisation off', 'seeding', '2-opt', 'both'}, 'Value',1,'Position',[10 20 130 20],'Callback',@heuristic_Callback);
parent = uicontrol(ph,'Style','popupmenu', 'String',{'linear_rank', 'exponential_rank', 'nonlinear_rank', 'fitness_proportional', 'sigma_scaling', 'tournament'}, 'Value',1,'Position',[170 80 160 20],'Callback',@parent_Callback);
survivor = uicontrol(ph,'Style','popupmenu', 'String',{'fitness_based', 'mu_lambda', 'round_robin', 'uniform'}, 'Value',1,'Position',[170 50 120 20],'Callback',@survivor_Callback);
diversity = uicontrol(ph,'Style','popupmenu', 'String',{'diversity off','diversity on'}, 'Value',1,'Position',[290 50 120 20],'Callback',@crossover_Callback);
adaptive = uicontrol(ph,'Style','popupmenu', 'String',{'adaptive parameter off', 'adaptive parameter on'}, 'Value',1,'Position',[140 20 150 20],'Callback',@crossover_Callback);
mutation = uicontrol(ph,'Style','popupmenu', 'String',{'inversion', 'reciprocal_exchange', 'displacement', 'insertion', 'simple_inversion', 'scramble', 'unnamed'}, 'Value',1,'Position',[290 20 130 20],'Callback',@mutation_Callback);

%inputbutton = uicontrol(ph,'Style','pushbutton','String','Input','Position',[55 10 70 30],'Callback',@inputbutton_Callback);
runbutton = uicontrol(ph,'Style','pushbutton','String','START','Position',[340 292 50 20],'Callback',@runbutton_Callback);

set(fh,'Visible','on');

    function load_set(data, scale)
        x = data(:,1);
        y = data(:,2);
        if scale
            x = x / max([data(:,1);data(:,2)]);
            y = y / max([data(:,1);data(:,2)]);
        end
    end

    function datasetpopup_Callback(hObject,eventdata)
        dataset_value = get(hObject,'Value');
        dataset = datasets{dataset_value};
        % load the dataset
        data = load(['datasets/' dataset]);
        load_set(data, SCALING)
        NVAR=size(data,1); 
        set(ncitiessliderv,'String',size(data,1));
        axes(ah1);
        plot(x,y,'ko') 
    end
    function llooppopup_Callback(hObject,eventdata)
        lloop_value = get(hObject,'Value');
        if lloop_value==1
            LOCALLOOP = 0;
        else
            LOCALLOOP = 1;
        end
    end
    function ncitiesslider_Callback(hObject,eventdata)
        fslider_value = get(hObject,'Value');
        slider_value = round(fslider_value);
        set(hObject,'Value',slider_value);
        set(ncitiessliderv,'String',slider_value);
        NVAR = round(slider_value);
    end
    function nindslider_Callback(hObject,eventdata)
        fslider_value = get(hObject,'Value');
        slider_value = round(fslider_value);
        set(hObject,'Value',slider_value);
        set(nindsliderv,'String',slider_value);
        NIND = round(slider_value);
    end
    function genslider_Callback(hObject,eventdata)
        fslider_value = get(hObject,'Value');
        slider_value = round(fslider_value);
        set(hObject,'Value',slider_value);
        set(gensliderv,'String',slider_value);
        MAXGEN = round(slider_value);
    end
    function mutslider_Callback(hObject,eventdata)
        fslider_value = get(hObject,'Value');
        slider_value = round(fslider_value);
        set(hObject,'Value',slider_value);
        set(mutsliderv,'String',slider_value);
        PR_MUT = round(slider_value)/100;
    end
    function crossslider_Callback(hObject,eventdata)
        fslider_value = get(hObject,'Value');
        slider_value = round(fslider_value);
        set(hObject,'Value',slider_value);
        set(crosssliderv,'String',slider_value);
        PR_CROSS = round(slider_value)/100;
    end
    function elitslider_Callback(hObject,eventdata)
        fslider_value = get(hObject,'Value');
        slider_value = round(fslider_value);
        set(hObject,'Value',slider_value);
        set(elitsliderv,'String',slider_value);
        ELITIST = round(slider_value)/100;
        GGAP = 1-ELITIST;
    end
    function crossover_Callback(hObject,eventdata)
        crossover_value = get(hObject,'Value');
        crossovers = get(hObject,'String');
        CROSSOVER = crossovers(crossover_value);
        CROSSOVER = CROSSOVER{1};
    end
    function runbutton_Callback(hObject,eventdata)
        %set(ncitiesslider, 'Visible','off');
        set(nindslider,'Visible','off');
        set(genslider,'Visible','off');
        set(mutslider,'Visible','off');
        set(crossslider,'Visible','off');
        set(elitslider,'Visible','off');
        tic;
        avgs = zeros(1,run_it);
        bests = zeros(1,run_it);
        worsts = zeros(1,run_it);
        if run_it > 1
            x = repmat(x,1,run_it);
            y = repmat(y,1,run_it);
            NIND = NIND * ones(1,run_it);
            MAXGEN = MAXGEN * ones(1,run_it);
            NVAR = NVAR * ones(1,run_it);
            ELITIST = ELITIST * ones(1,run_it);
            STOP_PERCENTAGE = STOP_PERCENTAGE * ones(1,run_it);
            PR_CROSS = PR_CROSS * ones(1,run_it);
            PR_MUT = PR_MUT * ones(1,run_it);
            CROSSOVER = repmat(convertCharsToStrings(CROSSOVER),1,run_it);
            LOCALLOOP = repmat(convertCharsToStrings(LOCALLOOP),1,run_it);
            REPRESENTATION = repmat(convertCharsToStrings(REPRESENTATION),1,run_it);
            MUTATION = repmat(convertCharsToStrings(MUTATION),1,run_it);
            HEURISTIC = repmat(convertCharsToStrings(HEURISTIC),1,run_it);
            PARENT_SELECTION = repmat(convertCharsToStrings(PARENT_SELECTION),1,run_it);
            SURVIVOR_SELECTION = repmat(convertCharsToStrings(SURVIVOR_SELECTION),1,run_it);
            parfor pi = 1:run_it
                [best,avg,worst] = run_ga(x(:,pi), y(:,pi), NIND(pi), MAXGEN(pi), NVAR(pi), ELITIST(pi), STOP_PERCENTAGE(pi), PR_CROSS(pi), PR_MUT(pi), CROSSOVER(pi), LOCALLOOP(pi), NaN, NaN, NaN, REPRESENTATION(pi), MUTATION(pi), HEURISTIC(pi) == "seeding" || HEURISTIC(pi) == "both", HEURISTIC(pi) == "2-opt" || HEURISTIC(pi) == "both", PARENT_SELECTION(pi), SURVIVOR_SELECTION(pi), false);
                bests(pi) = best;
                avgs(pi) = avg;
                worsts(pi) = worst;
            end
            fprintf("Total CPU time : %.2fs\n", toc);
            fprintf("Results averaged over all runs : best = %.2f, avg = %.2f, worst = %.2f\n", sum(bests)/run_it, sum(avgs)/run_it, sum(worsts)/run_it);
        else
            [best,avg,worst] = run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3, REPRESENTATION, MUTATION, HEURISTIC == "seeding" || HEURISTIC == "both", HEURISTIC == "2-opt" || HEURISTIC == "both", PARENT_SELECTION, SURVIVOR_SELECTION, true);
            time = toc;
            fprintf("CPU time : %.2fs\n", time);
            fprintf("Results for single run : best = %.2f, avg = %.2f, worst = %.2f\n", best, avg, worst);
        end
        % fprintf("Results totaled over all runs : best = %.2f, avg = %.2f, worst = %.2f\n", sum(bests), sum(avgs), sum(worsts));
        end_run();
    end
    function inputbutton_Callback(hObject,eventdata)
        [x,y] = input_cities(NVAR);
        axes(ah1);
        plot(x,y,'ko')
    end
    function end_run()
        %set(ncitiesslider,'Visible','on');
        set(nindslider,'Visible','on');
        set(genslider,'Visible','on');
        set(mutslider,'Visible','on');
        set(crossslider,'Visible','on');
        set(elitslider,'Visible','on');
    end

    % Custom callbacks

    function representation_Callback(hObject,eventdata)
        representation_value = get(hObject,'Value');
        representations = get(hObject,'String');
        REPRESENTATION = representations(representation_value);
        REPRESENTATION = REPRESENTATION{1};
    end
    function mutation_Callback(hObject,eventdata)
        mutation_value = get(hObject,'Value');
        mutations = get(hObject,'String');
        MUTATION = mutations(mutation_value);
        MUTATION = MUTATION{1};
    end
    function heuristic_Callback(hObject,eventdata)
        heuristic_value = get(hObject,'Value');
        heuristics = get(hObject,'String');
        HEURISTIC = heuristics(heuristic_value);
        HEURISTIC = HEURISTIC{1};
    end
    function parent_Callback(hObject,eventdata)
        parent_value = get(hObject,'Value');
        parents = get(hObject,'String');
        PARENT_SELECTION = parents(parent_value);
        PARENT_SELECTION = PARENT_SELECTION{1};
    end
    function survivor_Callback(hObject,eventdata)
        survivor_value = get(hObject,'Value');
        survivors = get(hObject,'String');
        SURVIVOR_SELECTION = survivors(survivor_value);
        SURVIVOR_SELECTION = SURVIVOR_SELECTION{1};
    end

end