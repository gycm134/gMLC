classdef gMLC < handle
% gMLC class definition
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Properties
properties
    % Parameters
        parameters
    % Sets
        simplex % simplex set
        landscape_labels
    % Data base
        table
    % Plot
        history
    % Version
        version='0.1.1';
end

%% External methods
methods
    % Cycles
        go(obj,gen);
        show_status(obj);
        crit = criterion(gMLC);
        new_cycle(obj,N);
    % Steps
        obj = step_initialization(obj); % Creation of the sets
        obj = step_exploitation(obj); % Downhill simplex step
        obj = step_evolution(obj); % Genetic programming step
        obj = step_end(obj,NCYCLE); % Convergence criterion
    % Different initializations
        obj = monte_carlo(obj);
        obj = downhill_simplex_initialization(obj);
    % Save/Load
        save(obj);
        obj = load(obj,Name);
        obj = reName(obj,NewName);
    % Visualizations
        show_problem(obj);
        show(obj,plt);
        [x,y] = plot_progress(obj,plt);
        export_figures(obj);
        export_figures_prior(obj);
    % Plot control law
        plot(obj,ID);
        plot_control_law(obj,control_law);
    % Give information concerning individuals
        give(obj,IDs);
        best_individuals(obj,Iend);
    % Interpolation
        interpolation_quality(gMLC);
    % External evaluation
        export_set_EXE(obj,opti_type)
        send_to_EXE(obj,labels,opti_type);
        complete_EXE(obj,opti_type,matJ);
        interpolate_simplex(obj,IDX);
        complete_REC_S_EXE(obj,opti_type);
        after_REC_EXE(obj)
        expe_create_control_select(obj,IND);
        expe_create_control_ID_select(obj,IND);
    % Landscape
        PopulationLabels = build_evolution_set(obj);
        LandscapeLabels = landscape_description(obj);
    % Importation
        obj = import(obj,objSource,NImports);
    % Update
        update(obj);
    % Non-matrix -> matrix
        PopulationLabels = ReplaceNMIndividuals(obj,PopulationLabels);
end

%% Internal methods
methods
    % Constructor
    function obj = gMLC(new_parameters)
        % Load parameters
            if nargin < 1
                obj.parameters = default_parameters;
            else
                eval(['obj.parameters =',new_parameters,'_parameters;']);
            end

        % Properties initialization
            obj.simplex = gMLCsimplex(obj.parameters);
            obj.landscape_labels = [];
            obj.table = gMLCtable(obj.parameters);
            obj.history = gMLChistory;
            obj.show_problem;
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
          case 'parameters'
            val = obj.parameters;
          case 'simplex'
            val = obj.simplex;
          case 'landscape_labels'
            val = obj.landscape_labels;
          case 'table'
            val = obj.table;
          case 'history'
            val = obj.history;
          case 'version'
             val = obj.version;
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
          error ('@NumHandle/set : invalid PROPERTY for gMLC class');
        end

        switch (prop)
            case 'parameters'
                pout.parameters = val;
            case 'simplex'
                pout.simplex = val;
            case 'landscape_labels'
                pout.landscape_labels = val;
            case 'table'
                pout.table = val;
            case 'history'
                pout.history = val;
            case 'version'
                pout.version = val;
          otherwise
            error ('@NumHandle/set: invalid PROPERTY for gMLC class');
        end
      end
    end %set

end

end %classdef
