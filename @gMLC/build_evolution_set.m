function PopulationLabels =build_evolution_set(gMLC)
% gMLC class build_evolution_set method
% Extracts the labels to build the evolution set of individuals.
% Best individuals and landscape representatives.
%
% Guy Y. Cornejo Maceda, 08/27/209
%
% See also SIN, COS, TheOtherFunction.

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    problem = gMLC.parameters.problem;
    problem_type = gMLC.parameters.problem_type;
    cycle = gMLC.history.cycle(1);

    if strcmp(gMLC.parameters.LandscapeType,'none')
        % Select NOffsprings for classical evolution
            % Labels
            Labels = 1:gMLC.table.number;
            Labels = Labels(gMLC.table.evaluated>0);
            % Select
            PopulationLabels = Labels';%selection_individual(Labels,ParamStruct);
            % Sort
            PopulationLabels = gMLC.table.sort(PopulationLabels);
            % Remplace the non matrix individuals by matrix individuals
            PopulationLabels = gMLC.ReplaceNMIndividuals(PopulationLabels);
        return
    end
    
% Build evolution set
% We select individuals that have a matrix representation and have been
% evaluated

%% Select 10 best
    BasketLabels = gMLC.table.best_individuals(10,0); % 0 : matrix, 1 : evaluated, 2: both
   
%% Select 40 for the landscape description or less
    landscape_labels = gMLC.landscape_labels;
    if isempty(landscape_labels) || not(nnz(landscape_labels(:,1)==(cycle+1)))
        LandscapeLabels = gMLC.landscape_description; % fills the landscape_labels property
    else
        actual_cycle = find(landscape_labels(:,1)==(cycle+1));
        if numel(actual_cycle)~=1,error('landscape_labels problem'),end
        LandscapeLabels = gMLC.landscape_labels(actual_cycle,2:end);
    end
    % Remove 0 in LandscapeLabels (<1)
    LandscapeLabels(LandscapeLabels<1)=[];

%% Update EvolvingBasketSize
    PopulationLabels = ([BasketLabels;LandscapeLabels(:)]); % def % Do an unique operation? No so good individuals will be favorised
    gMLC.simplex.status.last_operation = 'Evolution set built';

%% Sort
    PopulationLabels = gMLC.table.sort(PopulationLabels);
  
%% Remplace the non matrix individuals by matrix individuals
      PopulationLabels=gMLC.ReplaceNMIndividuals(PopulationLabels);

%% Print
  if VERBOSE > 0, fprintf('  o Evolution set: (%i)\n     ',numel(PopulationLabels)),end
  for p=1:length(PopulationLabels)
      if VERBOSE > 0, fprintf('%i ',PopulationLabels(p)),end
      if not(mod(p,10))&&p>0, fprintf('\n'),end
      if not(mod(p,10))&&p>0&& p ~= length(PopulationLabels), fprintf('     '),end
  end
  
end %method
