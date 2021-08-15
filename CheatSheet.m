% When the matlab session just started, execute the command:
% "Initialization;" to load all the folders and create a gMLC object.

% The Restart.m script creates a new gMLC object with the variable gmlc.
% /!\ The previous object is overwriting.
Restart


%% Name of the object
% This is the name of the gMLC object.
% You can change the name at any point and save the object to have backup
% saves.
% To save see below.
% The default name is defined in the parameter file.
gmlc.parameters.Name='My_tanh_test_1';

%% Initialization
% Number of intial Monte Carlo individuals. In most cases we start with 100
% random individuals thus:
gmlc.parameters.Number_MonteCarlo_Init = 100; 
% Number of individuals to define the simplex subspace. For the fluidic
% pinball and the cavity experiment we choose the 10 best individuals:
gmlc.parameters.SimplexSize = 10;

%% Strategy
    % Evolution
% These are the parameters for the exploration part.
% In this version, the exploration is carried out with genetic programming
% also referred as the evolution step, thus the parameter:
gmlc.parameters.evolution = 1;
% The "LandscapeType" parameter allows to select different ways to select
% the individuals in the database for the evolution.
% When "none" is selected, the new individuals are selected from the whole
% dataset. This is the default setting. Other settings can be tested to
% save some time in the resolution of the secondary problem.
gmlc.parameters.LandscapeType = 'none';
% This parameter gives the number of individuals that are generated at each
% evolution step and exploitation step.
% For quick tests, it should set to 10 and for real optimization it should
% be set to 50. Of course it can be adapted following the problem.
gmlc.parameters.NOffsprings= 10;

    % Exploitation
% The exploitation is carried out thanks to downhill simplex.
gmlc.parameters.exploitation = 'Downhill Simplex';
% The WeightedMatrix option should always be 1.
% When its values is 1, the simplex individuals are completed with an
% interpolation of the individuals, but the resulting individual does not
% have a matrix representation. To accelerate the learning we set the value
% at 1 and we compute the matrix representation afterwards for the
% individuals that are needed only.
gmlc.parameters.WeightedMatrix=1; % Yes for acceleration  

%% Control law paramaters
% Those parameters define the size of the matrices in the matrix
% representation.
% For single controllers problem, it should be law, around 20 but for
% numerous controllers it can set to 50 (for ~3-4 controllers) or 100 for
% 10 controllers. This value can be discussed following the problem.
gmlc.parameters.ControlLaw.InstructionSize.InitMax=20;
gmlc.parameters.ControlLaw.InstructionSize.InitMin=1; % Should be 1
gmlc.parameters.ControlLaw.InstructionSize.Max=20; % Should be the same as InitMax

%% LGPC parameters
% This parameters are for the resolution of the secondary problem.
% For quick tests, they should be set to: PopulationSize = 10 and
% NumberGenerations = 2.
% For real optimizations, typical values are PopulationSize = 100 and
% NumberGenerations = 10 for all kind of problems.
% This values can be modified if necessary.
gmlc.parameters.PopulationSize = 10;
gmlc.parameters.NumberGenerations = 2;

%% Options and go
% This options allows to save time series of the state variables for the 
% dynamical systems such as the toy_problem and the oscillator.
% It may be create a lot of files so it is not advised unless it is
% required.
% The data is saved in save_runs/name, where name is the name of the
% object.
% The name can be retrieved thanks to the command gmlc.parameters.Name;
gmlc.parameters.save_data = 0;


% This option sets the stopping criterion for the optimization
gmlc.parameters.criterion = 'number of evaluations';
% This option sets the total number of evaluations.
% The optimization stops after the exploitation phase if enough
% individiuals are evaluated.
% For quick tests, 150 or 200 is OK.
% For real optimizations, it depends of the problem. Could be 500 or 1000
% for example.
gmlc.parameters.number_of_evaluations = 150;

% This is the command to run the optimization.
% Once the opitimization starts, a lot of text will appear on the screeen
% and one need to wait the end of the optimization.
gmlc.go;

%% Save and continue.
% To save an optimization process:
gmlc.save;
% A folder is created in save_runs with the name of the problem and
% containing a gMLC.mat file.
% Once the object is saved, one can close matlab
% Then if we want to continue the optimization later, then first start
% matlab, execute "Initialization.m" and load the gMLC object with its name;
gmlc.load('My_tanh_test_1');
% The increase the number of evaluations, for example:
gmlc.parameters.number_of_evaluations = 175;
% And resume the optimization;
gmlc.go;
% Don't forget to save when the optimization is done.

%% Post processing commands
% The two mains post processing commands are:
gmlc.show;
% That gives the best individual and a plot.
% The plot is defined in the *_problem.m file associated to the problem.

gmlc.plot_progress;
% gives the distribution of the evaluated individuals.

% To have more information on a give individual check its "ID" in the plot
% generated with plot_progress.
% The ID is the Z component of each dot.
% Then one can access to all its data with the command:
gmlc.table.individuals(23)
% You can find its cost, the control law, etc ...



