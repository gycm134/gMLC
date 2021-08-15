function parameters = tanhfitting_parameters()
	% Default parameters for the toy problem.
    % The toy problem is tanh function fitting.
	%
	% Guy Y. Cornejo Maceda, 09/14/2020
	%
	% See also default_parameters.

	% Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
	% CC-BY-SA
    
    %% Options and problem
      parameters.Name = 'TanhFitting'; % MOD
      parameters.verbose = 5;
      parameters.save_data = 0;
      % Problem
      parameters.problem = 'tanhfitting'; % MOD - /!\ Name of the problem. This name relates to the file "toy_problem.m" in the plant/toy_problem folder.
      parameters.problem_type = 'internal'; % "internal" for evaluation of the individuals in the same matlab session; 'external' for experiment or coupling with a solver.
      parameters.external_interpolation = 0;% Compute the secondary MLC problem outside the original session

%% gMLC parameters
    parameters.Number_MonteCarlo_Init = 100; % MOD
    parameters.SimplexSize = 10; % MOD
    % parameters.criterion = 'find better than'; % not yet
    parameters.criterion = 'number of evaluations'; %Other option 'number of cycles'
    parameters.number_of_evaluations = 15; % MOD - stopping criterion
    % other parameters
    parameters.BadValue = 10^36;
    parameters.BadValue_plot = 10^3;
    % types of steps
      % initialization
    parameters.initialization = 'Monte Carlo'; % 'Monte Carlo' only option so far
    parameters.InitializationClustering = 0; %
      % exploitation
    parameters.exploitation = 'Downhill Simplex';
    parameters.WeightedMatrix = 1; % 0:GPC interpolation, 1:coefficient interpolation
      % evolution
    parameters.evolution = 0;
    parameters.NOffsprings = 10;
      % landscape description
    parameters.LandscapeType = 'none'; % 'CostSection','ClusteringDistance', 'ClusteringCorrelation', 'none'
    % individuals tests
    parameters.duplicate_test = 1; %
    parameters.other_test = 0;
    % centroid
    parameters.to_build = [];
    % explore the initial controller (generally b=0)
    parameters.explo_IC=1;

  %% Problem parameters
        % Problem variables
        % The inputs and outputs are considered from the controller point
        % of view. Thus ouputs are the controllers (plasma, jets) and
        % inputs are sensors and time dependent functions.
          % Inputs
            % si(t)   
            ProblemParameters.NumberSensors = 0;
            ProblemParameters.Sensors = {}; % name in the problem
            % hi(t)
            ProblemParameters.NumberTimeDependentFunctions = 1; % Periodic functions only for now
            ProblemParameters.TimeDependentFunctions(1,1) = {'T'}; % syntax in MATLAB/Octave
            ProblemParameters.TimeDependentFunctions(2,1) = {'T'}; % syntax in the problem (if null then comment)
            ProblemParameters.InputNumber = ProblemParameters.NumberSensors+ProblemParameters.NumberTimeDependentFunctions; 
            % Fi = 135*[1.618^(-2),1.618^(-1),1.618,1.618^2]; % Add the required frequencies
          % Outputs
            ProblemParameters.OutputNumber = 1; % Number outputs
            ProblemParameters.UnsteadyOutputs = 1;
            ProblemParameters.SteadyOutputs  = 0; % T=0 in the evaluation of the controller
              if ProblemParameters.UnsteadyOutputs+ProblemParameters.SteadyOutputs~=ProblemParameters.OutputNumber
                error('Number of outputs is not well defined')
              end
          % Control Syntax
            Sensors = cell(1,ProblemParameters.NumberSensors); %*
            TDF = cell(1,ProblemParameters.NumberTimeDependentFunctions); %*
            for p=1:ProblemParameters.NumberSensors,Sensors{p} = ['s(',num2str(p),')'];end %*
            for p=1:ProblemParameters.NumberTimeDependentFunctions,TDF{p} = ['h(',num2str(p),')'];end %*
            ControlSyntax = horzcat(Sensors,TDF); %*


        % Evaluation - Put everything that is needed in the *_problem.m file.
        % Maximum evaluation time otherwise returns an bad value
        ProblemParameters.TmaxEv = 5;
        % Problem definition
        ProblemParameters.T0 = -2; % Care control points
        ProblemParameters.Tmax = 2;
        ProblemParameters.dt = 1e-4;    
        % Different initial conditions
        ProblemParameters.InitialCondition = 1;
        % Actuation limitation : [lower bound,upper bound]
        ProblemParameters.ActuationLimit = [-inf,inf];
        % Cost function penalization
        ProblemParameters.gamma = 1;% MOD : such as Ja+ gamma(1)*Jb+gamma(2)*Jc + ... % This needs to be consistent with the associated *_problem.m file
        
        % Round evaluation of control points and J
        ProblemParameters.RoundEval = 6; % The cost function is rounded to the 6th digit
        % Costs
        ProblemParameters.J0 = 1; % User defined
        ProblemParameters.Jmin = 0;
        ProblemParameters.Jmax = inf;
        % Estimate performance
        ProblemParameters.EstimatePerformance = 'mean'; % default 'mean', if drift 'last', 'worst', 'best'
        % Cost path for external evaluations
        ProblemParameters.PathExt = '/Costs'; % useless if "internal" type of problem

    % Definition
    parameters.ProblemParameters = ProblemParameters;
      
  %% Control law parameters % MOD with Guy
  		% Number of instructions
  		ControlLaw.InstructionSize.InitMax=50;
  		ControlLaw.InstructionSize.InitMin=1;
  		ControlLaw.InstructionSize.Max=50;
  		% Operators
  		ControlLaw.OperatorIndices = [1:9];% MOD
  			%   implemented:     - 1  addition       (+)
  			%                    - 2  substraction   (-)
  			%                    - 3  multiplication (*)
  			%                    - 4  division       (%)
  			%                    - 5  sinus         (sin)
  			%                    - 6  cosinus       (cos)
  			%                    - 7  logarithm     (log)
  			%                    - 8  exp           (exp)
  			%                    - 9  tanh          (tanh)
  			%                    - 10 square        (.^2) % Not yet
  			%                    - 11 modulo        (mod) % Not yet
  			%                    - 12 power         (pow) % Not yet
  			%
  		ControlLaw.Precision = 6; % The actuation is rouded at the 6th digit.
        
  		% Registers      
        % Number of variable registers
            VarRegNumberMinimum = ProblemParameters.OutputNumber+ProblemParameters.InputNumber; %*
            ControlLaw.VarRegNumber = VarRegNumberMinimum + 3; % add some memory slots if needed  
        % Number of constants registers
            ControlLaw.CstRegNumber = 4;
            ControlLaw.CstRange = [repmat([-1,1],ControlLaw.CstRegNumber,1)]; % Range of values of the random constants
        % Total number ofregisters
            ControlLaw.RegNumber = ControlLaw.VarRegNumber + ControlLaw.CstRegNumber;  %* % variable.ControlLaw.Registers and constante.ControlLaw.Registers (operands)

  		% Register initialization
  			NVR = ControlLaw.VarRegNumber;%*
  			RN = ControlLaw.RegNumber;%*
            r{RN}='0';%*
            r(:)={'0'};%*
            % Variable registers
                for p=1:ProblemParameters.InputNumber %*
                    r{p+ProblemParameters.OutputNumber} = ControlSyntax{p}; %*
                end
            % Constant registers
                minC = min(ControlLaw.CstRange,[],2); %*
                maxC = max(ControlLaw.CstRange,[],2); %*
                dC = maxC-minC; %*
                for p=NVR+1:RN %*
                    r{p} = num2str(dC(p-NVR)*rand+minC(p-NVR)); %*
                end %*
            ControlLaw.Registers = r; %*

        % Control law estimation
  		ControlLaw.ControlPointNumber = 1000;%* new Name
  		ControlLaw.SensorRange = [-2,2];%*
  		    Nbpts = ControlLaw.ControlPointNumber;%*
  		    Rmin = min(ControlLaw.SensorRange,[],2);%*
  		    Rmax = max(ControlLaw.SensorRange,[],2);%*
  		    Rmean = mean([Rmin,Rmax]);%*
  		    dR = abs(Rmean-Rmin);%*
  		ControlLaw.EvalTimeSample = rand(1,Nbpts)*(ProblemParameters.Tmax-ProblemParameters.T0)+ProblemParameters.T0;
  		ControlLaw.ControlPoints = 2*rand(ProblemParameters.InputNumber,Nbpts)*dR+Rmin;%*
    
    % Definition
    parameters.ControlLaw = ControlLaw; %*
  	%% LGPC parameters
  		parameters.PopulationSize = 10;
  		parameters.NumberGenerations = 2;
  		parameters.EvaluationFunction = parameters.problem;
  		% optimization parameters
  		parameters.OptiMonteCarlo = 1; %optimization of the first generation (remove duplicates, redundants..)
  		parameters.RemoveBadIndividuals = 1;
  		parameters.RemoveRedundants = 1; % create always new individuals compared to (CrossGenRemoval=0) the last generation, (CrossGenRemoval=1) the whole data base
  		parameters.CrossGenRemoval = 1;
  		parameters.ExploreIC = 0; % For gMLC, should be 0
  		parameters.MaxIterations = 100; % for remove_duplicates_operators and redundants, max number of iterations of the operations when we don't satisfy the test.
  		% multiple evaluations
  		parameters.MultipleEvaluations = 0;
  		% Selection parameters
  		parameters.TournamentSize = 7;
  		parameters.p_tour = 1;
  		% Selection genetic operator parameters
  		parameters.Elitism = 1;
        parameters.CrossoverProb = 0.6;
        parameters.MutationProb = 0.3;
        parameters.ReplicationProb = 0.1;
%         parameters.GeneticProbabilities = [0.60,0.30];
  		% Other genetic parameters
  		parameters.MutationType = 'at_least_one';
  		parameters.MutationRate = 0.05;
  		parameters.CrossoverPoints = 1;
  		parameters.CrossoverMix = 1;
  		parameters.CrossoverOptions = {'gives2'};
        % Other parameters
  		parameters.Pretesting = 0; %remove individuals who have no effective instruction or other tests

  	%% Constants
  		parameters.PHI = 1.61803398875;

  	%% Other parameters
  		parameters.LastSave = '';
end
