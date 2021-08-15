function gMLC=import(gMLC,gMLCSource,NImports,are_they_labels)
% gMLC class import method
% Extracts the first NImports individuals from gMLCSource and fills gMLC
% with them.
% So we have a copy of the gMLCSource containing the first NImports
% individuals.
%
% Guy Y. Cornejo Maceda, 11/14/2019
%
% See also SIN, COS, TheOtherFunction.

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    Name = gMLC.parameters.Name;
    gMLC.parameters = gMLCSource.parameters;
    gMLC.parameters.Name = Name;
    NameSource = gMLCSource.parameters.Name;
    if nargin<4, are_they_labels=0;end

%% Check if possible
    if sum(gMLCSource.table.evaluated>0)<NImports
        error('The source has not enough individuals to import')
    end
 
%% Select the individuals (labels)
if are_they_labels
    labels = NImports;
else
    % We take all the individuals before the NImports evaluations
    % because the non evaluated individuals helped to create the new
    % individuals.
    SourceEvalIndiv = gMLCSource.table.evaluated;
    SourceEvalIndiv(SourceEvalIndiv<0) = [];
    CumSourceEvalIndiv = cumsum(SourceEvalIndiv);
    IDX = find(CumSourceEvalIndiv==NImports);
    labels = 1:IDX; % Should be imported
end

%% Extract cycles
    MaxCycle = -Inf*ones(numel(labels),1);
    for p=1:numel(labels)
        MaxCycle(p) = gMLCSource.table.individuals(labels(p)).evaluation_order(1);
    end
    MaxCycle = max(unique(MaxCycle));
    
%% Fill properties
    % Basket
    gMLC.simplex = gMLCSource.simplex.copy(gMLCSource.parameters);
    
    % Stock
    fprintf('Stock is not processed for now...\n');
    
    % Landscapesimplex
    if not(isempty(gMLCSource.landscape_labels))
        LandscapeCycle = find(gMLCSource.landscape_labels(:,1)==MaxCycle);
        gMLC.landscape_labels = gMLCSource.landscape_labels(1:LandscapeCycle,:);
    end
    
    % table
        % individuals
        ind=gMLCind;
    gMLC.table.individuals = repmat(ind,[numel(labels),1]);
    for p=1:numel(labels)
        gMLC.table.individuals(p) = gMLCSource.table.individuals(labels(p)).copy;
    end
        % control points
    gMLC.table.ControlPoints = gMLCSource.table.ControlPoints(labels,:);
        % evaluated
    gMLC.table.evaluated = gMLCSource.table.evaluated(labels);
        % isamatrix
    gMLC.table.isamatrix = gMLCSource.table.isamatrix(labels);
        % number
        if are_they_labels
            gMLC.table.number = numel(NImports);
        else
            gMLC.table.number = NImports;
        end
    
    % history
    if not(isempty(gMLCSource.history.facts))
        FactCycle = find(gMLCSource.history.facts(:,1)==MaxCycle);
        gMLC.history.facts = gMLCSource.history.facts(1:FactCycle,:);
    end
    if (MaxCycle==-1)
        gMLC.history.cycle = [0,0];
        gMLC.simplex.status.cycle = 0;
    else
        gMLC.history.cycle = [MaxCycle,MaxCycle];
        gMLC.simplex.status.cycle = MaxCycle;
    end
%% Update properties
    % Basket
        % Update labels and cost.
        gMLC.simplex.status.last_operation = 'importation';
        new_labels = gMLC.simplex.update(gMLC.table,gMLC.parameters);
        gMLC.simplex.status.last_operation = 'importation';
    % History
    if gMLC.history.facts(1)==-1
        gMLC.history.facts(1,2:end) = new_labels;
    end

%% Print
fprintf(['Importation from ',NameSource,' to ',Name,': Done!\n'])

%% Copy data
    fprintf('Copy data : ...\n\n')
    % Folders
    create_folders(Name);
    % Paths
    dir = ['save_runs/',Name];
    dirSource = ['save_runs/',NameSource];
    % Copy/Paste
    if not(isempty(labels))
        NLs = num2str(max(labels));
%     system(['cp ',dirSource,'/Actuations/ID{1..',NLs,'}.dat ',dir,'/Actuations/']);
%     system(['cp ',dirSource,'/Sensors/ID{1..',NLs,'}.dat ',dir,'/Sensors/']);
    end
        % Sensors
      if not(exist([dir,'/Sensors'],'dir')),mkdir([dir,'/Sensors']);end

end %method
