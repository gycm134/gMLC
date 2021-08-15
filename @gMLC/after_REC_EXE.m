function after_REC_EXE(gMLC)
% gMLC class continue_reflection method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    cycle = gMLC.history.cycle;
    Name = gMLC.parameters.Name;
    simplexcycle = gMLC.simplex.status.cycle;

%% Continue ?
    % waiting costs
    waiting_costs = gMLC.simplex.waiting_room.costs;
    costs = gMLC.simplex.costs;
    % Jr Jc ...
    Jr = waiting_costs(1);
    Jc = waiting_costs(3);
    Jend_minus_one = costs(end-1);
    Jend = costs(end);
    
    % continue
    if (Jr >= Jend_minus_one) && (Jc >= Jend)
            % shrink
            fprintf('Continue with shrink\n')
	    fclose(fopen(['save_runs/',Name,'/ContinueShrink',num2str(simplexcycle+1)], 'w'));
    else
            fprintf('Continue with REC\n')
            gMLC.simplex.waiting_room.labels(4:end)=[];
            gMLC.simplex.waiting_room.costs(4:end)=[];
   end
            
%% Update
    gMLC.simplex.status.last_operation = 'REC';

end %method
