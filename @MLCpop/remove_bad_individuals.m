function pop = remove_bad_individuals(pop,MLC_parameters,MLC_table,pop_old)
    % REMOVE_BAD_INDIVIDUALS This function remove the bad individuals of a population and creates new
    % individuals to fullfill the population.
    % The new individuals are then evaluated.
    % The function is recursive and stops when the population is free of bad individuals.
    % A bad individual is an individual that failed to be evaluated
    %
    %
    % See also pretesting, find_bad_individuals, clean.

    %   Copyright (C) 2015-2017 Thomas Duriez.
    %   This file is adapted from @MLCpop/remove_bad_indivs.m of the OpenMLC-Matlab-2 Toolbox. Distributed under GPL v3.


%% Find the bad individuals
  idx = find_bad_individuals(pop,MLC_parameters); %logical

%% If there are bad individuals remove/generate/evaluate
  if not(length(idx))
      fprintf('No bad individuals to remove\n')
      return
  end
  fprintf('%i bad individuals to be removed\n',length(idx))
  fprintf('Generating %i new individuals\n',length(idx))
%% Replace bad individuals with new individuals
  pop.replace_individuals(idx,MLC_parameters,MLC_table,pop_old);

%% Clean population (pretesting and stuff)
  if pop.generation==1
      if MLC_parameters.OptiMonteCarlo
          pop.clean(MLC_parameters,MLC_table,pop_old,idx');
      end
  else
      pop.clean(MLC_parameters,MLC_table,pop_old,idx');
  end

%% Evaluate the new individuals
  pop.evaluate_pop(idx,MLC_parameters,MLC_table);

%% Loop
  pop.remove_bad_individuals(MLC_parameters,MLC_table,pop_old);

end
