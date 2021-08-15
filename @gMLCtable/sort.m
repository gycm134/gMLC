function sID=sort(gMLC_table,ID)
% gMLC class sort method
% Now the exhaustive help text
% descibing inputs, processing and outputs
%
% Guy Y. Cornejo Maceda, 08/27/209
%
% See also SIN, COS, TheOtherFunction.

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Initialization
    Costs = gMLC_table.costs(ID);
    [~,IDX] = sort(Costs);
    sID = ID(IDX);

end %method
