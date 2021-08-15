function show_status(gMLC)
% gMLC class show_status method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    Name = gMLC.parameters.Name;
    
%% Print
    fprintf([' Name of the run : ',Name,'\n'])
    number_evaluated = sum(gMLC.table.evaluated>0);
    fprintf(' Number of evaluation : %i\n',number_evaluated)

end %method
