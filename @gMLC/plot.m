function plot(gMLC,ID)
% gMLC class plot method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    actuation_limit = gMLC.parameters.ProblemParameters.ActuationLimit;

if VERBOSE > 4, fprintf('Start - '),end

    %% Evaluation function
    eval(['Plant=@',gMLC.parameters.problem,'_problem;']);

    %% Control : Definition, replacement and limitation
      control_law = gMLC.table.individuals(ID).control_law;
      control_law = strrep_cl(gMLC.parameters,control_law,2);
      control_law = limit_to(control_law,actuation_limit);

    %% Evaluation and plot
        J = Plant(control_law,gMLC.parameters,0,'',1); % save_ss

        % bad value test
        if isnan(J{1}) || isinf(J{1})
            J{1} = gMLC.parameters.BadValue;
        end

    %% Output
        fprintf('   Cost of individual %i : %f\n',ID,J{1})
        

end %method
