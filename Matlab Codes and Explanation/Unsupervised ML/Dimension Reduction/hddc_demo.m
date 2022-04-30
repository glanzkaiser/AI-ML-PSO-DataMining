% High Dimensionality Reduction Clustering (demonstration)


fprintf('\n- Loading data\n')
fprintf('load(''crabs.mat'');\n')
load('crabs.mat'  );
fprintf('\n- Tekan keyboard utk melanjutkan ...\n\n'), pause()

fprintf('- Mencari model dengan nilai (k=4 groups)\n')
fprintf('[prms,T,cls] = hddc_learn(X,4,''model'',''best'',''seuil'',0.2);\n')
[prms,T,cls] = hddc_learn(X,4,'model','best','seuil',0.2);
fprintf('\n- Tekan keyboard utk melanjutkan ...\n\n'), pause()

fprintf('-Pembelajaran parameter dari model spesifik\n')
fprintf('[prms,T,cls] = hddc_learn(X,4,''model'',''AiBQiDi'',''seuil'',0.2)\n');
[prms,T,cls] = hddc_learn(X,4,'model','AiBQiDi','seuil',0.2);