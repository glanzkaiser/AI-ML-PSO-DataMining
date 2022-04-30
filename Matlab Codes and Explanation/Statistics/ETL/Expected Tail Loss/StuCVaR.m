function y = StuCVaR(x,n)
% Metode utk compute CVaR utk n derajat kebebasan
    f = @(t,n) -(n^(n-2)*(n+t.^2).^(.5-.5*n)*gamma(.5*(n-1))/(2*sqrt(pi)*gamma(.5*n)));
    arg = FMinusOne(x,n);
    y = sqrt((n-2) / n) * f(arg,n)./x;
end

