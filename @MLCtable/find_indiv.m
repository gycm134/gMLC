function IndexIndiv = find_indiv(MLC_table,indiv)
    % FIND_INDIV finds indices of indiv
    % Checks if the individual already exists.
    %
    %
    % See also MLC, MLCpop, MLCind.

    % Copyright (C) 2015-2019 Thomas Duriez.
    % This file is adapted from @MLCtable/find_individual.m of the OpenMLC-Matlab-2 Toolbox. Distributed under GPL v3.

%% Initialization
  IndexIndiv = [];

%% Find
  idx = find(MLC_table.hashlist==indiv.hash);

%% Get the first individual
if ~isempty(idx)
    for p=1:length(idx)
        if logical(prod(strcmp(MLC_table.individuals(idx(p)).control_law,indiv.control_law)))
            IndexIndiv = idx(p);
            break
        end
    end
end

end
