function gMLC=monte_carlo(gMLC)
% gMLC class monte_carlo method
%
% This method generates a given number of individuals and evaluates them.
% The 10 (BS) best individuals are then transferred to the simplex.
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    BIS = gMLC.parameters.Number_MonteCarlo_Init;
    BS = gMLC.parameters.SimplexSize;
    problem_type = gMLC.parameters.problem_type;
    InitializationClustering = gMLC.parameters.InitializationClustering;
    LandscapeType = gMLC.parameters.LandscapeType;
    BadValue = gMLC.parameters.BadValue;

%% Initialization step
      % Generate the initial individuals
      gMLC.simplex.generate_random(gMLC.table,gMLC.parameters);

      % Stock labels
      labels = gMLC.simplex.initial_individuals.labels;

      % Evaluate initial simplex
      if strcmp(problem_type,'external')
        gMLC.send_EXE(labels,'MonteCarlo');
        gMLC.simplex.status.last_operation = 'Send_to_ExE';
        gMLC.simplex.status.evaluated = 'nonevaluated';
        gMLC.simplex.waiting_room.labels = labels;
        gMLC.simplex.waiting_room.costs = -1+0*labels;
        return
      end

      % Evaluate simplex
      if VERBOSE > 2, fprintf('     Evaluation of the simplex\n'),end
      cycle = gMLC.simplex.status.cycle;
      for p=1:BIS
        gMLC.table.evaluate(labels(p),gMLC.parameters,0);
        gMLC.table.individuals(labels(p)).evaluation_order = [cycle,p];
        if (VERBOSE > 4) && not(mod(p,10)), fprintf('\n'),end
      end
      if VERBOSE > 2, fprintf('     End of simplex Evaluation\n'),end

%% Clustering or not?
        % What are the costs?
        costs = gMLC.table.costs(labels);
        
        % Clutering or not?
      if InitializationClustering
          if VERBOSE > 0, fprintf('  o Landscape description: %s\n',LandscapeType),end

          % Initialization
          NLandscapeLabels = BS;
          labels_to_cluster = labels(costs<BadValue/10);Nlabels = length(labels_to_cluster);
          
          if Nlabels<BS
              error('Not enough individuals in to Cluster (because of MC or BadValue)\n')
          end
          % Cluster following the type
          switch LandscapeType
              case 'CostSection'
                      NPerSection = floor(BIS/NLandscapeLabels);
                      LandscapeLabels = labels_to_cluster(1:NPerSection:NPerSection*NLandscapeLabels);
              otherwise
                  error('Wrong LandscapeType')
          end
          % LandscapeLabels -> vertices
          vertices = LandscapeLabels;
          if sum(isnan(vertices)), error('Clustering failed to give enough individuals'),end
          
      else % No cluster - just take the best individuals
      % Best individuals
        [~,idx] = sort(costs);
      % vertices
    	vertices = labels(idx(1:BS));
      end
      
    % Initialize the vertices in the database
    for p=1:gMLC.table.number
        gMLC.table.individuals(p).vertices = p;
        gMLC.table.individuals(p).coefficients = 1;
    end
        
    % Fill simplex
    gMLC.simplex.labels = vertices;
    gMLC.simplex.costs = gMLC.table.costs(vertices); 
    if InitializationClustering
        gMLC.simplex.status.last_operation = ['Filled from Monte Carlo - ',LandscapeType];
    else
        gMLC.simplex.status.last_operation = 'Filled from Monte Carlo';
    end
    gMLC.simplex.status.evaluated = 'evaluated';

%% Update properties
      % Nothing to update

end %method
