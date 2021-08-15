function crit=criterion(gMLC)
% gMLC class criterion method
%
% STOP?
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
VERBOSE = gMLC.parameters.verbose;
cycle = gMLC.history.cycle;

%% Criterion
crit = false;

switch gMLC.parameters.criterion
    case 'find better than'
        fprintf('no coded yet (criterion)');
        crit = logical(floor(2*rand));
        
    case 'number of evaluations'
        crit = sum(gMLC.table.evaluated>0)>=gMLC.parameters.number_of_evaluations;
    otherwise
        if cycle(1)>=cycle(2),crit = true;end
end

%% Print
if crit
    if VERBOSE > 0, fprintf(' Stopping criterion reached!\n'),end
    if VERBOSE > 1, fprintf([' Criterion : ',gMLC.parameters.criterion,'\n']),end
end

end %method
