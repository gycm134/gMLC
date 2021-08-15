function update(gMLC)
% gMLC class update method
% Now the exhaustive help text
% descibing inputs, processing and outputs
%
% Guy Y. Cornejo Maceda, 11/14/2019
%
% See also SIN, COS, TheOtherFunction.

% Copyright: 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)
% CC-BY-SA

%% Parameters
    VERBOSE = gMLC.parameters.verbose;

%% Update properties
    % Complete facts if needed
    Facts = gMLC.history.facts;
    if not(isempty(Facts))
        CompletedFacts = NaN(size(Facts,1),1+gMLC.parameters.SimplexSize);
        CompletedFacts(:,1:(gMLC.parameters.SimplexSize+1)) = Facts(:,1:(gMLC.parameters.SimplexSize+1));
        gMLC.history.facts = CompletedFacts;
    end

end %method
