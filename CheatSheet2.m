Initialization
Restart
gmlc=gMLC('oscillator'); % /!\ To load a different problem.
% See the plant/oscillator folder for more information on a problem.
gmlc.parameters.Name='My_oscillator';

%% Initial parameters
% Number of intial Monte Carlo individuals. In most cases we start with 100
% random individuals thus:
gmlc.parameters.Number_MonteCarlo_Init = 100; 
% Number of individuals to define the simplex subspace. For the fluidic
% pinball and the cavity experiment we choose the 10 best individuals:
gmlc.parameters.SimplexSize = 10;

%% Strategy
    % Exploitation
% gmlc.parameters.exploitation = 'none';
gmlc.parameters.WeightedMatrix=1; % Yes for acceleration
    % Evolution
gmlc.parameters.evolution = 1;
gmlc.parameters.LandscapeType = 'none';
gmlc.parameters.NOffsprings= 10;

%% Control law paramaters
gmlc.parameters.ControlLaw.InstructionSize.InitMax=50;
gmlc.parameters.ControlLaw.InstructionSize.InitMin=1  ;
gmlc.parameters.ControlLaw.InstructionSize.Max=50;

%% LGPC parameters
gmlc.parameters.PopulationSize = 10;
gmlc.parameters.NumberGenerations = 2;

%% Options and go
gmlc.parameters.save_data = 0;
% gmlc.go(3);
gmlc.parameters.number_of_evaluations = 150;
gmlc.parameters.criterion = 'number of evaluations';
gmlc.go;
gmlc.show;
% gmlc.save;