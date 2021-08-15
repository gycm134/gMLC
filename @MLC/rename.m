function gMLC = rename(gMLC,NewName)
% gMLC class rename method
% Change the name of the run
%
% Guy Y. Cornejo Maceda, 08/27/209
%
% See also gMLC.

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters
    Name = gMLC.parameters.Name;
     % Version
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    
%% Test
    if exist(['save_runs/',NewName],'dir')
        error('This run already exist')
    end
    
%% Change name
    system(['mv save_runs/',Name,' save_runs/',NewName]);
    gMLC.parameters.Name = NewName;
    % Save
    if isOctave
      gMLC.save_octave;
    else
      gMLC.save_matlab;
    end
    fprintf('%s changed to %s\n',Name,NewName)

%% Update properties

end %method
