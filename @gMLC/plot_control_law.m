function plot_control_law(gMLC,control_law)
% gMLC class plot_control_law method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    actuation_limit = gMLC.parameters.ProblemParameters.ActuationLimit;

%% Control law
    control_law = strrep_cl(gMLC.parameters,control_law,2);
    control_law = limit_to(control_law,actuation_limit);
      
%% Evaluation
    % Plant
        eval(['Plant=@',gMLC.parameters.problem,'_problem;']);
        
    % Evaluation
        J = Plant(control_law,gMLC.parameters,0,'',1); % save_ss

%% fprintf
    fprintf('Cost of control law : J = %f\n',J{1})
end %method
