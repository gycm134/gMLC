function gMLC_simplex=step_ordering(gMLC_simplex,gMLC_parameters)
% gMLCsimplex class step_ordering method
%
% Rearrange the labels following the costs.
% Lower costs has lower rank.
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    BS = gMLC_parameters.SimplexSize;

if VERBOSE > 3, fprintf('    o Ordering : '),end
%% Update properties
    % Individuals informations
        labels = gMLC_simplex.labels;
        costs = gMLC_simplex.costs;
    % Sort
        [~,idx] = sort(costs);
    % New vertices
	vertices = labels(idx);
    % Update simplex
        gMLC_simplex.labels = vertices;
        gMLC_simplex.costs = costs(idx);
 
    % Stat
        gMLC_simplex.status.last_operation = 'ordering';

if VERBOSE > 3, fprintf('Done\n'),end

end %method
