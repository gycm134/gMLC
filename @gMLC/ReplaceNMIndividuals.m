function PopulationLabels = ReplaceNMIndividuals(gMLC,PopulationLabels)
% gMLC class ReplaceNMIndividuals method
% Now the exhaustive help text
% descibing inputs, processing and outputs
%
% Guy Y. Cornejo Maceda, 11/14/2019
%
% See also SIN, COS, TheOtherFunction.

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    problem_type = gMLC.parameters.problem_type;
    interpolation_type = gMLC.parameters.interpolation_type;

%% Remplace the non matrix individuals by matrix individuals
    % Find non-matrix individuals to substitute
    NMIndiv = [];
    for p=1:length(PopulationLabels)
        if not(gMLC.table.isamatrix(PopulationLabels(p)))
            Ind = gMLC.table.individuals(PopulationLabels(p));
            if isempty(Ind.description.miscellaneous)
                NMIndiv = [NMIndiv;PopulationLabels(p)];
            end
        end
    end

    % Substitute
    gMLC.simplex.to_build = [NMIndiv,gMLC.table.ControlPoints(NMIndiv,:)];
    if strcmp(interpolation_type,'external') && not(isempty(NMIndiv))
        gMLC.simplex.to_build = [NMIndiv,gMLC.table.ControlPoints(NMIndiv,:)];
          if VERBOSE > 0, fprintf('Its time to interpolate! %i individuals\n',numel(NMIndiv)),end
        fclose(fopen('CONTINUE_INTERPOLATION','w'));
        return
    else
        computesubstitute(NMIndiv,gMLC.table,gMLC.parameters);
    end

    % Replace non-matrix individuals by a matrix representative
    for p=1:length(PopulationLabels)
        if not(gMLC.table.isamatrix(PopulationLabels(p)))
            Ind = gMLC.table.individuals(PopulationLabels(p));
            if isempty(Ind.description.miscellaneous)
                error('Should already been done!');
            else
                IDsub = Ind.description.miscellaneous;
            end
            PopulationLabels(p)=IDsub;
        end
    end

end %method
