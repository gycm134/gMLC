function b_output=expe_create_control_ID_select(gMLC,IND)
  % EXPE_CREATE_CONTROL_SELECT creates a control law function for external evaluation.
  % Takes in argument an gMLC object, a generation and a list of indices to create
  % a file containing the corresponding control law.
  % That file (bNn.m) is to be used in an external evaluation.
  % A number is associated to each control law.
  % This number is used to switch from one control law to the other.
  % The control law function also includes the ID of the control law as
  % last output.
  % This function is employed in External_initialization_START, 
  % External_exploration_START, External_exploitation_START
  %
  % Guy Y. Cornejo Maceda, 03/18/2020
  %
  % See also expe_create_control_solo, expe_create_control_time.

  % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
  % CC-BY-SA

%% Initilization
  % Name
  Name = gMLC.parameters.Name;
  % Directory
  dir = 'save_runs/tmp';
  % Precision
  Precision = gMLC.parameters.ControlLaw.Precision;
  % Others
  nind = length(IND);
  b_output = cell(nind,1);
  OutputNumber = gMLC.parameters.ProblemParameters.OutputNumber; 

%% List of individuals
    fid = fopen(fullfile(dir,'ListIndividuals.txt'),'wt');
    for p=1:nind
        fprintf(fid,num2str(IND(p)));
        fprintf(fid,'\n');
    end
    fclose(fid);
%% File
  fid = fopen(fullfile(dir,'ControlLawSelect.m'),'wt');
    % output string
    OUT = '[';
    for q=1:OutputNumber
        if q>1
            OUT = [OUT,',out',num2str(q)];
        else
            OUT = [OUT,'out',num2str(q)];
        end
    end
    % --- ID
    OUT = [OUT,',ID'];
    % --- Close and continue
    OUT = [OUT,']'];
  fprintf(fid,['function ',OUT,'=ControlLawSelect(s,t,n)']);
  fprintf(fid,'\n');
  fprintf(fid,['switch n']);
  fprintf(fid,'\n');

for p=1:nind

    b_cell = gMLC.table.individuals(IND(p)).control_law;
    
    % remplace variables
    b_cell = strrep_cl(gMLC.parameters,b_cell,2); %2: for evaluation
    
    % loop over the number of OutputNumber
    Allbx = '[';
        % put time delay in the control laws HERE!!!!!!!!!!!!!!!!!
    fprintf(fid,['   case ',num2str(p)]);
    fprintf(fid,'\n');
    
        % --- Loop over the control law outputs
        for q=1:OutputNumber
            % concatenate the string expressions
            if q>1
                Allbx=[Allbx,';',b_cell{q}];
            else
                Allbx=[Allbx,b_cell{q}]; 
            end
            % outputs
        fprintf(fid,['   out',num2str(q),'=',b_cell{q},';']);
        fprintf(fid,'\n');
        end
        % --- Add the ID
        fprintf(fid,['   ID=',num2str(IND(p)),';']);
        fprintf(fid,'\n');
    
    % --- Function definition
    Allbx = [Allbx,']'];
    eval(['bf = @(s)(' Allbx ');']);
    b_output{p}=bf;
end

fprintf(fid,'   otherwise');
fprintf(fid,'\n');
% loop
    for q=1:OutputNumber
    fprintf(fid,['   out',num2str(q),'=0;']);
    fprintf(fid,'\n');
    end
fprintf(fid,'end');
fprintf(fid,'\n');

fprintf(fid,'\n');
fprintf(fid,'end');
fprintf(fid,'\n');
fprintf(fid,'\n');
% my_div
fprintf(fid,'function q=my_div(x,y)');
fprintf(fid,'\n');
fprintf(fid,['protection = 1e-',num2str(Precision),';']);
fprintf(fid,'\n');
fprintf(fid,'y(y==0)=inf;');
fprintf(fid,'\n');
fprintf(fid,'q=x./(y.*(abs(y)>protection)+protection*sign(y).*(abs(y)<=protection));');
fprintf(fid,'\n');
fprintf(fid,'end');

fprintf(fid,'\n');
fprintf(fid,'\n');

% my_log
fprintf(fid,'function q=my_log(x)');
fprintf(fid,'\n');
fprintf(fid,['protection = 1e-',num2str(Precision),';']);
fprintf(fid,'\n');
fprintf(fid,'q=log10(abs(x).*(abs(x)>=protection)+protection*(abs(x)<protection));');
fprintf(fid,'\n');
fprintf(fid,'end');

fclose(fid);
