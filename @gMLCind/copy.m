function gMLC_ind_copy=copy(gMLC_ind)
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
    gMLC_ind_copy = gMLCind;

%% Transfer properties
    prop = properties(gMLC_ind);
    for p=1:length(prop)
        new_prop = get(gMLC_ind,prop{p});
        set(gMLC_ind_copy,prop{p},new_prop);
    end

end %method
