function pop = clean(pop,MLC_parameters,MLC_table,pop_old,idx_bad_values)
    % CLEAN remove individuals after a pre-test
    % Removes non adequate individuals by applying different tests.
    % Those tests are done until the population is filled only with adequate individuals.
    % The indices in idx_bad_values are cleaned.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also pretesting, find_bad_individuals, replace_individuals.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Initialization
	PopSize = MLC_parameters.PopulationSize;
	pretest = MLC_parameters.Pretesting;

%% idx_bad_values
	if nargin<5
		if MLC_parameters.ExploreIC
			ii = 2;
		else
			ii = 1;
		end
	    idx_bad_values=ii:length(pop.individuals);
	end


%% Tests
	IND_ref = zeros(length(pop),1);
	IND_ref = pop;
	while pretest
	    IND=pop.pretesting(MLC_parameters,MLC_table,pop_old,idx_bad_values);
	    pretest = sum(IND_ref==IND)~=PopSize; % if there is one different redo the cleaning
	    IND_ref = IND;
	end
