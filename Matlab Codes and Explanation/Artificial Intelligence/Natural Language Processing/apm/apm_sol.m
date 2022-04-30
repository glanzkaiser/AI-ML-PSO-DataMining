
function [y] = apm_sol(server,app)
app = lower(deblank(app));
filename = ['solution_' app '.csv'];
% get ip address for web-address lookup
ip = deblank(urlread_apm([deblank(server) '/ip.php']));
url = [deblank(server) '/online/' ip '_' app '/results.csv'];
response = urlread_apm(url);
% write solution.csv file
fid = fopen(filename,'w');
% sometimes we need a slight pause to avoid crashing
if fid==-1,
    pause(0.1);
    fid = fopen(filename,'w');
end
fwrite(fid,response);
fclose(fid);
% tranfer solution to local array
% load data from csv file with header on the right column
fid = fopen(filename, 'r');
% Parse and read rest of file
ctr = 0;
while(~feof(fid))
    aline = fgetl(fid);
    if ischar(aline)
        ctr = ctr + 1;
        A(ctr,:) = parse(aline, ',');
    else
        break;
    end
end
fclose(fid);
[n,m] = size(A);
for i = 1:n,
    for j = 2:m,
        A{i,j} = str2num(A{i,j});
    end
end
raw = A';

% extract names
y.names = raw(1,:);
% extract values
y.values = cell2mat(raw(2:end,:));
% number of variables
y.nvar = size(y.values,2);
% remove the following characters
c = '[],().';
nc = size(c,2);
% generate variable names as a structure
for i = 1:y.nvar;
    % remove some offending characters for MATLAB that
    %   are allowed in APM including: "[],()."
    var_name = y.names(i);
    for j = 1:nc,
         var_name = strrep(var_name, c(j), '');
    end
    str = ['y.x.' var_name{1} '= y.values(:,' int2str(i) ');'];
    eval(str);
end
