function TO_EVALUATE=computesubstitute(TO_SUBSTITUTE,gMLC_table,gMLC_parameters)
% gMLC class computesubstitute method
% Computes substitute of the individuals in TO_SUBSTITUTE.
% Gives back the labels of the new individuals created.
%
% Guy Y. Cornejo Maceda, 08/27/209
%
% See also SIN, COS, TheOtherFunction.

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Initialization
TO_EVALUATE = 0*TO_SUBSTITUTE;

if numel(TO_SUBSTITUTE)>0

% --- Allocation
    list_individuals_to_substitute(numel(TO_SUBSTITUTE)) =  gMLCind;
    list_ControlPoints = zeros(numel(TO_SUBSTITUTE),numel(gMLC_table.ControlPoints(TO_SUBSTITUTE(1),:)));
    list_individuals(numel(TO_SUBSTITUTE)) =  gMLCind;
% --- Initialization
    for p=1:length(TO_SUBSTITUTE)
        list_individuals_to_substitute(p) = gMLC_table.individuals(TO_SUBSTITUTE(p));
        list_ControlPoints(p,:) = gMLC_table.ControlPoints(TO_SUBSTITUTE(p),:);
    end

%% Loop over the individuals
parfor p=1:length(TO_SUBSTITUTE)
      % --- Initialization
      Ind2substitute = list_individuals_to_substitute(p);
      ControlPoints = list_ControlPoints(p,:);
      Indz = gMLCind;
      % --- Build and complete
      qua = Indz.build_to_fit(ControlPoints,gMLC_table,gMLC_parameters);
      Indz.cost = Ind2substitute.cost;
      Indz.description.type = 'substitute';
      Indz.description.quality = qua;
      Indz.description.subtype = Ind2substitute.description.subtype;
      Indz.description.miscellaneous = Ind2substitute.ID;
      % --- Store in list
      list_individuals(p) = Indz;
end

for p=1:length(TO_SUBSTITUTE)
      % Add to table
      ID = gMLC_table.add(list_individuals(p),gMLC_parameters);
      gMLC_table.individuals(TO_SUBSTITUTE(p)).description.miscellaneous = ID;
      list_individuals(p).vertices = ID;
      list_individuals(p).coefficients = 1;
%       fprintf('QUELQUE CHOSE\n')
      % To evaluate
      TO_EVALUATE(p) = ID;
end

end

end %method
