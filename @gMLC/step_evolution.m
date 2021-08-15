function gMLC=step_evolution(gMLC)
% gMLC class step_evolution method
% Computes new individuals thanks to genetic operators.
% descibing inputs, processing and outputs
%
% Guy Y. Cornejo Maceda, 08/27/209
%
% See also step_exploitation.

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    evolution = gMLC.parameters.evolution;
    problem = gMLC.parameters.problem;
    problem_type = gMLC.parameters.problem_type;
    BS = gMLC.parameters.SimplexSize;
    last_ope = gMLC.simplex.status.last_operation;
    % Number of offsprings
    switch gMLC.history.facts(end,1)
        case 11
            NumberOffsprings = 1;
        case {12,13}
            NumberOffsprings = 2;
        case 14
            NumberOffsprings = BS+1;
        otherwise
            NumberOffsprings = gMLC.parameters.NOffsprings;
            if NumberOffsprings==0
                error('NumberOffsprings should not be 0 in this mode');
            end
    end
    if gMLC.parameters.NOffsprings>0
        NumberOffsprings = gMLC.parameters.NOffsprings;
    end
    % Genetic operators
    GeneticProbabilities = [0.5,0.5,0];

if VERBOSE > 0, fprintf('########### EVOLUTION ###########\n'),end

%% Evolution
  if not(evolution)
    if VERBOSE > 0, fprintf(' No evolution\n'),end
    if VERBOSE > 0, fprintf('####### END OF EVOLUTION ########\n'),end
    return
  end


%% Build evolution simplex
PopulationLabels = gMLC.build_evolution_set; % unless external in this case load
if strcmp(problem_type,'external')
    % Is there individuals to interpolate?
    to_build = gMLC.simplex.to_build;
    if not(isempty(to_build)) || not(strcmp(last_ope,'Subtitute computed'))
        if VERBOSE > 0, fprintf(' Evolution will be carried after the interpolation\n'),end
        if VERBOSE > 0, fprintf('####### END OF EVOLUTION ########\n'),end
        if VERBOSE > 0, fprintf('\n'),end
        error('The subtitution/interpolation should be carried before')
    end
end
%         PopulationLabels = load(['save_runs/',problem,'/Sets/']); Not
%         useful yet...
%         See External_EvoBasket;

  EvolvingBasketSize = size(PopulationLabels,1);

%% MLC parameters and stuff
  lgpc=MLC(problem,1);
  lgpc.parameters = gMLC.parameters;
  lgpc.parameters.PopulationSize = EvolvingBasketSize;
  for p=1:gMLC.table.number
      ControlPoints = gMLC.table.ControlPoints(p,:);
      lgpc.table.individuals(p) = gMLC.table.individuals(p).gMLC2MLC(lgpc.parameters,ControlPoints);
  end
  lgpc.table.number = gMLC.table.number;
  lgpc.table.non_redundant = 1:gMLC.table.number; % Hmmmmm..
  lgpc.table.control_points = gMLC.table.ControlPoints;
  lgpc.parameters.CrossoverOptions = {'gives2'}; %1????
    % Scale tourNament
    TourNamentSize = round(gMLC.parameters.TournamentSize*EvolvingBasketSize/100);
    lgpc.parameters.TournamentSize = TourNamentSize;
  % Initialize first population
  lgpc.population = MLCpop(1,lgpc.parameters.PopulationSize);
%% Initialize
  if (VERBOSE > 0) && mod(numel(PopulationLabels),10)~=0, fprintf('\n'),end
  if VERBOSE > 0, fprintf('  o Evolution (%i)',NumberOffsprings),end
  NewPop = MLCpop(1,NumberOffsprings);
  BoxIndividuals(EvolvingBasketSize) = MLCind;
  for p=1:EvolvingBasketSize
    gMLC_ind = gMLC.table.individuals(PopulationLabels(p));
    ControlPoints = gMLC.table.ControlPoints(PopulationLabels(p),:);
    BoxIndividuals(p) = gMLC_ind.gMLC2MLC(lgpc.parameters,ControlPoints);
  end
  lgpc.import(BoxIndividuals);
  NIndivs = 0;



%% Loop to fill the population % TO BE FUSED with @MLC/evolve_pop.m
  % Sort before evolving
    lgpc.population.sort_pop;
  % Evolve and fill
  while NIndivs < NumberOffsprings
    % Choose the operation
    ope = choose_operation(GeneticProbabilities);
    switch ope
      case 'crossover'
        if strcmp(gMLC.parameters.CrossoverOptions{1},'gives2') %is it an option?
            g2=true;
        else
            g2=false;
        end
        if NIndivs < NumberOffsprings-1 % do we hace the space ?
            c2=true;
        else
            c2=false;
        end
        NewPop.crossover(lgpc.population,lgpc.parameters,lgpc.table,NIndivs,g2&&c2);
      case 'mutation'
        NewPop.mutate(lgpc.population,lgpc.parameters,lgpc.table,NIndivs);
    end
    % New_pop size increase
    NIndivs = sum(NewPop.chromosome_lengths(:,1)>0);
  end

    if VERBOSE > 0, fprintf(': Done\n'),end

