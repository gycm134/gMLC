function pop = evaluate_pop(pop,idx_to_evaluate,MLC_parameters,MLC_table)
    % EVALUATE_POP evaluates given individuals in a population
    % The individuals to evaluate in a population are given by idx_to_evaluate.
    % The data base (table) is updated consequently.
    %
    %
    % See also create_pop, evolve_pop, MLCpop.

    %   Copyright (C) 2015-2017 Thomas Duriez.
    %   This file is adapted from @MLCpop/evaluate.m of the OpenMLC-Matlab-2 Toolbox. Distributed under GPL v3.


indiv_to_evaluate = pop.individuals(idx_to_evaluate);

  fprintf('Evaluation of generation %i :\n',pop.generation);
%% Evaluation loop
for p=1:numel(idx_to_evaluate)
    if MLC_parameters.verbose
        fprintf('    Evaluation of individual %i/%i',idx_to_evaluate(p),MLC_parameters.PopulationSize)
    end

    MLC_table.individuals(indiv_to_evaluate(p)).evaluate_indiv(MLC_parameters);
end

%% Complete population
for p=1:numel(idx_to_evaluate)
    % population.cost update
    all_J = cell2mat(MLC_table.individuals(indiv_to_evaluate(p)).cost(:,1));
    
    % Local performance of the individual 
    switch MLC_parameters.ProblemParameters.EstimatePerformance
        case 'mean'
            J = mean(all_J);
        case 'last'
            J = all_J(end);
        case 'worst'
            J = max(all_J);
        case 'best'
            J = min(all_J);
    end
    
    pop.costs(idx_to_evaluate(p)) = J;
    MLC_table.costlist(indiv_to_evaluate(p))=J;
end

end
