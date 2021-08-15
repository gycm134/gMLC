function complete_EXE(gMLC,optimization_type,matJ)
% gMLC class complete method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    gamma = gMLC.parameters.ProblemParameters.gamma;
    BadValue = gMLC.parameters.BadValue;
    BS = gMLC.parameters.SimplexSize;
    Name = gMLC.parameters.Name;
    ExternalStopEvo = gMLC.parameters.ExternalStopEvo;
    ExternalStopExiEvo = gMLC.parameters.ExternalStopExiEvo;
    ExternalStop = gMLC.parameters.ExternalStop;
    ExternalStopExi = gMLC.parameters.ExternalStopExi;
    % Path
    PathExt = gMLC.parameters.ProblemParameters.PathExt;
    
%% Initialization
    dir_cost = PathExt;
    labels = gMLC.simplex.labels;
    costs = gMLC.simplex.costs;

%% Cycle Test
    cycle = gMLC.history.cycle;
    if cycle(1)==cycle(2)
        fprintf('\nCycle already completed ! \n')
        fprintf('You can go. \n')
        return
    end

%% COMPLETE - Fill the waiting control laws  (Import values)
    % Which control laws
    waiting_labels = gMLC.simplex.waiting_room.labels;
    if nargin<3
        % Import values from cost files
        % Complete the control laws
        for p=1:length(waiting_labels)
            % load
          file_cost = [dir_cost,'ID',num2str(waiting_labels(p)),'.dat'];
          if exist(file_cost,'file')
            J_components = load(file_cost,'-ascii');
            J = [J_components(1)+sum(J_components(2:end).*gamma),J_components];
            J = num2cell(J);
            cost = gMLC.table.individuals(waiting_labels(p)).cost;
            if cost{1}<0,cost={};end
            gMLC.table.individuals(waiting_labels(p)).cost = vertcat(cost,J);
          else
            gMLC.table.individuals(waiting_labels(p)).cost = {BadValue};
          end
        end
    else
        % Complete with matJ values (DSpace experiment)
        % Compute J
        JAll = [matJ(:,1)+sum(gamma.*matJ(:,2:end),2),matJ];
        for p=1:length(waiting_labels)
            cost = gMLC.table.individuals(waiting_labels(p)).cost;
            if cost{1}<0,cost={};end
            gMLC.table.individuals(waiting_labels(p)).cost = vertcat(cost,num2cell(JAll(p,:),[1,size(JAll,2)]));
        end
    end
    % Fill the waiting list
        gMLC.simplex.waiting_room.costs(:) = gMLC.table.costs(waiting_labels);
        
