function gMLC=load(gMLC,Name)
% gMLC class load method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;

    tmp = load(['save_runs/',Name,'/gMLC.mat']);

    % gMLC.population = l.gMLCsave.population;
    % gMLC.parameters = l.gMLCsave.parameters;
    % gMLC.table = l.gMLCsave.table;
    % gMLC.generation = l.gMLCsave.generation;

    %% change properties
    prop = properties(gMLC);
    for p=1:length(prop)
        new_prop = get(tmp.gMLC,prop{p});
        set(gMLC,prop{p},new_prop);
    end

%% Update properties

end %method
