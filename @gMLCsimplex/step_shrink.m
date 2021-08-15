function gMLC_simplex=step_shrink(gMLC_simplex,gMLC_table,gMLC_parameters)
% gMLCsimplex class step_shrink method
%
% Shrink and evaluation of the individual
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    N_EP = gMLC_parameters.ControlLaw.ControlPointNumber;
    MI = gMLC_parameters.ProblemParameters.OutputNumber;
    N_CP = N_EP*MI;
    BS = gMLC_parameters.SimplexSize;
    WeightedMatrix = gMLC_parameters.WeightedMatrix;
    problem_type = gMLC_parameters.problem_type;

if VERBOSE > 3, fprintf('    o Shrink : \n'),end

%% Compute shrinking
    % Best individual
    ID1 = gMLC_simplex.labels(1);
    CP1 = gMLC_table.ControlPoints(ID1,:);
    % Individual to shrink and centroid
    IDs = gMLC_simplex.labels(2:end);
    Jend = gMLC_simplex.costs(end);
    % Initialization
    shrinked = NaN(BS,N_CP);
    to_shrink = gMLC_table.ControlPoints(IDs,:);
    % Shrinking
    shrinked = 0.5*(to_shrink+CP1); % Contraction towards the best individual

%% Buil the control laws
    % Call MLC
    ID = zeros(length(IDs),1);
    for p=1:length(IDs)
        Indm = gMLCind;

		if WeightedMatrix
            Indm.simplex_labels = gMLC_simplex.labels;
			Indm.DS_coeff(gMLC_table,4,p+1);
		else

	qua = Indm.build_to_fit(shrinked(p,:),gMLC_table,gMLC_parameters);
        Indm.description.quality = qua;
		end
        Indm.description.subtype = ['shrinked'];
        Indm.description.parents = [IDs(p),ID1];
        % Add to table
        id = gMLC_table.add(Indm,gMLC_parameters);
        ID(p) = id;
    end
    % To evaluate
    gMLC_simplex.status.individuals_to_evaluate = [gMLC_simplex.status.individuals_to_evaluate;ID];

%% Evaluation
% External evaluation test
    if strcmp(problem_type,'external')
      if VERBOSE > 2, fprintf('     External evaluation. '),end
      gMLC_simplex.waiting_room.labels = [gMLC_simplex.waiting_room.labels;ID];
      if VERBOSE > 3, fprintf('Ready.\n'),end
        % Nothing to continue
        % Update
        gMLC_simplex.status.last_operation = 'shrink';
      return
    end
% The control law is evaluated here, so no need to put in the individuals_to_evaluate array.
% But if there were to not be evaluated, they need to be added to the array
    Jm = -1*ones(length(IDs),1);
    cycle = gMLC_simplex.status.cycle+1;
    for p=1:length(IDs)
      jm=gMLC_table.evaluate(ID(p),gMLC_parameters,0); % 0=no visu
      N_ev = length(gMLC_simplex.status.individuals_to_evaluate)+p-length(IDs);
      gMLC_table.individuals(ID(p)).evaluation_order = [cycle,N_ev];
      Jm(p) = jm;
    end

%% Update properties
    % Individuals informations
        gMLC_simplex.waiting_room.labels = [gMLC_simplex.waiting_room.labels;ID];
        gMLC_simplex.waiting_room.costs = [gMLC_simplex.waiting_room.costs;Jm];
    % Stat
        gMLC_simplex.status.last_operation = 'shrink';

if VERBOSE > 3, fprintf('Done\n'),end

end %method
