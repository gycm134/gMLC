function gMLC_history=add_fact(gMLC_history,gMLC_parameters,fact,whoo)
% gMLChistory class add_fact method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC_parameters.verbose;
    BS = gMLC_parameters.SimplexSize;

if VERBOSE > 3, fprintf(' Update history...'),end

%% Fact number
    Nf = length(gMLC_history.facts)+1;
    New_fact = NaN(1,BS+1);

%% Change properties
switch fact
    case 0 % Initilization
        New_fact(1)=0;
        gMLC_history.cycle(1)=0;
        % Exploitation step (Downhill simplex)
    case 10
        New_fact(1) = 10;
    case 11 % reflect
        New_fact(1) = 11;
    case 12 % single contraction
        New_fact(1) = 12;
    case 13 % expand
        New_fact(1) = 13;
    case 14 % shrink
        New_fact(1) = 14;
    case 21 % Random
        New_fact(1) = 21;
    case 3

    case 4 % 'Monte Carlo'
        New_fact(1)=-1;
    case 5 % 'Downhill Simplex'
        New_fact(1)=-2;
    case 6
        New_fact(1)=6;
    case Inf
        New_fact(1) = Inf;
        if VERBOSE > 3, fprintf(' Done\n'),end
        return
    case -Inf
        New_fact(1) = -Inf;
        if VERBOSE > 3, fprintf(' Done\n'),end
        return
    case 123 % from complete % No longer used (for simplex stuff)
        New_fact(1) = 123;
    otherwise
        error('Wrong fact to add in history (add_fact)');
end

%% Update properties
    New_fact(2:end) = whoo;
    gMLC_history.facts = vertcat(gMLC_history.facts,New_fact);

if VERBOSE > 3, fprintf(' Done\n'),end


end %method
