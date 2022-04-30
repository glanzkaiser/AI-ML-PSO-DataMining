

%% Import the data
[~, ~, raw0_0] = xlsread('.\publicdata.xlsx','publicdata','A2:A817');
[~, ~, raw0_1] = xlsread('.\publicdata.xlsx','publicdata','C2:C817');
[~, ~, raw0_2] = xlsread('.\publicdata.xlsx','publicdata','N2:N817');
raw = [raw0_0,raw0_1,raw0_2];
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,1);
raw = raw(:,[2,3]);

%% buat variabel output
data = reshape([raw{:}],size(raw));

%% buat table
publicdata = table;

%% alokasikan array import ke variabel nama
publicdata.STATE = cellVectors(:,1);
publicdata.YR = data(:,1);
publicdata.GDP = data(:,2);

%% hapus variabel temporary
clearvars data raw raw0_0 raw0_1 raw0_2 cellVectors;