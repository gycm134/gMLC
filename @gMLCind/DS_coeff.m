function DS_coeff(gMLC_ind,gMLC_table,type,IDX)
% gMLC class DS_coeff method
% Computes the linear combination of the Individuals by adjusting the
% coefficients of the individuals in the simplex
% type is for the type of interpolation (reflection, expansion...)
% IDX is for the index of the shrinked individual
%
% Guy Y. Cornejo Maceda, 07/18/209
%
% See also SIN, COS, TheOtherFunction.

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters
	simplex_labels = gMLC_ind.simplex_labels;
    BS = size(simplex_labels,1);
    OutputNumber = size(gMLC_table.individuals(simplex_labels(1)).control_law,1);

%% Initialization
   % Build M0 matrix (1: vertices, 2 coefficients
        % Extract vertices
        AllV = [];
        M0c = cell(BS,2);
        for p=1:BS
           M0c{p,1} = gMLC_table.individuals(simplex_labels(p)).vertices;
           M0c{p,2} = gMLC_table.individuals(simplex_labels(p)).coefficients;
           AllV = [AllV;M0c{p,1}];
        end
        AllV = sort(unique(AllV)); NV=length(AllV);
        % Matrix M0
        M0 = zeros(NV,BS);
        % Fill M0
        for p=1:BS
            mV = M0c{p,1};
            mC = M0c{p,2};
            for q=1:length(mV)
                M0(AllV==mV(q),p) = mC(q);
            end
        end

   % Build (M0)control_laws according to XV0, matrix of vertices corresponding to M0
   	control_laws = cell(OutputNumber,NV);
    for p=1:NV
       control_laws(:,p) = gMLC_table.individuals(AllV(p)).control_law;
    end

   % Centroid vector
	C0 = ones(BS,1)/(BS-1); C0(end) = 0;

   % Last indiv vector
	N = zeros(BS,1); N(end) = 1;

   % Coefficient matrix
    Cn = transpose(M0);

   % L1
	L1 = Cn(1,:);

%% Type of individual
   switch type
	case 1 % reflection
		coef = transpose(2*C0-N)*Cn;
	case 2 % expand
		coef = transpose(3*C0-2*N)*Cn;
	case 3 % contraction
		coef = transpose(C0+N)*Cn/2;
	case 4 % shrink
		Li = Cn(IDX,:);
		coef = (L1+Li)/2;
	otherwise
		error('Wrong type (DS_coeff)')
   end

%% Build control law
    % remove the zeros in the coef vector!
    [~,IC,Val] = find(coef);

	% interpolate the control laws
	control_law = interp_cl(control_laws(:,IC),Val);

%% Update properties
   gMLC_ind.control_law = control_law;
   gMLC_ind.coefficients = Val;
   gMLC_ind.vertices = AllV(IC);
   gMLC_ind.description.type = 'coef DS';
end %method
