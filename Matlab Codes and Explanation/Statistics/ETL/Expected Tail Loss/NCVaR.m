
function y = NCVaR(x)
% Metode umum utk compute CVAR buat Gaussian
    arg = QuantileN(x);
    y = - exp(-arg.^2/2)/sqrt(2*pi)./x;
end

