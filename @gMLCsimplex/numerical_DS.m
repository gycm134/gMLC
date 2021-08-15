function numerical_DS(gMLC_simplex,gMLC_table,gMLC_parameters)
% gMLC class numerical_DS method
% Computes the simplex of the control points.
% These simplexed points will then be used to compute the simplex
% substitutes.
% This method is abandonned as it is too slow and not reliable enough
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    N_EP = gMLC_parameters.ControlLaw.ControlPointNumber;
    MI = gMLC_parameters.ProblemParameters.OutputNumber;
    N_CP = N_EP*MI;
    BS = gMLC_parameters.SimplexSize;

%% Ordering
    gMLC_simplex.step_ordering(gMLC_parameters);

%% Downhill simplex
    % Initialization
        centroid = NaN(1,N_CP);
        reflected = NaN(1,N_CP);
        expanded = NaN(1,N_CP);
        contracted = NaN(1,N_CP);
        shrinked = NaN(BS,N_CP);
    % Tools
        labels = gMLC_simplex.labels;
        costs = gMLC_simplex.costs;
        good_indiv = costs < gMLC_parameters.BadValue/10^3;
        labels = labels(good_indiv);
    % Labels
        IDend = gMLC_simplex.labels(end);
        ID1 = gMLC_simplex.labels(1);
        IDs = gMLC_simplex.labels(2:end);
    % Control points
        CP1 = gMLC_table.ControlPoints(ID1,:);
        ControlPoints(:,:) = gMLC_table.ControlPoints(labels,:);
    % Initial
        to_reflect = gMLC_table.ControlPoints(IDend,:);
        to_expand = gMLC_table.ControlPoints(IDend,:);
        to_contract = gMLC_table.ControlPoints(IDend,:); % the least performant individual
        to_shrink = gMLC_table.ControlPoints(IDs,:);
    % Simplexed
        centroid(:) = mean(ControlPoints(1:(end-1),:),1);
        reflected(:) = 2*centroid-to_reflect;
        expanded(:) = 3*centroid-2*to_expand;
        contracted(:) = 0.5*(centroid+to_contract);
        shrinked = 0.5*(to_shrink+CP1);

%% Print
    if VERBOSE > 3, fprintf('    o Reflect : Done\n'),end
    if VERBOSE > 3, fprintf('    o Expanse : Done\n'),end
    if VERBOSE > 3, fprintf('    o Single contraction : Done\n'),end
    if VERBOSE > 3, fprintf('    o Shrink : Done\n'),end

%% Update properties
    gMLC_simplex.to_build = vertcat(reflected,expanded,contracted,shrinked);
    gMLC_simplex.status.evaluated = 'not evaluated';
    gMLC_simplex.status.last_operation = 'numerical DS';

end %method
