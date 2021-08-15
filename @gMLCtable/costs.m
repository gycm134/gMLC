function [CIDs,gMLC_table]=costs(gMLC_table,IDs)
% gMLC class costs method
%
% Gives the costs of all the IDs given
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    if nargin <2, IDs = 1:gMLC_table.number;end

%% Extract costs
  Ni = length(IDs);
  CIDs = NaN(Ni,1);
  for p=1:Ni
    CIDs(p) = gMLC_table.individuals(IDs(p)).cost{1};
  end

end %method
