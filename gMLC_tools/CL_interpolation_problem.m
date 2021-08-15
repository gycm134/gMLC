function  J_out = CL_interpolation_problem(b_cell,parameters,visu)
%% Objective
% new objective - interpolate the given control law
% objective = load('Plant/CL_interpolation/centroid.dat');
objective = parameters.to_build;

%% Problem parameters
    if nargin < 3, visu = 0;end
    PHI = parameters.PHI;
    to_round = parameters.ProblemParameters.RoundEval;
    N = parameters.ProblemParameters.OutputNumber;
    EvalTimeSample = parameters.ControlLaw.EvalTimeSample;
    ControlPoints = parameters.ControlLaw.ControlPoints;
    evap = vertcat(EvalTimeSample,ControlPoints);
      P = size(evap,2);

try
for n=1:N
    bx = b_cell{n};
        % definition
    eval(['bf = @(T,s)(' bx ');']);
    for p=1:P
        values(n,p) = round(bf(evap(1,p),evap(2:end,p)),to_round);
    end
end
% reshape
values = reshape(values,1,[]);

catch err
    J_out = {parameters.BadValue,parameters.BadValue,parameters.BadValue};
    fprintf(err.message);
    fprintf('\n');
    return
end

%% Cost function
NObj = norm(objective);
if NObj~=0
    NVO=norm(values-objective).^2/NObj;
    J_out = {NVO,NVO,0};
else
    NVO=norm(values-objective).^2;
    J_out = {NVO,NVO,0};
end
% J_out
end
