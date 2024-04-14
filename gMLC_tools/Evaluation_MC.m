function Evaluation_MC(gMLC_name)
% Function to evaluate the MC individuals.
% This function should be modified for your own real or numerical experiment.
%
% Guy Y. Cornejo Maceda, 14/04/2024


% Copyright: 2024 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Initialization
Initialization;
gmlc=gMLC;
gmlc.load(gMLC_name);

%% Load the control laws
ControlLaws = load(fullfile('save_runs',gMLC_name,'Sets','Set0_MonteCarlo.mat'));
ControlLaws = ControlLaws.Set;

%% Evaluate the control laws - To be modified following ones case
for p=1:size(ControlLaws,1)
    ExternalFunctionTest_problem(ControlLaws(p,2),gmlc.parameters,ControlLaws{p,1},'',0);
    disp(ControlLaws{p,1})
end