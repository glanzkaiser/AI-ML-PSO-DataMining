function BaggedEnsemble = generic_random_forests(X,Y,iNumBags,str_method)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Description - Fungsi unruk menggunakan random forests
%
%
%	Output
%               BaggedEnsemble - ensemble of random forests
%               Plots of out of bag error
%
% Example -
%
%	 load fisheriris
% 	 X = meas;
%	 Y = species;
%	 BaggedEnsemble = generic_random_forests(X,Y,60,'classification')
%	 predict(BaggedEnsemble,[5 3 5 1.8])

%sintaksnya B = TreeBagger(NumTrees,X,Y,Name,Value)

BaggedEnsemble = TreeBagger(iNumBags,X,Y,'OOBPred','On','Method',str_method)

% plot plot out of bag prediction error
oobErrorBaggedEnsemble = oobError(BaggedEnsemble);
figID = figure;
plot(oobErrorBaggedEnsemble)
xlabel 'Jumlah tree';
ylabel 'Klasifikasi error';
print(figID, '-dpdf', sprintf('randomforest_errorplot_%s.pdf', date));

oobPredict(BaggedEnsemble)

% view trees
view(BaggedEnsemble.Trees{1}) % deksripsi text
view(BaggedEnsemble.Trees{1},'mode','graph') % deskripsi grafik
