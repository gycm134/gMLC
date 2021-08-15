function gMLC_ind=generate(gMLC_ind,gMLC_parameters,first)
% gMLCind class generate method
% We keep the chromosome in the matrix propriety, meaning the matrix with the introns
% If first=1, then the control law generated is defined by the initial conditions
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    if nargin <3,	first=false; end
    Nimin = gMLC_parameters.ControlLaw.InstructionSize.InitMin;


%% Individual generation
  % Create chromosome/matrix
  chromosome = create_chromosome(gMLC_parameters);

    % First individual test
      [~,idx] = exclude_introns(gMLC_parameters,chromosome);
      while first && (~isempty(idx))
      chromosome(idx,:)=[];
      	if size(chromosome,1)<Nimin
      		chromosome = create_chromosome(gMLC_parameters);
      	end
      [~,idx] = exclude_introns(gMLC_parameters,chromosome);
      end


    % Traduction
      control_law = read(gMLC_parameters,chromosome);

    % Effective instructions - matrix
    % We delete the introns in order to have the effective instructions
    % thus we can avoid redundant evaluation
      [matrix,~] = exclude_introns(gMLC_parameters,chromosome);

%% Update properties
  gMLC_ind.matrix = chromosome; %matrix;
  gMLC_ind.control_law = control_law;
  gMLC_ind.description.type = 'random';

end %method

%% Functions
function chromosome=create_chromosome(gMLC_parameters)
%% Choosing the number of intructions
   Nimax = gMLC_parameters.ControlLaw.InstructionSize.InitMax;
   Nimin = gMLC_parameters.ControlLaw.InstructionSize.InitMin;
   N_inst = round((Nimax-Nimin)*rand+Nimin);


 %% Construction of the chromosome
   v1 = randsrc(N_inst,1,1:gMLC_parameters.ControlLaw.RegNumber); % operand 1
   v2 = randsrc(N_inst,1,1:gMLC_parameters.ControlLaw.RegNumber); % operand 2
   v3 = randsrc(N_inst,1,gMLC_parameters.ControlLaw.OperatorIndices); % operator : +,-,*,/
   v4 = randsrc(N_inst,1,1:gMLC_parameters.ControlLaw.VarRegNumber); % output.ControlLaw.Registers

   chromosome = [v1 v2 v3 v4];
end
