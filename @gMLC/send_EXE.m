function gMLC=send_EXE(gMLC,labels,opti_type)
% gMLC  send_to_external_evaluation send_to_external_evaluation
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    OutputNumber = gMLC.parameters.ProblemParameters.OutputNumber;
    actuation_limit = gMLC.parameters.ProblemParameters.ActuationLimit;
    Name = gMLC.parameters.Name;
    BS = gMLC.parameters.SimplexSize;

%% Initialization
    cycle = gMLC.history.cycle(1);
    Set =  cell(size(labels,1),OutputNumber+1);

if VERBOSE > 3, fprintf(['Set ',num2str(cycle+1),' file generation : ']),end

%% Fill the set
    for p=1:numel(labels)
      % select control law
      control_law = gMLC.table.individuals(labels(p)).control_law;
      % replace the control law for evaluation
      control_law = strrep_cl(gMLC.parameters,control_law,2);
      % limit the control law
      control_law = limit_to(control_law,actuation_limit);
      % Fill the set
      Set(p,1) ={labels(p)};
      Set(p,2:end) = control_law(:);
    end

%% Save
    % create folder
    dir_set = ['save_runs/',Name,'/Sets'];
    if not(exist(dir_set,'dir'))
      mkdir(dir_set)
    end

    % subtype
    subtype = '';
    if strcmp(opti_type,'EVO')
        switch numel(labels)
            case 1
                subtype = '_1';
            case 2
                subtype = '_2';
            case BS+1
                subtype = '_3';
        end
    end
    save([dir_set,'/Set',num2str(cycle+1),'_',opti_type,subtype,'.mat'],'Set');

%% Fortran
if gMLC.parameters.ProblemParameters.fortran_evaluation
  error('Not coded yet ...(fortran evaluation)')
end
if VERBOSE > 3, fprintf('Done.\n'),end

end %send_to_external_evaluation
