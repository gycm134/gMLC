function interpolate_simplex(gMLC,IDX)
% gMLC class interpolated_simplex interpolated_simplex
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
  VERBOSE = gMLC.parameters.verbose;
  Name = gMLC.parameters.Name;
  cycle = gMLC.history.cycle;

%% Test
    if IDX>size(gMLC.simplex.to_build,1) || IDX <=0
        fprintf('Wrong ID\n');
        return
    end

%% Initialization
  ControlPoints = gMLC.simplex.to_build(IDX,2:end);
  label = round(gMLC.simplex.to_build(IDX,1));

%% Interpolation
  % Call MLC
    Ind = gMLCind;
    qua = Ind.build_to_fit(ControlPoints,gMLC.table,gMLC.parameters);
  % Update properties
    description = gMLC.table.individuals(label).description;
    Ind.description.subtype = description.subtype;
    Ind.description.quality = qua;
    Ind.description.miscellaneous = label; % Ind is the interpolation of label

%% Save
  Name_ind = num2str(label);
  Ind.save(Name,Name_ind);

%% Print
fprintf('Done\n');

end %interpolated_simplex
