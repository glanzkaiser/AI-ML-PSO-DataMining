function x = discreteRnd(p, n)
% Sample utk distribusi diskrit (multinomial).
% Input:
%   p: k dimensional probability vector
%   n: jumlah sample
% Output:
%   x: k x n generated samples x~Mul(p)
if nargin == 1
    n = 1;
end
r = rand(1,n);
p = cumsum(p(:));
[~,x] = histc(r,[0;p/p(end)]);