%%%%%%%%%%%%%%%% CONTINUE %%%%%%%%%%%%%%%%%%%
%% Finish optimization types
    % labels and costs
    waiting_labels = gMLC.simplex.waiting_room.labels;
    waiting_costs = gMLC.simplex.waiting_room.costs;

    % update
    switch optimization_type
        case 'Monte Carlo'
            fprintf('\nComplete Monte Carlo\n')
            [~,idx] = sort(waiting_costs);
            new_labels = waiting_labels(idx(1:BS));
            new_costs = waiting_costs(idx(1:BS));
            gMLC.history.add_fact(gMLC.parameters,4,new_labels); % Choose the right number (4 : Monte Carlo)
            
            % initialize the vertices
            vertices = new_labels;
            for p=1:BS
                gMLC.table.individuals(vertices(p)).vertices = vertices(p);
                gMLC.table.individuals(vertices(p)).coefficients = 1;
            end
            gMLC.simplex.status.cycle=gMLC.simplex.status.cycle+1;
            gMLC.history.cycle(1)=gMLC.history.cycle(1)+1;
            
            % evaluation order
            simplexcycle = gMLC.simplex.status.cycle;
            for p=1:numel(waiting_labels)
                gMLC.table.individuals(waiting_labels(p)).evaluation_order = [simplexcycle,waiting_labels(p)];
            end
            evaluated_labels = waiting_labels;
        case 'exploitation'
            fprintf('\nComplete exploitation\n')
            % costs
            Jr = waiting_costs(1); lr = waiting_labels(1);
            Je = waiting_costs(2); le = waiting_labels(2);
            Jc = waiting_costs(3); lc = waiting_labels(3);
            J1 = costs(1);
            Jend_minus_one = costs(end-1);
            Jend = costs(end);

            % evaluation order and table.evaluated
            simplexcycle = gMLC.simplex.status.cycle+1;
            gMLC.table.individuals(lr).evaluation_order = [simplexcycle,1];

            % exploitation
            if Jr >= Jend_minus_one
                if Jc >= Jend
                    % shrink
                    Js = waiting_costs(3+(1:(BS-1))); ls = waiting_labels(3+(1:(BS-1)));
                    lnow = labels(2:end); % useless because overwritten
                    cnow = costs(2:end); % useless becasue overwritten
                    new_labels = zeros(BS,1); new_labels(1) = labels(1);
                    new_costs = zeros(BS,1); new_costs(1) = costs(1);
                    new_labels(2:end) = ls;
                    new_costs(2:end) = Js;
                    fact_type = 14;
                    % evaluation order
                    gMLC.table.individuals(lc).evaluation_order = [simplexcycle,2];
                    for nl=1:numel(ls)
                        gMLC.table.individuals(ls(nl)).evaluation_order = [simplexcycle,2+nl];
                    end
                    evaluated_labels = [lr;lc;ls];
                else
                    % single contraction
                    new_labels = [labels(1:end-1);lc];
                    new_costs = [costs(1:end-1);Jc];
                    fact_type = 12;
                    gMLC.table.individuals(lc).evaluation_order = [simplexcycle,2];
                    evaluated_labels = [lr;lc];
                end
            elseif Jr < J1
                % expansion : best of expand and reflect
                if Jr <= Je
                    new_labels = [labels(1:end-1);lr];
                    new_costs = [costs(1:end-1);Jr];
                else
                    new_labels = [labels(1:end-1);le];
                    new_costs = [costs(1:end-1);Je];
                end
                gMLC.table.individuals(le).evaluation_order = [simplexcycle,2];
                evaluated_labels = [lr;le];
                fact_type = 13;
            else
                % reflection
                new_labels = [labels(1:end-1);lr];
                new_costs = [costs(1:end-1);Jr];
                fact_type = 11;
                if Jr >= Jend_minus_one
                    gMLC.table.individuals(lc).evaluation_order = [simplexcycle,2];
                elseif Jr<J1
                    gMLC.table.individuals(le).evaluation_order = [simplexcycle,2];
                end
                evaluated_labels = lr;
            end
            gMLC.history.add_fact(gMLC.parameters,fact_type,new_labels); % Choose the right number

        case 'evolution'
            fprintf('\nComplete evolution\n')
            % labels and costs
            Jevo = waiting_costs; levo = waiting_labels;
            new_labels = [labels;levo];
            new_costs = [costs;Jevo];
            [~,idx] = sort(new_costs);
            new_labels = new_labels(idx(1:BS));
            new_costs = new_costs(idx(1:BS));
            % history
            fact_type = 6; % evolution
            gMLC.history.add_fact(gMLC.parameters,fact_type,new_labels); % Choose the right number
            % evaluation order
            simplexcycle = gMLC.simplex.status.cycle+1;
            for p=1:numel(waiting_labels)
                gMLC.table.individuals(waiting_labels(p)).evaluation_order = [simplexcycle+0.5,p];
            end
            evaluated_labels = levo;
        otherwise
            error('optimization type not correct')
    end


%% Update simplex (?what about gMLC_simplex.update?)
      % in the simplex
      gMLC.simplex.labels = new_labels;
      gMLC.simplex.costs = new_costs;
      % erase waiting room
      gMLC.simplex.waiting_room.labels = []; % structure : labels, costs
      gMLC.simplex.waiting_room.costs = []; % structure : labels, costs
      % Stat

%% Update properties
      gMLC.simplex.status.evaluated = 'evaluated';
      gMLC.simplex.status.last_operation = 'complete';
      gMLC.simplex.status.individuals_to_evaluate = [];
      gMLC.table.evaluated(evaluated_labels) = 1; % in order to keep at the algorithm

%% Finish 
Nevaluations = sum(gMLC.table.evaluated>0);
% Stop Exploitation
if Nevaluations >= ExternalStopExi
    fclose(fopen(['save_runs/',Name,'/STOPEXI'], 'w'));
    fprintf('Evolution done, lets downhill simplex now\n')
end

% if Nevaluations >= ExternalStopEvo
%     system(['touch save_runs/',Name,'/STOP_GO_EXIEVO']);
%     fprintf('Evolution done, lets combine evolution and exploitation now\n')
% end
% if Nevaluations >= ExternalStopExiEvo
%     system(['touch save_runs/',Name,'/STOP_GO_EXI']);
%     fprintf('Evolution and exploitation done, lets exploitation only now\n')
% end
% External Stop
if Nevaluations >= ExternalStop
    fclose(fopen(['save_runs/',Name,'/STOP'], 'w'));
    fprintf('Exploitation done, its over\n')
end
end %method
