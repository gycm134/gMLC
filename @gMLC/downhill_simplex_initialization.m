function gMLC=downhill_simplex_initialization(gMLC)
% gMLC class downhill_simplex_initialization method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    BIS = gMLC.parameters.Number_MonteCarlo_Init;
    BS = gMLC.parameters.SimplexSize;

%% Step
    % Generate the initial individuals
      gMLC.simplex.generate_random(gMLC.table,gMLC.parameters);
      labels = gMLC.simplex.initial_individuals.labels;

  % Fill the simplex adequately
    % Take the most performant individual and take the closest one to it.
    % TO BE DONE
    error('Not coded yet...')
    gMLC.simplex.labels = labels(idx(1:BS));
    gMLC.simplex.costs = best_costs((1:BS));
    gMLC.simplex.status.last_operation = 'Filled from Monte Carlo';
    gMLC.simplex.status.evaluated = 'evaluated';

%% Update properties

end %method
