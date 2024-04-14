function External_initialization_END(gMLC_name)
% Function to import the costs of individuals evaluated and complete the
% evolution step of gMLC.
%
%	Copyright (C) 2023 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Initialization
    Initialization;
    gmlc=gMLC;
    gmlc.load(gMLC_name);

%% Complete evolution
    % Complete
    gmlc.complete_EXE('Monte Carlo');

%% Set exploitation limit
    delete('STOP_FINISHED')
    delete('CONTINUE_INTERPOLATION')

%% Save
    gmlc.save;
