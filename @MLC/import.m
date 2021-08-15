function MLCobj=import(MLCobj,BoxIndividuals)
% MLC class import method
% Import individuals from the BoxIndividuals and fill the rest with Monte Carlo
% individuals
% Acts as a generate_population method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = MLCobj.parameters.verbose;
    generation = MLCobj.generation;
    rmdd = MLCobj.parameters.RemoveRedundants; % HMMM..
    PopulationSize = MLCobj.parameters.PopulationSize;

    if (VERBOSE > 4), fprintf(' G1');end

%% Which population
    last_pop = size(MLCobj.population,1);
    if strcmp(MLCobj.population.evaluation,'nonexistent')
        last_pop = last_pop-1;
    end
    if generation==last_pop
      TIME=tic;
      new_population = MLCpop(generation+1,MLCobj.parameters.PopulationSize);
      % initialization
      indivs = zeros(PopulationSize,1);
      costs = zeros(PopulationSize,1);
      chro_lengths = zeros(PopulationSize,2);
      cmpt = 1;
      % fill with importation
      for p=1:size(BoxIndividuals,2)
        [idx,~] = MLCobj.table.add_indiv(MLCobj.parameters,BoxIndividuals(p),1:MLCobj.table.number);
        indivs(cmpt) = idx;
        costs(cmpt) = mean(cell2mat(BoxIndividuals(p).cost(:,1)));
        chro_lengths(cmpt,:) = BoxIndividuals(p).chromosome_lengths;
        cmpt = cmpt+1;
      end
      % fill with monte carlo
      for cmpt=cmpt:PopulationSize
          error('The evaluation of new Monte-Carlo individuals is not coded yet')
        % Create new individual
        new_individual=MLCind;
        new_individual.generate(MLCobj.parameters);
        [idx,already_exist]=MLCobj.table.add_indiv(MLCobj.parameters,new_individual,1:MLCobj.table.number);
          % Test if it already exists
            while already_exist&&rmdd
                new_individual=MLCind;
                new_individual.generate(MLCobj.parameters);
                [idx,already_exist]=MLCobj.table.add_indiv(MLCobj.parameters,new_individual,1:MLCobj.table.number);
            end
        % population properties filling
        indivs(cmpt) = idx;
        chro_lengths(cmpt,:) = new_individual.chromosome_lengths;
      end

    else
      error('Not coded yet (import)')
    end
%% Update properties
    new_population.individuals = indivs;
    new_population.costs = costs; % To change if new individuals
    new_population.chromosome_lengths = chro_lengths;
    new_population.evaluation = 'created';
    MLCobj.population(generation+1)=new_population;

% fprintf('End of generation : population generated in %s seconds\n',num2str(toc(TIME)))

%% Clean population (Pretesting and stuff )
if MLCobj.parameters.OptiMonteCarlo
    MLCobj.population.clean(MLCobj.parameters,MLCobj.table,MLCobj.population);
end

%% End
MLCobj.population.evaluation = 'ready_to_evaluate'; % if there is new individuals, we need to evaluate them

end %method
