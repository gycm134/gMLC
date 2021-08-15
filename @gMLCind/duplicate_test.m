function is_ok = duplicate_test(gMLC_ind,gMLC_table,gMLC_parameters)
% gMLCind class duplicate_test method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    number = gMLC_table.number;
    round_eval = gMLC_parameters.ProblemParameters.RoundEval;

%% Already generated
    CPs = gMLC_table.ControlPoints(1:number,:);

%% Control law
    controllaw = gMLC_ind.control_law;

%% Estimate - numerical equivalency
    % evaluation
      controllaw = strrep_cl(gMLC_parameters,controllaw,1);
        evaluation_time = gMLC_parameters.ControlLaw.EvalTimeSample;
        control_points = gMLC_parameters.ControlLaw.ControlPoints;
        evap = vertcat(evaluation_time,control_points);
      actuation_limit = gMLC_parameters.ProblemParameters.ActuationLimit;
      to_round = gMLC_parameters.ProblemParameters.RoundEval;
      values = eval_controller_points(controllaw,evap,actuation_limit,to_round);      
    % reshape
      ControlPoints = reshape(values,1,[]);
    % Pretesting
      NAN = logical(sum(isnan(ControlPoints)));
      INF = logical(sum(isinf(ControlPoints)));
      if NAN||INF
          is_ok = false;
          return
      end

%% Compare control law and CPs
    comparaison = abs(CPs-ControlPoints)<10^(-round_eval);
    comp = prod(comparaison,2);
    is_ok = ~logical(sum(comp));

end %method
