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

 	

%% Loop over the individuals
for p=1:length(TO_SUBSTITUTE)
      % Initialization
      Ind2substitute = gMLC_table.individuals(TO_SUBSTITUTE(p));
      ControlPoints = gMLC_table.ControlPoints(TO_SUBSTITUTE(p),:);
      Indz = gMLCind;
      % Build and complete
      qua = Indz.build_to_fit(ControlPoints,gMLC_table,gMLC_parameters);
      Indz.cost = Ind2substitute.cost;
      Indz.description.type = 'substitute';
      Indz.description.quality = qua;
      Indz.description.subtype = Ind2substitute.description.subtype;
      Indz.description.miscellaneous = Ind2substitute.ID;



      % Add to table
      ID = gMLC_table.add(Indz,gMLC_parameters);
      Ind2substitute.description.miscellaneous = ID;
      Indz.vertices = ID;
      Indz.coefficients = 1;
%       fprintf('QUELQUE CHOSE\n')
      % To evaluate
      TO_EVALUATE(p) = ID;
end

end %method