%% Add to gMLC.table
IDs = NewPop.individuals;
ID = zeros(length(IDs),1);
  for p=1:NumberOffsprings
    % Translate to gMLC
    Indev = gMLCind;
    Indev.matrix = lgpc.table.individuals(IDs(p)).chromosome; %
    Indev.control_law = lgpc.table.individuals(IDs(p)).control_law;
    Indev.description.type = 'evolved';
    Indev.description.subtype = NewPop.operation{p}.type;
    % MORE THINGS TO ADD
    switch NewPop.operation{p}.type
      case 'crossover'
        Indev.description.miscellaneous = NewPop.operation{p}.points_parts;
      case 'mutation'
        Indev.description.miscellaneous = NewPop.operation{p}.instructions;
    end
    Indev.description.parents = NewPop.parents(p,:);
    % Add to table
    id = gMLC.table.add(Indev,gMLC.parameters);
    Indev.vertices = id;
    Indev.coefficients = 1;
    ID(p) = id;
  end
    % Table.matrix = 1;
    gMLC.table.isamatrix(ID) = 1;
    % To evaluate
    gMLC.simplex.status.individuals_to_evaluate = [gMLC.simplex.status.individuals_to_evaluate;ID];

    %% Evaluation
      if VERBOSE > 0, fprintf('  o Evaluation: '),end
    % External evaluation test
        if strcmp(problem_type,'external')
          if VERBOSE > 2, fprintf('External evaluation'),end
          gMLC.simplex.waiting_room.labels = [gMLC.simplex.waiting_room.labels;ID];
          if VERBOSE > 3, fprintf('. Ready\n'),end
            % Nothing to continue
            % Update
            gMLC.simplex.status.last_operation = 'evolution';
          return
        end
    if VERBOSE > 0, fprintf(':\n'),end
    % The control law is evaluated here, so no need to put in the individuals_to_evaluate array.
    % But if there were to not be evaluated, they need to be added to the array
        Jev = -1*ones(length(IDs),1);
        cycle = gMLC.simplex.status.cycle+1;
        for p=1:length(IDs)
          jev=gMLC.table.evaluate(ID(p),gMLC.parameters,0); % 0=no visu
          N_ev = length(gMLC.simplex.status.individuals_to_evaluate)+p-length(IDs);
          gMLC.table.individuals(ID(p)).evaluation_order = [cycle,N_ev]; % Previously cycle+0.5
          Jev(p) = jev;
            if (VERBOSE > 0) && mod(p,10)==0, fprintf('\n'),end
        end

    %% Update properties
        % Individuals informations
            gMLC.simplex.waiting_room.labels = [gMLC.simplex.waiting_room.labels;ID];
            gMLC.simplex.waiting_room.costs = [gMLC.simplex.waiting_room.costs;Jev];
        % Stat
            gMLC.simplex.status.last_operation = 'evolution';

            if VERBOSE > 0, fprintf('\n'),end
%------------------------------------------------------------------
            % Update simplex (from waiting_room)
            labels=gMLC.simplex.update(gMLC.table,gMLC.parameters);

            % Update history
            switch gMLC.simplex.status.last_operation
            case 'evolution'
              fact_type = 6;
            case 'reflect'
              fact_type = 11;
            case 'single contraction'
              fact_type = 12;
            case 'expand'
              fact_type = 13;
            case 'shrink'
              fact_type = 14;
            case 'no exploitation'
              fact_type = Inf;
            case 'external' % external evaluation
                if VERBOSE > 0, fprintf(' Exploitation will be carried after the evaluation\n'),end
                if VERBOSE > 0, fprintf('####### END OF EVOLUTION ########\n'),end
                if VERBOSE > 0, fprintf('\n'),end
              return
            otherwise
              error('Wrong type of operation in step_evolution');
            end

            if not(isinf(fact_type))
              gMLC.history.add_fact(gMLC.parameters,fact_type,labels);
            end
        %     gMLC.history.add_fact(gMLC.parameters,fact_type,labels);

%% End Step1
  if VERBOSE > 0, fprintf('####### END OF EVOLUTION ########\n'),end
  if VERBOSE > 0, fprintf('\n'),end

end %method
