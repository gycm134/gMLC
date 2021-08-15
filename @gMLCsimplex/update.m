function [new_labels,gMLC_simplex]=update(gMLC_simplex,gMLC_table,gMLC_parameters)
% gMLCsimplex class update method
% Updates the simplex with the individuals (labels and costs) in the
% waiting_room.
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    BS = gMLC_parameters.SimplexSize;
    problem_type = gMLC_parameters.problem_type;

if VERBOSE > 6, fprintf('     Update simplex - Start\n'),end

%% Labels
    labels = gMLC_simplex.labels;
    costs = gMLC_simplex.costs;
    waiting_labels = gMLC_simplex.waiting_room.labels;
    waiting_costs = gMLC_simplex.waiting_room.costs;

%% External
    if strcmp(problem_type,'external')
      gMLC_simplex.status.last_operation = 'external';
    end

    %% Switch
    last_operation = gMLC_simplex.status.last_operation;
    switch last_operation
        case 'reflect' % check the number of individuals
            wlabel= waiting_labels(1);
            wcost= waiting_costs(1);
            STCP1 = strcmp(gMLC_table.individuals(wlabel(1)).description.subtype,'reflected');
            if STCP1
                [~,idx] = min(wcost);
                new_labels = [labels(1:end-1);wlabel(idx)];
                new_costs = [costs(1:end-1);wcost(idx)];
            else
                error('Error type in the waiting room - reflect\n')
            end
        case 'expand' % check the number of individuals
            wlabel = waiting_labels(1:2);
            wcost = waiting_costs(1:2);
            STCP1 = strcmp(gMLC_table.individuals(wlabel(1)).description.subtype,'reflected');
            STCP2 = strcmp(gMLC_table.individuals(wlabel(2)).description.subtype,'expanded');
            if STCP1 && STCP2
                if wcost(2)<wcost(1) % Je<Jr
                    idx = 2;
                else
                    idx = 1;
                end
                new_labels = [labels(1:end-1);wlabel(idx)];
                new_costs = [costs(1:end-1);wcost(idx)];
            else
                error('Error type in the waiting room - expand\n')
            end
        case 'single contraction' % check the number of individuals
            wlabel= waiting_labels(2);
            wcost = waiting_costs(2);
            if strcmp(gMLC_table.individuals(wlabel).description.subtype,'contracted')
                new_labels = [labels(1:end-1);wlabel];
                new_costs = [costs(1:end-1);wcost];
            else
                error('Error type in the waiting room - single contraction\n')
            end
        case 'shrink' % check the number of individuals
            wlabel= waiting_labels((3:end));
            wcost= waiting_costs((3:end));
            STCP = true;
            for p=1:length(wlabel)
                STCP = STCP && strcmp(gMLC_table.individuals(wlabel(p)).description.subtype,'shrinked');
            end
            if STCP
                % take the best of shrink : problem we can get stuck in the
                % algorithm
%                 lnow = labels(2:end);
%                 cnow = costs(2:end);
%                 new_labels = zeros(BS,1); new_labels(1) = labels(1);
%                 new_costs = zeros(BS,1); new_costs(1) = costs(1);
%                 for p=1:length(wlabel)
%                     l2 = [lnow(p),wlabel(p)];
%                     c2 = [cnow(p),wcost(p)];
%                     [~,bc]=min(c2);
%                     new_labels(p+1) = l2(bc);
%                     new_costs(p+1) = c2(bc);
%                 end
                % true shrink
                  new_labels = [labels(1);wlabel];
                  new_costs = [costs(1);wcost];
            else
                error('Error type in the waiting room - shrink\n')
            end
        case {'Random addition'}
            wlabel= waiting_labels;
            wcost= waiting_costs;
            STCP = true;
            for p=1:length(wlabel)
                STCP = STCP && sum(strcmp(gMLC_table.individuals(wlabel(p)).description.type,{'Random'}));
            end
            if STCP
                new_labels = [labels;wlabel];
                new_costs = [costs;wcost];
                [~,idx] = sort(new_costs);
                new_labels = new_labels(idx(1:BS));
                new_costs = new_costs(idx(1:BS));
            else
                error('Error type in the waiting room - Random addition\n')
            end

        case {'no exploitation'}
            new_labels = labels;
            new_costs = costs;
        case 'external'
            new_labels = NaN;
            return
        case 'evolution'
            wlabel = waiting_labels;
            wcost = waiting_costs;
            for p=1:length(wlabel)
                if not(strcmp(gMLC_table.individuals(wlabel(p)).description.type,{'evolved'}))
                    error('Error type in the waiting room - evolution\n')
                end
            end
            wlabel = [labels;wlabel];
            wcost = [costs;wcost];
            [~,IDX_labels] = sort(wcost);
            new_labels = wlabel(IDX_labels(1:BS));
            new_costs = wcost(IDX_labels(1:BS));
        case 'importation'
            if gMLC_table.number<BS
                error('Not enough individuals, lower simplex size')
            end
            AllLabels = transpose(1:gMLC_table.number);
            ImportedLabels = AllLabels(gMLC_table.evaluated>0);
            costs = gMLC_table.costs(ImportedLabels);
            [~,idx] = sort(costs);
            % new
            new_labels = ImportedLabels(idx(1:BS));
            new_costs = costs(idx(1:BS));
        otherwise
            error('No Downhill simplex step performed')

    end

%% Update properties
    % Individuals informations
        if length(new_labels)==BS% TEST NUMBER OF ELEMENTS
            gMLC_simplex.labels = new_labels;
            gMLC_simplex.costs = new_costs;
        else
            fprintf('Error number of elements in the new individuals\n')
            return
        end

        gMLC_simplex.waiting_room.labels = []; % structure : labels, costs
        gMLC_simplex.waiting_room.costs = []; % structure : labels, costs
    % Centroid
%         gMLC_simplex.centroid = NaN*gMLC_simplex.centroid;
    % Stat
        gMLC_simplex.status.evaluated = 'updated';
        gMLC_simplex.status.individuals_to_evaluate = [];


if VERBOSE > 6, fprintf('     Update simplex - End\n'),end

end %method
