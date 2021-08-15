function gMLC_table_copy=copy(gMLC_table,gMLC_parameters)
% gMLC class copy method
% Makes a copy of the simplex
%
% Guy Y. Cornejo Maceda, 11/14/2019
%
% See also SIN, COS, TheOtherFunction.

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters
%     VERBOSE = gMLC.parameters.verbose;

%% Initialization
    gMLC_table_copy = gMLCtable(gMLC_parameters);

%% Transfer properties
    gMLC_table_copy.initial_individuals = gMLC_table.initial_individuals;
    prop = properties(gMLC_table);
    for p=1:length(prop)
        new_prop = get(gMLC_table,prop{p});
        set(gMLC_table_copy,prop{p},new_prop);
    end

end %method
