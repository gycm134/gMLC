function interp_control_law = interp_cl(control_laws,coefficients)
% INTERP_CL interpolates the control laws folowwing the coefficients
%   Detailed explanation goes here
% After this use limit_to function

%% Parameters
Nc = size(control_laws,1);

%% Initialisation
interp_control_law = cell(Nc,1);
for p=1:Nc
	interp_control_law{p}=[num2str(coefficients(1)),'*',control_laws{p,1}];
end

%% Loop
for p=1:Nc
for q=2:size(control_laws,2)
	icl = interp_control_law{p};
	interp_control_law{p}=[icl,'+(',num2str(coefficients(q)),'*',control_laws{p,q},')'];
end
end

end

