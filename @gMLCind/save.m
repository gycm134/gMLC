function save(gMLC_ind,Name_gMLC,Name_ind)
% gMLC class save method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters

%% Save
    direc = ['save_runs/',Name_gMLC,'/Individuals'];
    if not(exist(direc,'dir'))
      mkdir(direc)
    end
    save([direc,'/',Name_ind,'.mat'],'gMLC_ind')

end %method
