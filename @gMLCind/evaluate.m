function indiv_cost=evaluate(gMLC_ind,gMLC_parameters,visu,force_eval)
% gMLCind class evaluate method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    if nargin<3,visu=0;end
    actuation_limit = gMLC_parameters.ProblemParameters.ActuationLimit;
    Name = gMLC_parameters.Name;
    save_data = gMLC_parameters.save_data;
    MultipleEvaluations = gMLC_parameters.MultipleEvaluations;
    if nargin<4, force_eval = MultipleEvaluations;end
    problem_type = gMLC_parameters.problem_type;
    
if VERBOSE > 4, fprintf('%i',gMLC_ind.ID),end

%% Verify
    if ( gMLC_ind.cost{1} > 0 && not(force_eval) )
      if VERBOSE > 4, fprintf('ad. '),end
      indiv_cost = gMLC_ind.cost{1};
      return
    end

%% Evaluate following the problem_type
switch problem_type
    case 'dummy'
        J = {rand};
    case 'internal'
        % Control problem
        eval(['Plant=@',gMLC_parameters.problem,'_problem;']);
        % Control : Definition, replacement and limitation
        control_law = gMLC_ind.control_law;
        control_law = strrep_cl(gMLC_parameters,control_law,2);
%        control_law = limit_to(control_law,actuation_limit);
% Now the thresh should be done in the Plants
        % Evaluation
        tic;
        dir = ['save_runs/',Name,'/'];
        save_indiv = logical(save_data)*gMLC_ind.ID;
        J = Plant(control_law,gMLC_parameters,save_indiv,dir,visu); % save_ss
    case 'LabView'
        LabViewPath = gMLC_parameters.LabViewPath;
        % Create control law file
        CreatefunctionLabview(gMLC_parameters,gMLC_ind);
        tic;
        % Wait
        fprintf('Waiting for J.txt in\n')
        fprintf(['  ',LabViewPath,'\n'])
        while not(exist([LabViewPath,'J.txt'],'file'))
%             pause(1)
        end
        fprintf('    Here it is!\n')    
        % Read and delete J.txt
        J = load([LabViewPath,'J.txt'],'-ascii'); J = {J};
        % Actuation penalization and other components
%         J = [J_components(1)+sum(J_components(2:end).*gamma),J_components];
        delete([LabViewPath,'J.txt']);
end

%% bad value test
    if isnan(J{1}) || isinf(J{1})
        J{1} = gMLC_parameters.BadValue;
    end
        
%% Update properties
    cost = gMLC_ind.cost;
    if cost{1}<0,cost={};end
    gMLC_ind.cost = vertcat(cost,J);
    eval_time = gMLC_ind.evaluation_time;
    if eval_time==0, eval_time=[];end
    gMLC_ind.evaluation_time = vertcat(eval_time,toc);

%% Output
    indiv_cost = mean(cell2mat(gMLC_ind.cost(:,1)));

if VERBOSE > 4, fprintf('. '),end

end %method
