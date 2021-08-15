function complete_interpolation_EXE(gMLC)
% gMLC class complete_interpolation_EXE method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    cycle = gMLC.history.cycle;
    Name = gMLC.parameters.Name;


%% Labels
    ID1 = gMLC.simplex.labels(1);
    IDend = gMLC.simplex.labels(end);
    IDs = gMLC.simplex.labels(2:end);
    if isempty(gMLC.simplex.to_build)
        return
    end
    labels = gMLC.simplex.to_build(:,1);
    
%% Test
    for p=1:size(gMLC.simplex.to_build,1)
        file_dir = ['save_runs/',Name,'/Individuals/',num2str(labels(p)),'.mat'];
        if not(exist(file_dir,'file'))
            error('All individuals have not been interpolated!\n')
        end
    end

%% Load the individuals and update their status
    for p=1:numel(labels)
        % Load
        Ind = gMLCind;
        Ind.load(Name,num2str(labels(p)));

        % Individual to substitute
        Ind2substitute = gMLC.table.individuals(labels(p));

        % Complete
        Ind.cost = Ind2substitute.cost;
        Ind.description.type = 'substitute';

        % Add to table
        ID = gMLC.table.add(Ind,gMLC.parameters);
        Ind2substitute.description.miscellaneous = ID;
        Ind.vertices = ID;
        Ind.coefficients = 1;
    end
    
%% Update propertiesi
    gMLC.simplex.status.last_operation = 'Subtitute computed';

end %method
