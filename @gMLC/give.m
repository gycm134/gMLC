function give(gMLC,IDs)
% gMLC class give method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;

%% Print individuals
    for g=1:length(IDs)
      ID=IDs(g);
      
      ind =ID;
      fprintf('%i-th Individual of the database:\n',ID)
      individual = gMLC.table.individuals(ind);
      give_print(individual);
    end %for gen

end %method

function give_print(individual,IND)
  fprintf('   cost: %f\n',individual.cost{1})
  fprintf('   control law:')
  fprintf('\n')

  for q=1:size(individual.control_law,1)
    fprintf('      b%i = ',q)
  fprintf(individual.control_law{q})
      fprintf('\n')
  end

    fprintf('Description\n')
    fprintf('   type : %s\n',individual.description.type)
    fprintf('   subtype : %s\n',individual.description.subtype)
    fprintf('   quality : %f\n',individual.description.quality)
    fprintf('   parents : %i\n',individual.description.parents)
    fprintf('\n')
end