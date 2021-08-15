function MLC_ind=gMLC2MLC(gMLC_ind,MLC_parameters,ControlPoints)
% gMLC class gMLC2MLC method
% Translates gMLC individuals to MLC individuals
%
% Guy Y. Cornejo Maceda, 08/27/209
%
% See also SIN, COS, TheOtherFunction.

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters

%% Initiliazation
  MLC_ind = MLCind;

%% Translate
  MLC_ind.chromosome = gMLC_ind.matrix;
  MLC_ind.cost = gMLC_ind.cost;
  MLC_ind.control_law = gMLC_ind.control_law;
  [EIC,non_intron_MLC_indces] = exclude_introns(MLC_parameters,gMLC_ind.matrix);
  MLC_ind.EI.chromosome = EIC;
  MLC_ind.EI.MLC_indces = non_intron_MLC_indces;
  MLC_ind.occurences = 0;
  MLC_ind.evaluation_time = gMLC_ind.evaluation_time;
  hash = DataHash(gMLC_ind.matrix);
  MLC_ind.hash = hex2num(hash(1:16));
  MLC_ind.control_points = ControlPoints;
  MLC_ind.ref = -1;

%% Update properties

end %method
