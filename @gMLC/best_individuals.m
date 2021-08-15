function best_individuals(gMLC,Nbest,Iend)
% BEST_INDIVIDUALS gives information about the best control laws.
% Gives information of the Nbest best control law after GEN generations.
%
% Guy Y. Cornejo Maceda, 01/08/2020
%
% See also best_individual, give, chromosome.

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Arguments
    if nargin < 3
        Iend=gMLC.table.number;
        if nargin < 2
            Nbest=5;
        end
    end

%% Parameters
    pop_size = gMLC.parameters.PopulationSize;

%% Extract individuals
    % Labels
    Labels = 1:gMLC.table.number;
    Labels = Labels(gMLC.table.evaluated(1:Iend)>0);
    % Costs
    Costs = gMLC.table.costs(Labels);
    % Sort
    [CostsS,IDX] = sort(Costs);
    LabelsS = Labels(IDX);


%% Print
    fprintf('Best individuals, their costs and control law:\n')
    for p=1:Nbest
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
        fprintf('   Label: %i\n',LabelsS(p))
        fprintf('   Type : %s\n',gMLC.table.individuals(LabelsS(p)).description.type)
        fprintf('   Cost: %f\n',CostsS(p))
        fprintf('   Control law:')
        fprintf('\n')
        for q=1:gMLC.parameters.ProblemParameters.OutputNumber
            fprintf('      b%i = ',q)
            fprintf(gMLC.table.individuals(LabelsS(p)).control_law{q})
            fprintf('\n')
        end
        fprintf('\n')
        fprintf('\n')
    end
