function show_problem(gMLC)
% gMLC class show_problem method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Initialization
param = gMLC.parameters;

%% Borders
fprintf('====================== gMLC v%s ====================',gMLC.version)
% Plot
fprintf(['Name : ',param.Name,'\n'])
fprintf('\n')
fprintf(['Problem to solve : ',param.problem,'\n'])
fprintf(['   Number of actuators : ',num2str(param.ProblemParameters.OutputNumber),'\n'])
fprintf(['   Number of sensors : ',num2str(param.ProblemParameters.InputNumber),'\n'])
fprintf('\n')
fprintf('Parameters : \n')
fprintf([' Basket size : ',num2str(param.SimplexSize),'\n'])
fprintf([' Initial Monte Carlo size : ',num2str(param.Number_MonteCarlo_Init),'\n'])
fprintf([' Stopping criterion : ',param.criterion])
if strcmp(param.criterion,'number of evaluations')
    fprintf([' (',num2str(param.number_of_evaluations),')\n'])
    fprintf('  o Number of evaluations so far: %i\n',sum(gMLC.table.evaluated==1))
end
fprintf('\n')
fprintf('\n')
fprintf('Strategy : \n')
fprintf([' Initialialization : ',param.initialization,'\n'])
fprintf([' Exploitation : ',param.exploitation,'\n'])
fprintf([' Evolution : ',num2str(param.evolution),'\n'])
% Plot
fprintf('\n')
gMLC.show(0);

% To continue
fprintf('\n')
disp('To launch the optimization process : gmlc.go;')
%% Borders
disp('======================================================')
end %method
