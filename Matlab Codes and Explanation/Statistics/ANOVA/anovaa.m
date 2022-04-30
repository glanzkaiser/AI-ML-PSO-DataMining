clear all
close all

y = [414 377 326 273 449
434 493 337 299 472
500 521 348 323 485
412 373 225 248 371];

ropes = {'A','B','C','D','E'};

p = anova1(y,ropes);

boxplot(y, ropes, 'notch','on')
ylim([0 max(y(:))*1.1])
xlabel('Rope Type','FontSize',10,'FontWeight','bold')
ylabel('Breaking Strength (lb)','FontSize',12,'FontWeight','bold')