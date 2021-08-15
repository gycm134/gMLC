function gMLC_simplex_copy=copy(gMLC_simplex,gMLC_parameters)
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
    gMLC_simplex_copy = gMLCsimplex(gMLC_parameters);

%% Transfer properties
    prop = properties(gMLC_simplex);
    for p=1:length(prop)
        new_prop = get(gMLC_simplex,prop{p});
        set(gMLC_simplex_copy,prop{p},new_prop);
    end

end %method
