function External_initialization_START(gMLC_problem,gMLC_name)
% Function to initialize the gMLC process
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Initialization
    Initialization;
    gmlc=gMLC(gMLC_problem);
    gmlc.parameters.Name = gMLC_name;
    gmlc.go;

%% Write the control laws into the file save_runs/tmp/ControlLawSelect.m.
    labels = gmlc.simplex.initial_individuals.labels;
    gmlc.expe_create_control_select(labels);

%% Save
    gmlc.save;
