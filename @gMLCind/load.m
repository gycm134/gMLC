function load(gMLC_ind,Name_gMLC,Name_ind)
% gMLC class load method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters

    tmp = load(['save_runs/',Name_gMLC,'/Individuals/',Name_ind,'.mat']);

    %% change properties
    prop = properties(gMLC_ind);
    for p=1:length(prop)
        new_prop = get(tmp.gMLC_ind,prop{p});
        set(gMLC_ind,prop{p},new_prop);
    end

%% Update properties
end %method
