
%% Import data
[~, ~, raw0_0] = xlsread('.\publicdata.xlsx','publicdata','A2:J817');
[~, ~, raw0_1] = xlsread('.\publicdata.xlsx','publicdata','N2:N817');
raw = [raw0_0,raw0_1];
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,1);
raw = raw(:,[2,3,4,5,6,7,8,9,10,11]);

%% buat variabel output
data = reshape([raw{:}],size(raw));

%% buat table
publicdata = table;

%% alokasi array import ke variabel nama
publicdata.STATE = cellVectors(:,1);
publicdata.REGION = data(:,1);
publicdata.YR = data(:,2);
publicdata.PUB_CAP = data(:,3);
publicdata.HWY = data(:,4);
publicdata.WATER = data(:,5);
publicdata.UTIL = data(:,6);
publicdata.PVT_CAP = data(:,7);
publicdata.EMP = data(:,8);
publicdata.UNEMP = data(:,9);
publicdata.GDP = data(:,10);

%% hapus variabel temp
clearvars data raw raw0_0 raw0_1 cellVectors;