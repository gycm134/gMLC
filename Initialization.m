% INITIALIZATION script
% Loads all the folders needed.
% Should be executed at the beginning of every run
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

% 
%     <program>  Copyright (C) <year>  <Name of author>
%     This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
%     This is free software, and you are welcome to redistribute it
%     under certain conditions; type `show c' for details.

%% MATLAB random number
    rng('shuffle');
    
%% Add paths
    addpath('gMLC_tools/');
    addpath(genpath('Plant'));
    
    % Additional other tools
    addpath(genpath('Other_tools/'));

%% Show more    
    more off;

%% Information display
    % Header
    fprintf('====================== ')
    fprintf('gMLC v0.1.1')
    fprintf(' ==================\n')
    % Version
    disp(' Welcome to the gMLC software to solve non-convex')
    disp(' regression problems.')
    % Link
        disp(' In case of error please contact the author :')
        X = '  <a href = "https://www.cornejomaceda.com">Guy Y. Cornejo Maceda Website</a>';
        disp(X)
        fprintf('\n')
    % Start
    disp(' Start by creating a gMLC object with : gmlc=gMLC;')
    % Foot
    fprintf('===========================')
    fprintf('==========================\n')
    fprintf('\n')
    
%% Initialiase the gMLC class
%     gmlc=gMLC;
