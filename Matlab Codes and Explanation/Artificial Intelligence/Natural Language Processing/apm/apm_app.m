
function [app] = apm_app(server,name)

% nama model dengan  .apm extension
app_model = [name '.apm'];

% data file dengan .csv extension (optional)
app_data = [name '.csv'];

% nama aplikasi, gunakan nomor acak utk menolak konflik ip
app = [name '_' int2str(rand()*10000)];
app = lower(deblank(app));

% clear aplikasi sebelumnya
apm(server,app,'clear all');

% chec kmodel file yang ada (required)
if (~exist(app_model,'file')),
    disp(['Error: file ' app_model ' does not exist']);
    app = [];
    return
else
    % load model file
    apm_load(server,app,app_model);
end

% check jika data file data (optional)
if (exist(app_data,'file')),
    % load data file
    csv_load(server,app,app_data);
end
   