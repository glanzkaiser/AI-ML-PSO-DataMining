function [Y, s] = normalize(X, dim)
% normalisasi vektie untuk dijumlahkan
%   By default dim = 1 (columns).
if nargin == 1, 
    % jumlah dimensi mana yang dipakai
    dim = find(size(X)~=1,1);
    if isempty(dim), dim = 1; end
end
s = sum(X,dim);
Y = bsxfun(@times,X,1./s);