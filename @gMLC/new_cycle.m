function new_cycle(gMLC,N)
% gMLC class new_cycle method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    cycle = gMLC.history.cycle;
    if strcmp(gMLC.parameters.problem_type,'external')
%         cycle=flip(cycle);
        print_type = '%.1f/%i';
    else
        print_type = '%i/%i';
    end
    
    
switch N
  case 1
  % Begin cycle
  if VERBOSE > 0
      cycle(1)=cycle(1)+1;
      fprintf(['----------- Cycle ',print_type,' ----------------\n'],cycle)
  end

  case 2
  % End cycle
    if VERBOSE > 0
      fprintf(['--------- End cycle ',print_type,' --------------\n'],cycle)
      fprintf('\n')
    end

  otherwise
    fprintf(['--------- Cycle ',print_type,' error --------------\n'],cycle)
    fprintf('\n')
end

end %method
