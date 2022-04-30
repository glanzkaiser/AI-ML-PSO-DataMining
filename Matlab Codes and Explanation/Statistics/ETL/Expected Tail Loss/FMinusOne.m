
function y = FMinusOne( x,n )
    if(x < .5)
        arg = 2 * x;
    else
        arg = 2*(1-x);
    end
    
    y = sign(x-.5) .* sqrt(n*(1./betaincinv(arg,n/2,.5)-1));
end

