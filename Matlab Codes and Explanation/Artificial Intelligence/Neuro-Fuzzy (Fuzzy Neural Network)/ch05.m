function chap05
% List of plots in chapter 5 of "Neuro-Fuzzy and Soft Computing".

%labels = str2mat(...
%    'Figure 2.1: mf_univ', ...
%    'Figure 2.2: lingmf', ...
%    'Figure 2.19: resolut');
%
%% Callbacks
%callbacks = str2mat(...
%    'genfig(''Figure 2.1''); mf_univ', ...
%    'genfig(''Figure 2.2''); lingmf', ...
%    'genfig(''Figure 2.19''); resolut');
%
%choices('Chapter 2', 'Plots for Chapter 2', labels, callbacks);

list = [...
    '#Figure 5.2: spring', ...
    '#Figure 5.4: transfor'];

[labels, callbacks] = list2cb(list);
choices('Chapter 5', 'Plots for Chapter 5', labels, callbacks, 1);
