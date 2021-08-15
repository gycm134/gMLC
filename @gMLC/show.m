function show(gMLC,plt)
% gMLC class show method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    actuation_limit = gMLC.parameters.ProblemParameters.ActuationLimit;
    problem_type = gMLC.parameters.problem_type;
    if nargin<2,plt=1;end

    if gMLC.history.cycle(1)<0
        fprintf('No optimization yet\n')
        return
    end

%% Best individual
    labels = gMLC.simplex.labels;
    costs = gMLC.simplex.costs;

%% Sort
    [~,idx] = min(costs);

%% Individual
        gMLC_ind = gMLC.table.individuals(labels(idx));

%% Print
    fprintf('\n')
    fprintf('Best individual(s), their cost(s) and control law:\n')
    fprintf('   individual : %i\n',labels(idx))
    fprintf('   cost: %f\n',costs(idx))
    fprintf('   control law:')
    fprintf('\n')
    for q=1:gMLC.parameters.ProblemParameters.OutputNumber
   		fprintf('      b%i = ',q)
		fprintf(gMLC_ind.control_law{q})
    		fprintf('\n')
	  end
    fprintf(['   type: ',gMLC_ind.description.type,'\n'])
    if strcmp(gMLC_ind.description.type,'interpolated') || ...
	strcmp(gMLC_ind.description.type,'coef DS')
      fprintf(['    subtype: ',gMLC_ind.description.subtype,'\n'])
      fprintf(['    quality: ',num2str(gMLC_ind.description.quality),'\n'])
      fprintf('    parents: %i\n',gMLC_ind.description.parents(1))
    end

%% Plot
    if plt && not(strcmp(problem_type,'external'))
    % Control law
    control_law = gMLC_ind.control_law;
    control_law = strrep_cl(gMLC.parameters,control_law,2);
    control_law = limit_to(control_law,actuation_limit);
    % Plant
    eval(['Plant=@',gMLC.parameters.problem,'_problem;']);
    % Evaluation
    Plant(control_law,gMLC.parameters,0,'',1); % save_ss
    end

end %method
