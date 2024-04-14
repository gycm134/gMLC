function External_initialization_START(gMLC_problem,gMLC_name)
% Function to initialize the gMLC process
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Initialization
    Initialization;
    gmlc=gMLC(gMLC_problem);
    gmlc.parameters.Name = gMLC_name;
    gmlc.go;
    
%% Save
    gmlc.save;
