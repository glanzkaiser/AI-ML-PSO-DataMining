function varargout = plotIntervals(Table,Formula,group)
% 

Table.(group) = removecats(Table.(group));
grp = categories(Table.(group));
n_grp = 1:numel(grp);

s1 = subplot(1,2,1);
s2 = subplot(1,2,2);

beta0 = zeros(numel(grp),1);
beta1 = zeros(numel(grp),1);

for ii = n_grp
    lm_seperate = fitlm(Table(Table.(group) == grp(ii),:),Formula);
    estimates = lm_seperate.Coefficients.Estimate';
    beta0(ii) = estimates(1);
    beta1(ii) = estimates(2);
    CI = reshape(coefCI(lm_seperate)',1,4);
    
    set(gcf,'CurrentAxes',s1)
    line(beta0(ii),numel(grp)+1-ii,'Marker','+','MarkerSize',15,'MarkerEdgeColor',[0.7,0.7,0.7]);
    line(CI(1:2), [numel(grp)+1-ii,numel(grp)+1-ii],'LineStyle','-','Color',[0 0.6 1],'LineWidth',3);    
        
    set(gcf,'CurrentAxes',s2)
    line(beta1(ii),numel(grp)+1-ii,'Marker','+','MarkerSize',15,'Color',[0.7,0.7,0.7]);
    line(CI(3:4), [numel(grp)+1-ii,numel(grp)+1-ii],'LineStyle','-','Color',[1 0 0.4],'LineWidth',3);
end

set(gcf,'CurrentAxes',s1)
xl = xlim;
set(s1,'YTick',n_grp, 'YTickLabel',grp,'FontSize',10,'Box','on','ylim',[0, numel(grp)+1]);
title('Intercept','FontSize',15)
gridy = arrayfun(@(x)line(xl,[x,x],'Color',[0.7,0.7,0.7]),n_grp,'UniformOutput',false);
uistack([gridy{:}],'bottom')
xlim(xl)

set(gcf,'CurrentAxes',s2)
xl = xlim;
set(s2,'YTick',n_grp,'YTickLabel',grp,'FontSize',10,'Box','on','ylim',[0, numel(grp)+1]);
title('Slope','FontSize',15)
gridy = arrayfun(@(x)line(xl,[x,x],'Color',[0.7,0.7,0.7]),n_grp,'UniformOutput',false);
uistack([gridy{:}],'bottom')
xlim(xl)
% 
linkaxes([s1,s2],'y')

if nargout ~= 0
   varargout{1} = beta0;
   varargout{2} = beta1;
end