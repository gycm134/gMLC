function External_exploration_START(gMLC_name)
% Function to perform one evolution step of gMLC
%
%	Copyright (C) 2023 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Initialization
    Initialization;
    gmlc=gMLC;
    gmlc.load(gMLC_name);
   
%% Complete subtitution
    % Complete the individuals interpolated in basket.to_build
    gmlc.complete_interpolation_EXE;
    
%% Evolution
    % Start a new cycle
    gmlc.history.cycle(2) = gmlc.history.cycle(1)+1; % NEEDED ?
    gmlc.new_cycle(1);
    % Evolve
    gmlc.simplex.status.last_operation = 'Subtitute computed'; % no need top interpolate in this phase
    gmlc.step_evolution;
    
%% Create Setx file?
    gmlc.export_set_EXE('EVO');

%% Write the control laws into the file save_runs/tmp/ControlLawSelect.m.
    labels = gmlc.simplex.waiting_room.labels;
    gmlc.expe_create_control_select(labels);
    
%% Save
    gmlc.save;
