function a = readmylisp_to_evaluate(expression,MLC_parameters,to_export)
    % READMYLISP_TO_EVALUATE translates a lisp expression in a MATLAB string expresion.
    %
    %
    % See also read, mat2lisp, simplify_my_LISP.

    % Copyright (C) 2015-2019 Thomas Duriez.
    % This file is adapted from MLC_tools/readmylisp_to_formal_MLC.m of the OpenMLC-Matlab-2 Toolbox. Distributed under GPL v3.


%% Arguments
    if nargin<3,to_export = 0;end

%% Core
if isempty(expression)
    a = [];
    return
end

if nargin>1

end

ops = opset(min(MLC_parameters.ControlLaw.OperatorIndices):max(MLC_parameters.ControlLaw.OperatorIndices),to_export);

expr = expression;
fvig = find(expr == ' ');
if isempty(fvig)
    if expr(1) == '-'
        a = ['(' expr ')' ];
    else
        a = expr;
    end

else
    op = expr(2:fvig(1)-1);

    stru = [find(((cumsum(double(double(expr)=='('))-cumsum(double(double(expr)==')'))).*double(double(expr==' '))==1)) length(expr+1)];
    a = 0;

    for i = 1:length(ops)
        if strcmp(ops(i).op,op)
            a = ops(i).litop;
            for j=1:ops(i).nbarg
                a = strrep(a,['arg' num2str(j)], readmylisp_to_evaluate(expression(stru(j)+1:stru(j+1)-1),MLC_parameters,to_export));
            end
        end
    end

end
