function gMLC=step_end(gMLC)
% gMLC class step_end method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    cycle = gMLC.history.cycle;
    problem_type = gMLC.parameters.problem_type;

%% Step3
    if VERBOSE > 0, fprintf('########### UPDATE ############\n'),end
    % External evaluation (To be removed)
        % Evaluate initial simplex
        if strcmp(problem_type,'external')
          % waiting room
          labels = gMLC.simplex.waiting_room.labels;
          gMLC.send_EXE(labels);
          gMLC.simplex.status.last_operation = 'Send_to_ExE';
          gMLC.simplex.status.evaluated = 'nonevaluated';
          gMLC.simplex.waiting_room.costs = -1+0*labels;
          if VERBOSE > 0, fprintf('Sent to external evaluation!\n'),end
          return
        end

      % gMLC method
    gMLC.history.cycle(1)=gMLC.history.cycle(1)+1;
    gMLC.simplex.status.cycle = gMLC.simplex.status.cycle+1;

    if VERBOSE > 0, fprintf('############# END #############\n'),end

end %method
