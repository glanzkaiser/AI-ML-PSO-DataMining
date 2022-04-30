function varargout = plotForecast(lme,newdata,xdata,group,removeddata)
% 

data = lme.Variables;
response = lme.ResponseName;
group_names = categories(data.(group));
c = hsv(numel(unique(group_names)));
[~,loc] = ismember(categories(newdata.(group)),group_names);

gscatter(data.(xdata),data.(response),data.(group),c,'.',20,'on');
hold on
gscatter(removeddata.(xdata),removeddata.(response),removeddata.(group),c(loc,:),'o',7,'off');
% gscatter(data.YR,data.log_GDP,data.(group),c,'o',5,'off');
legend(gca,group_names,'Location',[0.91 0.595 0.07 0.33])

[lme_pred,lmeCI] = predict(lme,newdata,'Prediction','observation');
newdata(:,response) = array2table(lme_pred);
gscatter(newdata.(xdata),newdata.(response),newdata.(group),c(loc,:),'*',5,'off');

new_groups = categories(newdata.(group));
for ii = 1:numel(new_groups)
    idx_grp = newdata.(group) == new_groups(ii);
    line(newdata(idx_grp,:).(xdata),lmeCI(idx_grp,1),'LineStyle','--','Color',c(loc(ii),:),'LineWidth',1);
    line(newdata(idx_grp,:).(xdata),lmeCI(idx_grp,2),'LineStyle','--','Color',c(loc(ii),:),'LineWidth',1);
end

if nargout == 1
    varargout{1} = newdata;
end

gridx = arrayfun(@(y)line([y,y],ylim,'Color',[0.95,0.95,0.95]),[min(data.(xdata))-1:max(newdata.(xdata))+3],'UniformOutput',false);
uistack([gridx{:}],'bottom')
gridy = arrayfun(@(x)line(xlim,[x,x],'Color',[0.95,0.95,0.95]),floor(min(data.(response))):0.5:ceil(max(newdata.(response))),'UniformOutput',false);
uistack([gridy{:}],'bottom')
set(gca,'FontSize',15,'xlim',[min(data.(xdata))-1, max(newdata.(xdata))+1])

end