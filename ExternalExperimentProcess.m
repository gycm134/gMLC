% External process for experiments and workstation evaluations.
% This script uses the test functions in Plant/ExternalFunctionTest/
% For your own external problem, use the parameters as described in the
% parameter file ExternalFunctionTest_parameters.m.
% Choose the PathExt parameter carefully to assure a good connection with
% your experiment.
% PathExt points a folder where the results of the experiment are stored.
% Incorporate your experiment and the evaluation of the individuals in
% Evaluation_MC.m, Evaluation_exploration.m and Evaluation_exploitation.m.
% The reconstruction phase is automatically ran in this MATLAB session.
% The reconstruction phase uses parpool if available.
% The optimization parameters in ExternalFunctionTest_parameters.m are
% chosen just for illustrative purposes.
% In case of unexpected interruption of the optimization process use the
% scripts Resume_Exploitation_ExternalExperimentProcess.m and
% Resume_ExternalExperimentProcess.m in gMLC_tools to resume the learning.
% The scripts External_{initialization,exploration,exploitation}_START.m
% use the expe_create_control_select.m function to create a control law
% function to be used in LabView. The control law function is saved in
% save_runs/tmp/.
%
% Guy Y. Cornejo Maceda, 14/04/2024


% Copyright: 2024 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Initialization
Initialization;
mkdir('OUTPUT/costs/') % Example of PathExt for this script. To comment after the first try.

%% Parameters
gMLC_problem = 'ExternalFunctionTest'; % Plant/ExternalFunctionTest/
gMLC_name = 'MyExternalTest_1';

%% INITIALIZATION PHASE
% --- Monte Carlo ---
    External_initialization_START(gMLC_problem,gMLC_name);
    % ~~~~~~~~~~~ EVALUATIONS MC ~~~~~~~~~~~
            Evaluation_MC(gMLC_name);
    % ~~~~~~~~~~~ EVALUATIONS MC ~~~~~~~~~~~
    External_initialization_END(gMLC_name); n=1;

%% EXPLORATION-EXPLOITATION PHASES
while not(exist('STOP_FINISHED','file'))
    % --- EXPLORATION ---
    External_exploration_TEST(gMLC_name);
    if exist('CONTINUE_INTERPOLATION','file') % Not used if the reconstruction is done during this session. It's the general case.
    % ~~~~~~~~~~~ RECONSTRUCTION ~~~~~~~~~~~
            InterpolationProcess; 
    % ~~~~~~~~~~~ RECONSTRUCTION ~~~~~~~~~~~
    end
    External_exploration_START(gMLC_name);
    % ~~~~~~~~~~~ EVALUATIONS ~~~~~~~~~~~
            Evaluation_exploration(gMLC_name,n);
    % ~~~~~~~~~~~ EVALUATIONS ~~~~~~~~~~~
    External_exploration_END(gMLC_name); n=n+1;

    % --- Exploitation ---
    while not(exist('STOP_EXPLOITATION','file'))
        External_exploitation_START(gMLC_name);
        % ~~~~~~~~~~~ EVALUATIONS ~~~~~~~~~~~
%                 Evaluation_exploitation_all(gMLC_name,n); % To save time with parallel simulations
                Evaluation_exploitation(gMLC_name,n);
        % ~~~~~~~~~~~ EVALUATIONS ~~~~~~~~~~~
        External_exploitation_END(gMLC_name); n=n+1;
    end

end

%     delete('STOP_FINISHED')
%     delete('STOP_EXPLOITATION')
%     delete('CONTINUE_INTERPOLATION')

%% Show results
gmlc=gMLC;
gmlc.load(gMLC_name);
gmlc.plot_progress;
gmlc.show;
gmlc.plot(1);