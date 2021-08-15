function gMLC = reName(gMLC,NewName)
% gMLC class reName method
% Change the Name of the run
%
% Guy Y. Cornejo Maceda, 08/27/209
%
% See also gMLC.

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters
    Name = gMLC.parameters.Name;
 
%% Test
    if exist(['save_runs/',NewName],'dir')
        error('This run already exist')
    end
    
%% Change Name
    system(['mv save_runs/',Name,' save_runs/',NewName]);
    gMLC.parameters.Name = NewName;
    gMLC.save;
    fprintf('%s changed to %s\n',Name,NewName)

%% Update properties

end %method
