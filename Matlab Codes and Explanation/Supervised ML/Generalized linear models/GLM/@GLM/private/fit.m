function [ fitted, fittedEta ] = fit( obj, xvar )
% Cocokkan valuas ke model GLM yang terestimasi.

% Ukuran observasi
N = size(xvar,1);

% TTransformasikan kembali ke awal
if ischar(obj.Link),
   linkinfo=['l',obj.Link];                     %File berisi link info
else
   linkinfo='lpower';                           %Link info kalo adalah power link 
end;

% Nama variabel X
if strcmp(obj.Intercept,'on') && ~any(sum(xvar) == N)
   x = [ones(N,1),xvar];
else
   x = xvar;
end;

% Setkan m ke ones 
m = ones(size(x));

% Kalkulasikan prediction linear.
if isempty(obj.O)
    o = zeros(N,1);
else
    o = obj.O;
end
       
% Cari prediktor linear
linpred = x*obj.Beta + o;

% Cocokkan nilai
fitted = feval(linkinfo,linpred,m,'mu');
fittedEta = linpred;

end

