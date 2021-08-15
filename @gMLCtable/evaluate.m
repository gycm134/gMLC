function [J,gMLC_table] =evaluate(gMLC_table,ID,gMLC_parameters,visu)
% gMLCtable class evaluate method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    problem_type = gMLC_parameters.problem_type;

%% Compute cost
    if strcmp(problem_type,'external')
        J=-1;
    else
        J = gMLC_table.individuals(ID).evaluate(gMLC_parameters,visu);
    end
    
%% Update properties
    if (~isnan(J))&&(~isinf(J))
      gMLC_table.evaluated(ID)=1;
    else
      gMLC_table.evaluated(ID)=NaN;
    end

end %method
