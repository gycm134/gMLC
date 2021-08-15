function parameters = oscillator_parameters()
	% oscillator_parameters sets the parameters for the oscillator problem.
    % The goal being to bring a Landau oscillator to its fixed point (0,0).
	%
	% Guy Y. Cornejo Maceda, 09/14/2020
	%
	% See also default_parameters.

	% Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
	% CC-BY-SA

%% Options and problem
    parameters.Name = 'oscillator';
    parameters.verbose = 5;
    parameters.save_data = 0;
    % Problem
    parameters.problem = 'oscillator';
    parameters.problem_type = 'internal'; % 'external'
    parameters.external_interpolation = 0;% Compute the secondary MLC problem outside the original session

%% gMLC parameters
    parameters.Number_MonteCarlo_Init = 100;
    parameters.SimplexSize = 10;
    % parameters.criterion = 'find better than'; % not yet
      parameters.criterion = 'number of evaluations'; %Other option 'number of cycles'
      parameters.number_of_evaluations = 15; % MOD - stopping criterion
    % other parameters
    parameters.BadValue = 10^36;
    parameters.BadValue_plot = 10^3;
    % types of steps
      % initialization
      parameters.initialization = 'Monte Carlo'; % Downhill Simplex(not coded yet)
      parameters.InitializationClustering = 0; %
      % exploitation
    parameters.exploitation = 'Downhill Simplex';
    parameters.WeightedMatrix = 1; % 0:GPC interpolation, 1:coefficient interpolation
      % evolution
    parameters.evolution = 1;
    parameters.NOffsprings = 50;
      % landscape description
    parameters.LandscapeType = 'none'; % 'CostSection','ClusteringDistance', 'ClusteringCorrelation', 'none'
    % individuals tests
    parameters.duplicate_test = 1; % TO BE DONE FOR STOCK
    parameters.other_test = 0;
    % centroid
    parameters.to_build = [];
    % explore the initial controller
    parameters.explo_IC=1;

%% Problem parameters
        % Problem variables
        % The inputs and outputs are considered from the controller point
        % of view. Thus ouputs are the controllers (plasma, jets) and
        % inputs are sensors and time dependent functions.
        % Intputs - Number of sensors and time dependent functions
            % si(t)
            ProblemParameters.NumberSensors = 2;
            ProblemParameters.Sensors = cell(1,ProblemParameters.NumberSensors);
                ProblemParameters.Sensors = {'a1','a2'}; % name in the problem
            % hi(t)
            ProblemParameters.NumberTimeDependentFunctions = 0;
            ProblemParameters.TimeDependentFunctions = {}; % syntax in MATLAB/Octave
%             ProblemParameters.TimeDependentFunctions{2,:} = {}; % syntax in the problem (if null then comment)
            ProblemParameters.InputNumber = ProblemParameters.NumberSensors+ProblemParameters.NumberTimeDependentFunctions; 
        % Outputs
        ProblemParameters.OutputNumber = 1; % Number of OutputNumber
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
        ProblemParameters.TmaxEv = 20; % otherwise bad
        % Problem definition
        ProblemParameters.NPointsPeriod = 51; % Number of points per period
        ProblemParameters.NPeriods = 25; % Number of periods
        ProblemParameters.T0 = 0; % Not always used
        ProblemParameters.Tmax = 2*pi*ProblemParameters.NPeriods; % omega=1
            time = linspace(ProblemParameters.T0,ProblemParameters.Tmax,...
                ProblemParameters.NPointsPeriod*ProblemParameters.NPeriods+1);
        ProblemParameters.dt = time(2)-time(1);
        ProblemParameters.InitialCondition = [sqrt(1) 0]; % on the limit cycle of the unstable oscillator.
        % Actuation limitation : [lower bound,upper bound]
        ProblemParameters.ActuationLimit = [-1.5,1.5];
        % Cost function penalization
        ProblemParameters.gamma = 0;% MOD : such as Ja+ gamma(1)*Jb+gamma(2)*Jc + ... % This needs to be consistent with the associated *_problem.m file
        
        % Round evaluation of control points and J
        ProblemParameters.RoundEval = 6;
        % Costs
        ProblemParameters.J0 = 1; % User defined
        ProblemParameters.Jmin = 0;
        ProblemParameters.Jmax = inf; 
        % Estimate performance
        ProblemParameters.EstimatePerformance = 'mean'; % default 'mean', if drift 'last', 'worst', 'best'
        % Cost path for external evaluations
        ProblemParameters.PathExt = '/Costs'; % useless if "internal" type of problem
        
    % Definition
    parameters.ProblemParameters = ProblemParameters; %*

