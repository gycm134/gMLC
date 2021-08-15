function [number,gMLC_table]=add(gMLC_table,gMLC_ind,gMLC_parameters)
% gMLC gMLC_table add add
%
% This method adds an individual to the table if it is relevant.
% It evaluates it on the control points in order to have an estimata of it.
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    % VERBOSE = gMLC.parameters.verbose; REMOVE ???
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
          cost = {gMLC_parameters.BadValue};
          % plus other stuff
      end

%% Test
% No test.
% The individual to be added should already been tested begore this method.

%% Addition
  % Where to add
    number = gMLC_table.number+1;

  % Add
    gMLC_table.individuals(number)=gMLC_ind;
    gMLC_ind.ID = number;
    gMLC_table.ControlPoints(number,:)=ControlPoints;
    gMLC_table.evaluated(number) = 0;
    gMLC_table.number = number;
    Mtype = gMLC_ind.description.type;
    if strcmp(Mtype,'substitute') || strcmp(Mtype,'interpolated')
      gMLC_table.isamatrix(number) = 1;
    else
      gMLC_table.isamatrix(number) = 0;
    end
end %add
