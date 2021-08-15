function CreatefunctionLabview(gMLC_parameters,gMLC_ind)
% gMLC class CreatefonctionLabview function
% Creates the fonction.txt file in Path/
% The control law is post-processed for LabView format
%
% Guy Y. Cornejo Maceda, 11/14/2019
%
% See also SIN, COS, TheOtherFunction.

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters
    LabViewPath = gMLC_parameters.LabViewPath;
    
%% Print
    fprintf('\nWriting fonction.txt in\n');
    fprintf(['  ',LabViewPath,'\n']);
    
%% PostProcessing
    % Index
    IndivIndex = [num2str(gMLC_ind.ID),'_',date];
    % Control law
    control_law = gMLC_ind.control_law;
    for p=1:size(control_law,1)
        control_law{p} = changeoperators(control_law{p});
    end
    control_law = strrep_cl(gMLC_parameters,control_law,2);

    
%% Create
    % Open
    fid = fopen([LabViewPath,'fonction.txt'],'wt');
    % Write
    fprintf(fid,[IndivIndex,';']);
    for p=1:size(control_law,1)
        fprintf(fid,[control_law{p},';']);
    end
    % Close
    fclose(fid);

%% Print
    fprintf('    Done!\n')
end %method


%% Function
function CLout=changeoperators(CLin)
% Find and replace my_div
% CLin = 'my_div(1+2,my_log(7)*(3))+(1)';
% CLin = 'my_div(1+2,my_div(7,6)*(3))+(1)';

% my_div
CLout = CLin;
% my_div
    CLout = strrep(CLout,'my_div','');
    CLout = strrep(CLout,',',')./(');
 
% my_log
ML = strfind(CLout,'my_log');
while not(isempty(ML))
    % first parenthesis
    FP = CLout((ML(1)+7):end);
    stru1=cumsum(double(FP=='('));
    stru2=cumsum(double(FP==')'));
    diffstr = abs(stru1-stru2);
    LP = find(diffstr==0,1);
    IDX = ML(1)+7+LP;
    CLout = [CLout(1:IDX),')',CLout((IDX+1):end)];
    CLout = strrep(CLout,'my_log','log(abs');
    % New ML
    ML = strfind(CLout,'my_log');
end
end