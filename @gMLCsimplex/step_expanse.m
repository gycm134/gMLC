function gMLC_simplex=step_expanse(gMLC_simplex,gMLC_table,gMLC_parameters)
% gMLCsimplex class step_expanse method
%
% Expansion and evaluation of the individual
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    N_EP = gMLC_parameters.ControlLaw.ControlPointNumber;
    MI = gMLC_parameters.ProblemParameters.OutputNumber;
    N_CP = N_EP*MI;
    WeightedMatrix = gMLC_parameters.WeightedMatrix;
    problem_type = gMLC_parameters.problem_type;

if VERBOSE > 3, fprintf('    o Expanse : \n'),end

%% Compute reflection
    % Individual to expand and centroid
    IDend = gMLC_simplex.labels(end);
    Jend = gMLC_simplex.costs(end);

        if WeightedMatrix
                Inde = gMLCind;
                Inde.simplex_labels = gMLC_simplex.labels;
                Inde.DS_coeff(gMLC_table,2);
        else

    % Initialization
    expanded = NaN(1,N_CP);
    % Control poinst
    to_expand = gMLC_table.ControlPoints(IDend,:);
    centroid = gMLC_simplex.centroid;
    % Expansion
    expanded(:) = 3*centroid-2*to_expand;

%% Buil the control law
    % Call MLC
    Inde = gMLCind;
    qua = Inde.build_to_fit(expanded,gMLC_table,gMLC_parameters);
    Inde.description.quality = qua;
	end

%% Update individual
    Inde.description.subtype = ['expanded'];
    Inde.description.parents = IDend;

    % Add to table
    ID=gMLC_table.add(Inde,gMLC_parameters);
    % To evaluate
    gMLC_simplex.status.individuals_to_evaluate = [gMLC_simplex.status.individuals_to_evaluate;ID];


%% Evaluation
% External evaluation test
    if strcmp(problem_type,'external')
      if VERBOSE > 2, fprintf('     External evaluation. \n'),end
      gMLC_simplex.waiting_room.labels = [gMLC_simplex.waiting_room.labels;ID];
      if VERBOSE > 3, fprintf('Ready.\n'),end
        % Nothing to continue
        % Update
        gMLC_simplex.status.last_operation = 'expand';
      return
    end
% The control law is evaluated here, so no need to put in the individuals_to_evaluate array.
% But if there were to not be evaluated, they need to be added to the array
    Je=gMLC_table.evaluate(ID,gMLC_parameters,0); % visu
    cycle = gMLC_simplex.status.cycle+1;
    N_ev = length(gMLC_simplex.status.individuals_to_evaluate);
    gMLC_table.individuals(ID).evaluation_order = [cycle,N_ev];
    gMLC_simplex.status.individuals_to_evaluate = [gMLC_simplex.status.individuals_to_evaluate;ID];

%% Update properties
    % Individuals informations
        gMLC_simplex.waiting_room.labels = [gMLC_simplex.waiting_room.labels;ID];
        gMLC_simplex.waiting_room.costs = [gMLC_simplex.waiting_room.costs;Je];
    % Stat
        gMLC_simplex.status.last_operation = 'expand';

if VERBOSE > 3, fprintf('Done\n'),end

end %method
