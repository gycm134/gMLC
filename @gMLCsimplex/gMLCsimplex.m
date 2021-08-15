classdef gMLCsimplex < handle
% gMLCsimplex class definition file
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Properties
properties
    % Initialization
        initial_individuals
    % Individuals informations
        labels
        costs
        waiting_room % structure : labels, costs
        to_build
    % Centroid
        centroid
    % Distance between elements
        dist_list % useful to compute the centroid, not really. So far it is useless
    % Stat
        status
end

%% External methods
methods
    % Generate the first simplex
        obj = generate_random(obj,gMLC_table,gMLC_parameters);
    % Main methods
        % exploitation
        obj = downhill_simplex(obj,gMLC_table,gMLC_parameters);
    % Downhill steps
        obj = step_ordering(obj,gMLC_table,gMLC_parameters);
        obj = step_centroid(obj,gMLC_table,gMLC_parameters);
        obj = step_reflect(obj,gMLC_table,gMLC_parameters);
        obj = step_single_contraction(obj,gMLC_table,gMLC_parameters);
        obj = step_expanse(obj,gMLC_table,gMLC_parameters);
        obj = step_shrink(obj,gMLC_table,gMLC_parameters);
    % Evaluate the simplex
        obj = evaluate(obj,gMLC_table,gMLC_parameters);
    % Update
        [obj,labels] = update(obj,gMLC_table,gMLC_parameters);
    % External interpolation
	     numerical_DS(obj,gMLC_table,gMLC_parameters);
    % Compute LGP substitute
        obj = substitute_LGP(obj,gMLC_table,gMLC_parameters);
    % Copy
        obj2 = copy(obj,gMLC_parameters);
end
%% Internal methods
methods
    % Constructor
    function obj = gMLCsimplex(gMLC_parameters)
%         Properties initialization
            obj.initial_individuals.labels = zeros(gMLC_parameters.Number_MonteCarlo_Init,1);
            obj.initial_individuals.evaluated = false(gMLC_parameters.Number_MonteCarlo_Init,1);
            obj.labels = zeros(gMLC_parameters.SimplexSize,1);
            obj.costs = -1*ones(gMLC_parameters.SimplexSize,1);
                N_EP = gMLC_parameters.ControlLaw.ControlPointNumber;
                MI = gMLC_parameters.ProblemParameters.OutputNumber;
                N_CP = N_EP*MI;
            obj.waiting_room.labels = [];
            obj.waiting_room.costs = [];
            obj.to_build=[];
            obj.centroid = NaN(1,N_CP); % Name of file
            obj.dist_list = -1*ones(gMLC_parameters.SimplexSize,1);
            	  status.evaluated = 'not generated';
                status.last_operation = 'NULL';
                status.individuals_to_evaluate = []; % for numerical simulation, we could compute several control laws at the same time
                status.cycle = -1; % To give the right evaluation_order
            obj.status = status;
    end

    % get
    function val = get(obj,prop)
      if (nargin < 1 || nargin > 2)
        print_usage ();
      end

      if (nargin ==1)
        val=obj;
      else
        if (~ ischar(prop))
          error ('@NumHandle/get: PROPERTY must be a string');
        end

        switch (prop)
          case 'initial_individuals'
            val = obj.initial_individuals;
          case 'labels'
            val = obj.labels;
          case 'costs'
            val = obj.costs;
          case 'waiting_room'
            val = obj.waiting_room;
          case 'to_build'
            val = obj.to_build;
          case 'centroid'
            val = obj.centroid;
          case 'dist_list'
            val = obj.dist_list;
          case 'status'
            val = obj.status;
          otherwise
            error ('@NumHandle/get: invalid PROPERTY "%s"',prop);
        end
      end
      end %get

      % set
    function pout = set (obj,varargin)
      if (numel (varargin) < 2 || rem (numel(varargin),2) ~=0)
        error ('@NumHandle/set: expecting PROPERTY/VALUE pairs');
      end
      pout = obj;
      while (numel (varargin) > 1)
        prop = varargin{1};
        val = varargin{2};
        varargin(1:2) = [];
        if (~ ischar(prop))
          error ('@NumHandle/set : invalid PROPERTY for MLC class');
        end

        switch (prop)
            case 'initial_individuals'
                pout.initial_individuals = val;
            case 'labels'
                pout.labels = val;
            case 'costs'
                pout.costs = val;
            case 'waiting_room'
                pout.waiting_room = val;
            case 'to_build'
                pout.to_build = val;
            case 'centroid'
                pout.centroid = val;
             case 'dist_list'
                pout.dist_list = val;
            case 'status'
                pout.status = val;
            otherwise
            error ('@NumHandle/set: invalid PROPERTY for MLC class');
        end
      end
    end %set
end

end %classdef
