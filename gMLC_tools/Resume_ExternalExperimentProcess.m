% To resume the external experimental process from an exploration phase.
% 
%
% Guy Y. Cornejo Maceda, 14/04/2024


% Copyright: 2024 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters
gMLC_problem = 'ExternalFunctionTest'; % Plant/ExternalFunctionTest/
gMLC_name = 'MyExternalTest_1';

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