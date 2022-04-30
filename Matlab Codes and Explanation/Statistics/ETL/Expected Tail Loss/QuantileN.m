
%Mengkuantil atau membuat penaksiran terhadap parameter
function y = QuantileN(u)
 y = sqrt(2) * erfinv(2*u-1);
end