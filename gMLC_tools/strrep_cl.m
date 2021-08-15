function NewSyntaxCL = strrep_cl(MLC_parameters,ControlLaw,TypeOfReplacement)
    % STRREP_PRETESTING Changes the inputs of the control laws for pretesting
    %
    %
    % Guy Y. Cornejo Maceda, 03/03/2020
    %
    % See also tresh, limit.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

%% Parameters
    NO = MLC_parameters.ProblemParameters.OutputNumber;
    NUstdy = MLC_parameters.ProblemParameters.UnsteadyOutputs;
    NStdy  = MLC_parameters.ProblemParameters.SteadyOutputs;
    NI = MLC_parameters.ProblemParameters.InputNumber;
    NS = MLC_parameters.ProblemParameters.NumberSensors;
    NTDF = MLC_parameters.ProblemParameters.NumberTimeDependentFunctions;
    
%% Initialization
    GenericSensors = cell(1,NS);
    GenericTDF = cell(1,NTDF);
        for p=1:NS,GenericSensors{p} = ['s(',num2str(p),')'];end
        for p=1:NTDF,GenericTDF{p} = ['h(',num2str(p),')'];end
    OldSyntax = horzcat(GenericSensors,GenericTDF);

%% Change syntax        
    Sensors = cell(1,NS);
    TDF = cell(1,NTDF);
    NewSyntaxCL = cell(NO,1);
    if TypeOfReplacement==1 % MATLAB/Octave syntax
        if NTDF > 0
            TDF = MLC_parameters.ProblemParameters.TimeDependentFunctions(1,:);
        end
        Sensors = GenericSensors;
    elseif TypeOfReplacement==2 % Problem syntax
        if NS > 0
            Sensors = MLC_parameters.ProblemParameters.Sensors;
        end
        if NTDF > 0
            TDF = MLC_parameters.ProblemParameters.TimeDependentFunctions(2,:);
        end
    end
    NewSyntax = horzcat(Sensors,TDF);

%% Test
    if numel(OldSyntax) ~= numel(NewSyntax),error('Number functions not consistent.'),end
    if numel(OldSyntax) ~= NI,error('Number functions not consistent!'),end
    if NO ~= (NUstdy+NStdy),error('Number of steady and unsteady outputs not consistent.'),end
    
%% Loop for replacement
  for Controlleri=1:NO
      ControlStringExpr = ControlLaw{Controlleri};
      for p=1:NI
          ControlStringExpr=strrep(ControlStringExpr,OldSyntax{p},NewSyntax{p});
      end
      NewSyntaxCL{Controlleri} = ControlStringExpr;
  end

% IN CASE OF JET MIXING (and comment the section above)

% %% Replace time-dependent functions
% for IdxC=1:NO
%     ControlStringExpr = ControlLaw{IdxC};
%     for IdxTDF=1:NTDF
%         ControlStringExpr=strrep(ControlStringExpr,GenericTDF{IdxTDF},TDF{IdxTDF});
%     end
%     NewSyntaxCL{IdxC} = ControlStringExpr;
% end
% 
% %% Unsteady control laws
% % Sensor signals for the unsteady outputs
% for IdxC=1:NUstdy
%     ControlStringExpr = NewSyntaxCL{IdxC};
%     for IdxI=1:NS
%         ControlStringExpr = strrep(ControlStringExpr,GenericSensors{IdxI},Sensors{IdxI});
%     end
%     NewSyntaxCL{IdxC} = ControlStringExpr;
% end
%     
% %% Build steady control laws
% for IdxC=(NUstdy+1):NO
%     ControlStringExpr = NewSyntaxCL{IdxC};
%     % Impose 0 to sensor signals
%     for IdxI=1:NS
%           ControlStringExpr=strrep(ControlStringExpr,GenericSensors{IdxI},'0');
%     end
%     % Impose T=0 to time dependent functions
%       ControlStringExpr=strrep(ControlStringExpr,'*T','*0');
%       ControlStringExpr=strrep(ControlStringExpr,'*i','*0');
%     NewSyntaxCL{IdxC} = ControlStringExpr;
% end

%% Specific changes
  % To be added

end
