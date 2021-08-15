function complete_REC_S_EXE(gMLC,optimization_type)
% gMLC class continue_reflection method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    gamma = gMLC.parameters.ProblemParameters.gamma;
    BadValue = gMLC.parameters.BadValue;
    BS = gMLC.parameters.SimplexSize;
    % Path
    PathExt = gMLC.parameters.ProblemParameters.PathExt;
  
%% Initialization
    dir_cost = PathExt;

%% Cycle Test
    cycle = gMLC.history.cycle;
    if cycle(1)==cycle(2)
        fprintf('\nCycle already completed ! \n')
        fprintf('You can go. \n')
        return
    end
    
%% Optimization type
    switch optimization_type
        case 'REC'
            label_range = 1:3;
        case 'shrink'
            label_range = 4:BS;
        otherwise
            error('Wrong optimization type')
    end
%% Fill the waiting control laws  (Import values)
    % Which control laws
    waiting_labels = gMLC.simplex.waiting_room.labels;
    labels_to_process = waiting_labels(label_range);
    % Complete the control laws
    for p=1:numel(labels_to_process)
        % load
      file_cost = [dir_cost,'ID',num2str(labels_to_process(p)),'.dat'];
      if exist(file_cost,'file')
        J_components = load(file_cost,'-ascii');
        J = [J_components(1)+sum(J_components(2:end).*gamma),J_components];
        J = num2cell(J);
        cost = gMLC.table.individuals(labels_to_process(p)).cost;
        if cost{1}<0,cost={};end
        gMLC.table.individuals(labels_to_process(p)).cost = vertcat(cost,J);
      else
        gMLC.table.individuals(labels_to_process(p)).cost = {BadValue};
      end
    end
    % Fill the waiting list
    gMLC.simplex.waiting_room.costs(1:numel(labels_to_process)) = gMLC.table.costs(labels_to_process);
        
    
    