function is_ok = other_test(gMLC_ind,gMLC_parameters)
% gMLCind class other_test method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;

%% Duplicate test
if gMLC_parameters.other_test
      fprintf('other_test')
    % is_ok = false;
  else
    is_ok = true;
end

end %method
