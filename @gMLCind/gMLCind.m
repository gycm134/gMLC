classdef gMLCind < handle
% gMLCind class definition file
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Properties
properties
    matrix %we are always looking at the effective matrix, because we don't use genetic operators.
    cost
    control_law
    evaluation_time
    description % type, subtype, quality, parents
    evaluation_order % the number associated to the evaluation [cycle,number]
    ID
    % Interpolation
    vertices
    coefficients
    simplex_labels
end

%% External methods
methods
    obj = generate(obj,parameters,first);
    J = evaluate(obj,parameters,visu,force_eval);
    % individual tests
    % is_ok = simplex_test(obj,parameters); TO REMOVE
    is_ok = duplicate_test(obj,table,parameters);
    is_ok = other_test(obj,parameters);
    % call MLC
    obj = build_to_fit(obj,ControlPoints,table,parameters);
    % interpolation
    DS_coeff(obj,table,type,idx); % still uselful ?
    % Translation to MLC
    MLC_ind = gMLC2MLC(gMLC_ind,MLC_parameters,ControlPoints)
    % load/save
    save(obj,Name_gMLC,Name_ind);
    load(obj,Name_gMLC,Name_ind);
    % Copy
    obj2 = copy(obj);
end

%% Internal methods
methods
    % Constructor
    function obj = gMLCind()
        % Initialize properties
            obj.matrix = [];
            obj.cost = {Inf};
            obj.control_law = {};
            obj.evaluation_time=0;
            obj.description.type = 'not generated';
            obj.description.subtype = 'no subtype';
            obj.description.quality = -1;
            obj.description.parents = [];
            obj.description.miscellaneous =[];
            obj.evaluation_order = [];
            obj.ID = -1;
	        obj.vertices = [];
            obj.coefficients = [];
            obj.simplex_labels = [];
    end

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
              case 'matrix'
                val = obj.matrix;
              case 'cost'
                val = obj.cost;
              case 'control_law'
                val = obj.control_law;
              case 'evaluation_time'
                val = obj.evaluation_time;
              case 'description'
                val = obj.description;
              case 'evaluation_order'
                val = obj.evaluation_order;
              case 'ID'
                val = obj.ID;
                % Interpolation
              case 'vertices'
                val = obj.vertices;
              case 'coefficients'
                val = obj.coefficients;
              case 'simplex_labels'
                val = obj.simplex_labels;
              otherwise
                error ('@NumHandle/get: invalid PROPERTY "%s"',prop);
            end
          end
          end %get

        function pout = set(obj,varargin)
          if (numel (varargin) < 2 || rem (numel(varargin),2) ~=0)
            error ('@NumHandle/set: expecting PROPERTY/VALUE pairs');
          end
          pout = obj;
          while (numel (varargin) > 1)
            prop = varargin{1};
            val = varargin{2};
            varargin(1:2) = [];
            if (~ ischar(prop))
              error ('@NumHandle/set : invalid PROPERTY for gMLCind class');
            end

            switch (prop)
                case 'matrix'
                    pout.matrix = val;
                case 'cost'
                    pout.cost = val;
                case 'control_law'
                    pout.control_law = val;
                case 'evaluation_time'
                    pout.evaluation_time = val;
                case 'description'
                    pout.description = val;
                case 'evaluation_order'
                    pout.evaluation_order = val;
                case 'ID'
                    pout.ID = val;
                % Interpolation
                case 'vertices'
                    pout.vertices = val;
                case 'coefficients'
                    pout.coefficients = val;
                case 'simplex_labels'
                    pout.simplex_labels = val;
              otherwise
                error ('@NumHandle/set: invalid PROPERTY for gMLCind class');
            end
          end
        end %set
    end

end %classdef
