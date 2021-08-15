function [qua,gMLC_ind]=build_to_fit(gMLC_ind,ControlPoints,gMLC_table,gMLC_parameters)
% gMLCind class build_to_fit method
% This funtion creates an GPC substute for a control law
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    num_gen = gMLC_parameters.NumberGenerations;
    problem = gMLC_parameters.problem;
    number = gMLC_table.number;
    NumberSensors = gMLC_parameters.ProblemParameters.NumberSensors;

%% Initialize MLC
    % Initiliaze
    lgpc = MLC(problem,1);
    lgpc.parameters = gMLC_parameters;
    lgpc.parameters.EvaluationFunction = 'CL_interpolation';

    % Initialize population
    lgpc.parameters.to_build = ControlPoints;

    % Remplace the sensors by s functions
    Sensors = cell(1,NumberSensors); %*
    for p=1:NumberSensors,Sensors{p} = ['s(',num2str(p),')'];end %*
    lgpc.parameters.ProblemParameters.Sensors = Sensors;
%% Compute
    lgpc.go(num_gen);

%% best individual
    label = lgpc.population(end).individuals(1);

%% Update properties
    gMLC_ind.matrix = lgpc.table.individuals(label).chromosome;
    gMLC_ind.control_law = lgpc.table.individuals(label).control_law;
    gMLC_ind.description.type = 'interpolated';

%% Output
    qua = lgpc.population(end).costs(1);
end %method
