function [x,y]=plot_progress(gMLC,plt)
% gMLC class plot_progress method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    BadValue = gMLC.parameters.BadValue;
    LW = 2;
    if nargin<2,plt=1;end

%% Individuals
    % Labels of evaluated individuals
    Indivs = gMLC.table.evaluated>0;
    labels = 1:gMLC.table.number;
    labels = labels(Indivs);

    % Order the evaluations chronologically
    Eval_order = NaN(length(labels),6);
    for p=1:length(labels)
        gMLC_ind = gMLC.table.individuals(labels(p));
        Eval_order(p,1:2) = gMLC_ind.evaluation_order;
        Eval_order(p,3) = gMLC_ind.cost{1}; % mean value of several evaluations
        Eval_order(p,4) = p;
        Eval_order(p,5) = generated_by(gMLC_ind.description.subtype);
        if gMLC_ind.cost{1} > BadValue/10% mean value of several evaluations
            Eval_order(p,5) = 7;
        end
        Eval_order(p,6) = gMLC_ind.ID;
    end
    % Sort individuals
%         to_plot = sortrows(Eval_order,[1,2]);
%         % remove .5 in cycle number
%         to_plot(:,1) = floor(to_plot(:,1));
        % if needed
        to_plot = Eval_order;
    
    % Costs
    Costs = to_plot(:,3);
    IDX = to_plot(:,4);
    IDS = to_plot(:,6);
    
    % Find the progression line
    best_ind = []; %length(labels);
    best_cost = []; %min(Costs);
    eval_num = length(labels);
    while eval_num>1
        [cmin,eval_num] = min(Costs(1:eval_num-1));
        best_ind = [best_ind,eval_num];
        best_cost = [best_cost,cmin];
    end

%% Plot
    % Data
    x = sort([best_ind,best_ind(1:end-1),length(labels)]);
    y = sort([best_cost,best_cost(1:end-1),best_cost(end)],'descend');
    
    % Split the data following the type of individuals
    MCInds = Eval_order(:,5)==0;MCInds(1)=1;
    RInds = Eval_order(:,5)==1;RInds(1)=1;
    CInds = Eval_order(:,5)==2;CInds(1)=1;
    EInds = Eval_order(:,5)==3;EInds(1)=1;
    SInds = Eval_order(:,5)==4;SInds(1)=1;
    MInds = Eval_order(:,5)==5;MInds(1)=1;
    CrInds = Eval_order(:,5)==6;CrInds(1)=1;
    BInds = Eval_order(:,5)==7;
    
    
    % Plot data
    if not(plt),return,end
    figure
    hold on
    P1=plot(IDX(MCInds),Costs(MCInds),'bo');
        P1.ZData = IDS(MCInds);
    P2=plot(IDX(RInds),Costs(RInds),'Marker','o','LineStyle','none','MarkerFaceColor',[1,0,1],'MarkerEdgeColor','none');
        P2.ZData = IDS(RInds);
    P3=plot(IDX(CInds),Costs(CInds),'Marker','o','LineStyle','none','MarkerFaceColor',0.9*[1,1,0],'MarkerEdgeColor','none');
        P3.ZData = IDS(CInds);
    P4=plot(IDX(EInds),Costs(EInds),'Marker','o','LineStyle','none','MarkerFaceColor',[1,0,0],'MarkerEdgeColor','none');
        P4.ZData = IDS(EInds);
    P5=plot(IDX(SInds),Costs(SInds),'Marker','o','LineStyle','none','MarkerFaceColor',[0,1,0],'MarkerEdgeColor','none');
        P5.ZData = IDS(SInds);
    P6=plot(IDX(MInds),Costs(MInds),'Marker','o','LineStyle','none','MarkerFaceColor',[0,0,0],'MarkerEdgeColor','none');
        P6.ZData = IDS(MInds);
    P7=plot(IDX(CrInds),Costs(CrInds),'Marker','o','LineStyle','none','MarkerFaceColor',[0,0,1],'MarkerEdgeColor','none');
        P7.ZData = IDS(CrInds);
        UpperBoundCost = max(Costs(not(BInds)))+zeros(sum(BInds),1);
    P8=plot(IDX(BInds),UpperBoundCost,'Marker','*','LineStyle','none','MarkerEdgeColor',[1,0,0]);
        if (sum(BInds)>0)
            P8.ZData = IDS(BInds);
        end
    plot(x,y,'r-','Linewidth',LW)
    hold off
    xlabel('Evaluations')
    ylabel('$J$','Interpreter','latex')
    set(gca,'yscale','log')
    grid on
    box on
    
    % legend
    if (sum(BInds)>0)
        legend('Monte Carlo','Reflection','Contraction','Expansion','Shrink','Mutation','Crossover','Bad')
    else
        legend('Monte Carlo','Reflection','Contraction','Expansion','Shrink','Mutation','Crossover')
    end
    
end %method

function val=generated_by(subtype)
switch subtype
    case 'no subtype'
        val=0;
    case 'reflected'
        val=1;
    case 'contracted'
        val=2;
    case 'expanded'
        val=3;
    case 'shrinked'
        val=4;
    case 'mutation'
        val=5;
    case 'crossover'
        val=6;
    otherwise
        error('Wrong type')
end
end
        


