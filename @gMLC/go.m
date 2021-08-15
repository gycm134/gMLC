function go(gMLC,NCYCLE)
% gMLC class go method
%
% Computes gMLC cycles until the NCYCLE is reached.
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    Name = gMLC.parameters.Name;
    problem_type = gMLC.parameters.problem_type;
    external_interpolation = gMLC.parameters.external_interpolation;
    % If NCYCLE is given it has the priority
    if nargin==2
      gMLC.parameters.criterion = 'number of cycles';
    end
    % Initialize the number of cycles to do
    switch gMLC.parameters.criterion
      case 'find better than'
        gMLC.history.cycle(2)=Inf;
        NCYCLE=Inf;
      otherwise
          if nargin < 2
            gMLC.history.cycle(2)=gMLC.history.cycle(1)+1;
            NCYCLE=gMLC.history.cycle(2);
          else
            gMLC.history.cycle(2)=NCYCLE;
          end
    end

%% Folders
    % create them
    create_folders(Name);

%% Print
    if VERBOSE > 0, fprintf('==========================='),end
    if VERBOSE > 0, fprintf('===========================\n'),end
    if VERBOSE > 0, fprintf('                      gMLC.0\n'),end

%% Present the problem
    gMLC.show_problem;

%%  Step0 : Initialization
        if strcmp(gMLC.simplex.status.last_operation,'NULL')
            if VERBOSE > 0, fprintf('gMLC is empty, lets initialize\n'),end
            if VERBOSE > 0, fprintf('\n'),end
            gMLC.step_initialization;
        end

%% Initialization test
    if gMLC.history.cycle(1)<0
      gMLC.history.cycle(2) = gMLC.history.cycle(1)+1;
      fprintf('Lets evaluate the first set!\n')
      gMLC.save;
      return
    end

%% How many cycles of STEP1-STEP2-STEP3 ?
    ncycle = gMLC.history.cycle(1);
    if VERBOSE > 0, fprintf('Cycles to compute : %i\n',max(0,NCYCLE-ncycle)),end
    if VERBOSE > 0, fprintf('\n'),end
    if gMLC.criterion,gMLC.show_status,return,end
    % Last operation
        last_operation = gMLC.simplex.status.last_operation;

    % Interpolation test
    if external_interpolation && strcmp(last_operation,'numerical DS')
      fprintf('Interpolate %i simplex individuals!\n',size(gMLC.simplex.to_build,1))
        return
    end

    % Completion test
    if strcmp(problem_type,'external') && strcmp(last_operation,'Send_to_ExE')
        fprintf('Evaluate the individuals\n')
        fprintf('Or complete the evaluation\n')
        return
    end

% TODO : simply the following code by removing the external things
while not(gMLC.criterion)
%     gMLC.new_cycle(1)
%% Evolution step : Evolution
    gMLC.new_cycle(1)
    gMLC.step_evolution;
    gMLC.step_end;
    gMLC.new_cycle(2);
    
%% Exploration step : Downhill simplex 
    NDSIndividuals = gMLC.table.number + gMLC.parameters.NOffsprings;
    while gMLC.table.number<NDSIndividuals
    gMLC.new_cycle(1)
    gMLC.step_exploitation;
    gMLC.step_end;
    gMLC.new_cycle(2);
    end

% %% Ending step : Stop?
%     gMLC.step_end;
%     gMLC.new_cycle(2);

%% External exit
    if strcmp(problem_type,'external')
        return
    end
end

%% Show
    gMLC.show_status;
    gMLC.show(0);
end %method
