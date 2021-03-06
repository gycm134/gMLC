classdef MLC < handle
    % MLC MLC object constructor
    % It contain the properties : population (table of individual labels),
    % parameters, table (data base), generation (integer).
    % To initiliaze a MLC object in the variable mlc: mlc = MLC;
    % The default parameters are loaded.
    % To use other parameters, create a my_problem_parameters.m file and load it
    % with the  command : mlc = MLC('my_problem');
    % To run some generations, use the method go.
    %
    % Guy Y. Cornejo Maceda, 01/24/2020
    %
    % See also go, @MLC/save, @MLC/load.

    % Copyright: 2020 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
    % CC-BY-SA

    %% Properties
    properties
        % Generations
            population
        % Parameters
            parameters
        % Data base
            table
        % Indicator
            generation
        % Version
            version='0.9.7.4';
    end %properties

    %% External methods
    methods
        % Main
            obj = go(obj,gen);
        % Save/Load
            obj=load_matlab(obj,Name,AuxName);
            obj=load_octave(obj,Name,AuxName);
            save_matlab(obj,AuxName);
            save_octave(obj,AuxName);
            obj = load_old(obj,folder,str);
            rename(obj,NewName);
        % Visualizations
            spectrogram(MLC);
            [x,y] = convergence(MLC,ParetoFront,plt);
            genoperatorsdistrib(MLC);
            IndivID = relationship(MLC);
            plotindiv(MLC,Idx);
            printfigure(MLC,FigureName);
        % Population related methods
            generate_population(obj);
            evaluate_population(obj,gen);
            evolve_population(obj);
        % External evaluation
            obj = complete_evaluation(obj,gen,matJ);
            external_evaluation(obj,gen);
            expe_create_control_select(obj,gen,IND);
            expe_create_control_solo(obj,gen,IND);
            expe_create_control_time(obj,gen,IND);
        % Individual related methods
            b=best_individual(MLC,gen,visu);
            output=best_individuals(MLC,gen,Nbest);
            give(MLC,GEN,IND)
            chromosome(MLC,GEN,IND)
        % Print
            show_problem(obj);
            CL_descriptions(obj,gens);
            CL_evolution(obj,sens);
        % import individuals gMLC
            obj = import(obj,indivs);
    end

    %% Internal methods
    methods
        % Constructor
        function obj = MLC(new_parameters,verbose)
            if nargin<2
                verbose=5;
            end
            % Create folders
                % Save runs
                if not(exist('save_runs','dir')),mkdir('save_runs');end
                if not(exist('save_runs/tmp','dir')),mkdir('save_runs/tmp');end
            % Add path
                addpath('save_runs/tmp');
            % Construct   
            if nargin < 1
                obj.parameters = default_parameters;
            else
                eval(['obj.parameters =',new_parameters,'_parameters;']);
            end
            obj.table = MLCtable(obj.parameters);
            obj.generation = 0;
            obj.parameters.verbose=verbose;
            if verbose>4
                obj.show_problem;
            end
        end

        %     function display(obj)
        %       printf ('%s = ', inputname (1));
        %       printf ('\n');
        %       printf('  population')
        %       printf ('\n');
        %       printf('  parameters')
        %       printf ('\n');
        %     endfunction

        % Get method
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
                    case 'population'
                        val = obj.population;
                    case 'parameters'
                        val = obj.parameters;
                    case 'table'
                        val = obj.table;
                    case 'generation'
                        val = obj.generation;
                    case 'version'
                        val = obj.version;
                    otherwise
                        error ('@NumHandle/get: invalid PROPERTY "%s"',prop);
                end
            end
        end %get

        % Set method
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
                    case 'population'
                        pout.population = val;
                    case 'parameters'
                        pout.parameters = val;
                    case 'table'
                        pout.table = val;
                    case 'generation'
                        pout.generation = val;
                    case 'version'
                        pout.version = val;
                    otherwise
                        error ('@NumHandle/set: invalid PROPERTY for MLC class');
                end
            end
        end %set
    end %methods

end %classdef
