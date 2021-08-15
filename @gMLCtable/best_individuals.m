function labels=best_individuals(gMLC_table,NumberIndividuals,eval,PrintIndivs)
% BEST_INDIVIDUALS gives information about the best individuals.
% Gives information of NumberIndividuals best individuals.
% If 0 : gives the individuals that have a matrix representation
% If 1 : gives the individuals that have been evaluated
% If 2 : gives the individuals that are evaluated and have a matrix
% representation.
% If NumberIndividuals is larger than the number of corresponding
% individuals it gives all of them.
%
% Guy Y. Cornejo Maceda, 07/18/2019
%
% See also step_evolution.

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA


%% Arguments
  if nargin < 3, eval = 1;end
  if nargin < 4, PrintIndivs = 0;end

%% Which one to select :
    switch eval
        case 0
            IndivsIDs = gMLC_table.isamatrix>0;
        case 1
            IndivsIDs = gMLC_table.evaluated>0;
        case 2
            IndivsIDs = logical(gMLC_table.evaluated>0 + gMLC_table.isamatrix>0);
    end
    IDs = 1:gMLC_table.number;
    IDs = IDs(IndivsIDs);

%% If NumberIndividuals is larger than the number of corresponding individuals it gives all of them.
    if sum(IndivsIDs) < NumberIndividuals
        NumberIndividuals = sum(IndivsIDs);
    end

%% Costs list
  CostList = gMLC_table.costs(IDs);

%% Sort et best
  [CostListSorted,IDXLabelsSorted] = sort(CostList);

%% Output
  labels = transpose(IDs(IDXLabelsSorted(1:NumberIndividuals)));

%% Print
if PrintIndivs
    fprintf('Best individuals, their cost(s) and control law:\n')
    for p=1:NumberIndividuals
        gMLC_ind = gMLC_table.individuals(labels(p));
        switch p
            case 1
                ord = 'st';
            case 2
                ord = 'nd';
            case 3
                ord = 'rd';
            otherwise
                ord = 'th';
        end
        fprintf(['%i-',ord,' individual:\n'],p)
        fprintf('   individual : %i\n',labels(p))
        fprintf('   cost: %f\n',CostListSorted(p))
        fprintf('   control law:')
        fprintf('\n')
        for q=1:gMLC.parameters.ProblemParameters.OutputNumber
            fprintf('      b%i = ',q)
            fprintf(gMLC_ind.control_law{q})
            fprintf('\n')
        end
        fprintf(['   type: ',gMLC_ind.description.type,'\n'])
        if strcmp(gMLC_ind.description.type,'interpolated') || ...
                strcmp(gMLC_ind.description.type,'coef DS')
            fprintf(['    subtype: ',gMLC_ind.description.subtype,'\n'])
            fprintf(['    quality: ',num2str(gMLC_ind.description.quality),'\n'])
            fprintf('    parents: %i\n',gMLC_ind.description.parents(1))
        end
        fprintf('\n')
        fprintf('\n')
    end
end
