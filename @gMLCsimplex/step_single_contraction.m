function gMLC_simplex=step_single_contraction(gMLC_simplex,gMLC_table,gMLC_parameters)
% gMLCsimplex class step_single_contraction method
%
% Single contraction and evaluation of the individual
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    N_EP = gMLC_parameters.ControlLaw.ControlPointNumber;
    MI = gMLC_parameters.ProblemParameters.OutputNumber;
    N_CP = N_EP*MI;
    WeightedMatrix = gMLC_parameters.WeightedMatrix;
    problem_type = gMLC_parameters.problem_type;

if VERBOSE > 3, fprintf('    o Single contraction : \n'),end

%% Compute single contraction
    % Best individual
    J1 = gMLC_simplex.costs(1);
    % Individual to contract and centroid
    IDend = gMLC_simplex.labels(end);
    Jend = gMLC_simplex.costs(end);

        if WeightedMatrix
                Indc = gMLCind;
                Indc.simplex_labels = gMLC_simplex.labels;
                Indc.DS_coeff(gMLC_table,3);
        else

    % Initialization
    contracted = NaN(1,N_CP);
    to_contract = gMLC_table.ControlPoints(IDend,:); % the least performant individual
    centroid = gMLC_simplex.centroid;
    % Reflection
    contracted(:) = 0.5*(centroid+to_contract); % Contraction towards the centroid

%% Buil the control law
    % Call MLC
    Indc = gMLCind;
    qua = Indc.build_to_fit(contracted,gMLC_table,gMLC_parameters);
    Indc.description.quality = qua;
	end

%% Update individual
    Indc.description.subtype = ['contracted'];
    Indc.description.parents = IDend;

    % Add to table
    ID=gMLC_table.add(Indc,gMLC_parameters);
    % To evaluate
    gMLC_simplex.status.individuals_to_evaluate = [gMLC_simplex.status.individuals_to_evaluate;ID];

%% Evaluation
% External evaluation test
    if strcmp(problem_type,'external')
      if VERBOSE > 2, fprintf('     External evaluation. '),end
      gMLC_simplex.waiting_room.labels = [gMLC_simplex.waiting_room.labels;ID];
      if VERBOSE > 3, fprintf('Ready.\n'),end
        % Continue simplex
        gMLC_simplex.step_shrink(gMLC_table,gMLC_parameters);
        % Update
        gMLC_simplex.status.last_operation = 'single contraction';
      return
    end
% The control law is evaluated here, so no need to put in the individuals_to_evaluate array.
% But if there were to not be evaluated, they need to be added to the array
    Jc=gMLC_table.evaluate(ID,gMLC_parameters,0); % visu
      cycle = gMLC_simplex.status.cycle+1;
      N_ev = length(gMLC_simplex.status.individuals_to_evaluate);
    gMLC_table.individuals(ID).evaluation_order = [cycle,N_ev];

%% Update properties
    % Individuals informations
        gMLC_simplex.waiting_room.labels = [gMLC_simplex.waiting_room.labels;ID];
        gMLC_simplex.waiting_room.costs = [gMLC_simplex.waiting_room.costs;Jc];
    % Stat
        gMLC_simplex.status.last_operation = 'single contraction';

if VERBOSE > 3, fprintf('Done\n'),end

%% Next step
 if Jc >= Jend
   gMLC_simplex.step_shrink(gMLC_table,gMLC_parameters);
 end

end %method
