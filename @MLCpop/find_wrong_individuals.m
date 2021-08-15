function idx = find_wrong_individuals(pop,MLC_parameters,MLC_table,idx_bad_indivs)
    % FIND_WRONG_INDIVIDUALS find individuals that don't fit the test.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also clean, replace_individuals.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Bad individuals
  bad_indivs = pop.individuals(idx_bad_indivs);

%% find individuals close to a solution (PINBALL)
  find_wi = zeros(length(bad_indivs));
  for p=1:length(bad_indivs)
      ind=MLC_table.individuals(bad_indivs(p));
      dist = Dist2bt2(MLC_parameters,ind.control_law);

      if dist < 0.001*2*sqrt(2)
         find_wi(p)=1;
      end
  end

%% Output
idx = idx_bad_indivs(logical(find_wi));

end
