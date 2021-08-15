classdef gMLChistory < handle
% gMLChistory class definition file
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Properties
properties
    facts %what happened (Evolution, Simplex ...)
    cycle
end

%% External methods
methods
    obj=add_fact(obj,parameters,fact_to_be_added,who);
end

%% Internal methods
methods
    % Constructor
    function obj = gMLChistory
        % Initialize properties
        obj.facts = [];
        obj.cycle = [-1,-1];
    end
end

end %classdef