%% Control law parameters
        % Number of instructions
        ControlLaw.InstructionSize.InitMax=50;
        ControlLaw.InstructionSize.InitMin=1;
        ControlLaw.InstructionSize.Max=50;
        % Operators
        ControlLaw.OperatorIndices = 1:9;
            %   implemented:     - 1  addition       (+)
            %                    - 2  substraction   (-)
            %                    - 3  multiplication (*)
            %                    - 4  division       (%)
            %                    - 5  sinus         (sin)
            %                    - 6  cosinus       (cos)
            %                    - 7  logarithm     (log)
            %                    - 8  exp           (exp)
            %                    - 9  tanh          (tanh)
            %                    - 10 square        (.^2)
            %                    - 11 modulo        (mod)
            %                    - 12 power         (pow)
            %
        ControlLaw.Precision = 6; % Precision of the evaluation of the control law % to change also in my_div and my_log
        
        % Registers
            % Number of variable registers
            VarRegNumberMinimum = ProblemParameters.OutputNumber+ProblemParameters.InputNumber; %*
            ControlLaw.VarRegNumber = VarRegNumberMinimum + 3; % add some memory slots if needed  
            % Number of constant registers
            ControlLaw.CstRegNumber = 4;
            ControlLaw.CstRange = repmat([-1,1],ControlLaw.CstRegNumber,1);% Range of values of the random constants 
            % Total number of registers
            ControlLaw.RegNumber = ControlLaw.VarRegNumber + ControlLaw.CstRegNumber;  %* % variable registers and constante registers (operands)
            
            % Register initialization
                NVR = ControlLaw.VarRegNumber; %*
                RN = ControlLaw.RegNumber; %*
                r{RN}='0'; %*
                r(:) = {'0'}; %*
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
        ControlLaw.ControlPointNumber = 1000;
        ControlLaw.SensorRange = repmat([-1.5,1.5],ProblemParameters.NumberSensors,1); % min and max position measured
            Nbpts = ControlLaw.ControlPointNumber; %*
            Rmin = min(ControlLaw.SensorRange,[],2); %*
            Rmax = max(ControlLaw.SensorRange,[],2); %*
            dR = Rmax-Rmin; %*
        ControlLaw.EvalTimeSample = rand(1,Nbpts)*ProblemParameters.Tmax; %*
        ControlLaw.ControlPoints = rand(ProblemParameters.NumberSensors,Nbpts).*dR+Rmin; %*
        
    % Definition
    parameters.ControlLaw = ControlLaw; %*

%% MLC parameters
    % Population size and generations
    parameters.PopulationSize = 100;
    parameters.NumberGenerations = 2;
    % Optimization parameters
    parameters.OptiMonteCarlo = 1; % Optimization of the first generation (remove duplicates, redundants..)
    parameters.RemoveBadIndividuals = 0; % Remove indiviuals which evaluation failed
    parameters.RemoveRedundants = 1; % Remove already evaluated individuals
    parameters.CrossGenRemoval = 1; % Remove the individuals if they have already been evaluated in an earlier generation
    parameters.ExploreIC = 0; % Evaluate the initial condition of registers (here:b=0)
    % For remove_duplicates_operators and redundants, maximum number of
    % iterations of the operations when the test is not satisfied.
    parameters.MaxIterations = 100; % better around 100 (-> MaxInterations)
    % Reevaluate individuals (noise and experiment)
    parameters.MultipleEvaluations = 0;
    % Stopping criterion
%     parameters.Criterion = 'number of evaluations'; % (not yet)
    % Selection parameters
    parameters.TournamentSize = 7;
    parameters.p_tour = 1;
    % Selection genetic operator parameters
    parameters.Elitism = 1;
    parameters.CrossoverProb = 0.6;
    parameters.MutationProb = 0.3;
    parameters.ReplicationProb = 0.1;
    % Other genetic parameters
    parameters.MutationType = 'at_least_one';
    parameters.MutationRate = 0.05;
    parameters.CrossoverPoints = 1;
    parameters.CrossoverMix = 1;
    parameters.CrossoverOptions = {'gives2'};
    % Other parameters
    parameters.BadValue = 10^36;
    parameters.Pretesting = 0; % (not yet) remove individuals who have no effective instruction

%% Constants
    parameters.PHI = 1.61803398875;

%% Other parameters
    parameters.LastSave = '';

end
