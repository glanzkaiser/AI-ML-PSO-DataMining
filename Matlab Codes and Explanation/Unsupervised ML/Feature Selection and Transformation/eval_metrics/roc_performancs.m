function [ prec, recall, fpr, AUCroc, Acc, F1_accuracy, F1_Precision, F1_Recall ] = roc_performancs( labels, scores , plot_flag)


[Xfpr,Ytpr,~,AUCroc]  = perfcurve(double(labels), double(scores), 1,'TVals','all','xCrit', 'fpr', 'yCrit', 'tpr');
[Xpr,Ypr,~,AUCpr] = perfcurve(double(labels), double(scores), 1, 'TVals','all','xCrit', 'reca', 'yCrit', 'prec');
[acc,~,~,~] = perfcurve(double(labels), double(scores), 1,'xCrit', 'accu');

prec = Ypr; prec(isnan(prec))=1;
tpr = Ytpr,1; tpr(isnan(tpr))=0;% recall = true positive rate
fpr = Xfpr; % (1 - Specificity)
recall = tpr;

% Compute F-Measure
f1= 2*(prec.*tpr) ./ (prec+tpr);
[Max_F1,idx] = max(f1);
F1_Precision = prec(idx);
F1_tRecall = tpr(idx);
F1_accuracy = acc(idx);

if plot_flag
    figure;
    subplot(1,2,1)
    plot([tpr], [ prec], '-b', 'linewidth',2); % add pseudo point to complete curve
    xlabel('recall');
    ylabel('precision');
    grid on
    title(['precision-recall ']);
    
    subplot(1,2,2)
    plot([fpr], [tpr], '-r', 'linewidth',2); % add pseudo point to complete curve
    xlabel('false positive rate');
    ylabel('true positive rate');
    grid on
    title(['ROC curve']);
end

AUCroc = 100*AUCroc; % Area Under the ROC curve
Acc = 100*sum(labels == sign(scores))/length(scores); % Accuracy


end

