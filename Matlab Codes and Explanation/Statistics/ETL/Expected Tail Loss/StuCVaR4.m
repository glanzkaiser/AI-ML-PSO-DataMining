
function y = StuCVaR4(x)
% Metode utk compute CVaR dengan 4 derajad kebebasan
    f = @(t,n) -(n^(n-2)*(n+t.^2).^(.5-.5*n)*gamma(.5*(n-1))/(2*sqrt(pi)*gamma(.5*n)));
    arg = InverseCDF4(x);
    y = 1 / sqrt(2)*f(arg,4)./x;
end

