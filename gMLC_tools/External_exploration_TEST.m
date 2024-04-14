function External_exploration_TEST(gMLC_name)
% Function to test if they are individuals to reconstruct
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Initialization
    Initialization;
    gmlc=gMLC;
    gmlc.load(gMLC_name);

%% Which individuals are in the basket! 
    gmlc.build_evolution_set; % unless external in this case load
    
%% Save
    gmlc.save;
