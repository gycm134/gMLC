function save(gMLC)
% gMLC class save method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    Name = gMLC.parameters.Name;
    gMLC.parameters.LastSave = [gMLC.parameters.LastSave;date];
    
%% Folders
    % create them
    create_folders(Name);
    
%% Save
    direc = ['save_runs/',Name];
    save([direc,'/gMLC.mat'],'gMLC')

end %method
