function interpolation_quality(gMLC)
% gMLC class interpolation_quality method
%
%	Copyright (C) 2019 Guy Cornejo Maceda (gy.cornejo.maceda@gmail.com)

%% Parameters
    VERBOSE = gMLC.parameters.verbose;
    number = gMLC.table.number;
    
%% Extract interpolated individuals
    % Initialization
    quality = NaN(number,1);
    indiv_type = NaN(number,3);
    
    % Loop
    for p=1:number
        type = gMLC.table.individuals(p).description.type;
        if strcmp(type,'interpolated')
            indiv_desc = gMLC.table.individuals(p).description;
            quality(p) = indiv_desc.quality;
            switch indiv_desc.subtype
                case 'centroid'
                    indiv_type(p,:) = [0.4940 0.1840 0.5560];
                case 'reflected'
                    indiv_type(p,:) = [1,0,1]; %magenta
                case 'contracted'
                    indiv_type(p,:) = 0.9*[1,1,0]; % yellow
                case 'expanded'
                    indiv_type(p,:) = [1,0,0]; % red
                case 'shrinked'
                    indiv_type(p,:) = [0,1,0]; % green
            end
        end
    end
    
    % Post process
    quality(isnan(quality))=[];
    indiv_type(isnan(indiv_type(:,1)),:)=[];
    
%% Plot
figure
x=1:length(quality);
for p=x
    hold on
    plot(p,quality(p),'Marker','o','MarkerFaceColor',indiv_type(p,:),'MarkerEdgeColor',[0,0,0])
    hold off
end
    % Additional stuff
    set(gca,'yscale','log')
    ylabel('$J$','Interpreter','latex')
    grid on
    box on

    % legend
    hold on
    leg1(1) = plot(NaN,NaN,'Marker','o','MarkerFaceColor',[0.4940 0.1840 0.5560],'MarkerEdgeColor',[0,0,0],'LineStyle','none');
    leg1(2) = plot(NaN,NaN,'Marker','o','MarkerFaceColor',[1,0,1],'MarkerEdgeColor',[0,0,0],'LineStyle','none');
    leg1(3) = plot(NaN,NaN,'Marker','o','MarkerFaceColor',0.9*[1,1,0],'MarkerEdgeColor',[0,0,0],'LineStyle','none');
    leg1(4) = plot(NaN,NaN,'Marker','o','MarkerFaceColor',[1,0,0],'MarkerEdgeColor',[0,0,0],'LineStyle','none');
    leg1(5) = plot(NaN,NaN,'Marker','o','MarkerFaceColor',[0,1,0],'MarkerEdgeColor',[0,0,0],'LineStyle','none');
    leg2 = {'centroid','reflected','contracted','expanded','shrinked'};
    legend(leg1(2:end),leg2(2:end))
    hold off
    
end %method
