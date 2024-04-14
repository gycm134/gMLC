function External_exploration_END(gMLC_name)
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
    gmlc.complete_EXE('evolution');
    % End the cycle
    gmlc.history.cycle(1)=gmlc.history.cycle(1)+1;
    gmlc.simplex.status.cycle = gmlc.simplex.status.cycle+1;
    gmlc.new_cycle(2);

%% Set exploitation limit
    Nevaluations = sum(gmlc.table.evaluated>0);
    gmlc.parameters.ExternalStopExi = Nevaluations+gmlc.parameters.NOffsprings;
    delete('STOP_EXPLOITATION')
    delete('CONTINUE_INTERPOLATION')

%% Save
    gmlc.save;
