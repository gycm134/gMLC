function LandscapeLabels=landscape_description(gMLC)
% gMLC class landscape_description method
% Computes 40 "clusters" of the data base and extracts representatives for
% each cluster.
%
% Guy Y. Cornejo Maceda, 10/07/2019
%
% See also step_evolution

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    BadValue = gMLC.parameters.BadValue;
    LandscapeType = gMLC.parameters.LandscapeType;
    cycle = gMLC.history.cycle(1);
    NLandscapeLabels = 40;
    
if VERBOSE > 0, fprintf('  o Landscape description: %s\n',LandscapeType),end

%% Initialiazation
    number = gMLC.table.number;
    labels = transpose(1:number);
    % evaluated
    labels = labels(gMLC.table.evaluated>0);Nlabels = length(labels);
    % good cost or not
    costs = gMLC.table.costs(labels);
    labels_to_cluster = labels(costs<BadValue/10);Nlabels = length(labels_to_cluster);
    ToAdd = zeros(1,NLandscapeLabels);


%% Select the landscape labels
    switch LandscapeType
        case 'CostSection'
            if Nlabels<NLandscapeLabels
                LandscapeLabels = labels_to_cluster;
            else
                NPerSection = floor(Nlabels/NLandscapeLabels);
                LandscapeLabels = labels_to_cluster(1:NPerSection:NPerSection*NLandscapeLabels);
            end
        otherwise 
            error('Wrong LandscapeType')
    end

%% Update properties
    ToAdd(1:numel(LandscapeLabels))=LandscapeLabels;
    gMLC.landscape_labels = vertcat(gMLC.landscape_labels,[cycle+1,ToAdd]);

end %method
