function y = InverseCDF4(x)
    ra = sqrt(1-4*(x-.5).^2);
    y = 2 * sign(x-.5).*sqrt(cos(1/3 * acos(ra))./ra-1);
end

