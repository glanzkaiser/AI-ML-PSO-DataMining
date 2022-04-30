function [Population] = ClearDups(Population, MaxParValue, MinParValue)

for i = 1 : length(Population)
    Chrom1 = sort(Population(i).chrom);
    for j = i+1 : length(Population)
        Chrom2 = sort(Population(j).chrom);
        if isequal(Chrom1, Chrom2)
            parnum = ceil(length(Population(j).chrom) * rand);
            Population(j).chrom(parnum) = floor(MinParValue(parnum)...
                + (MaxParValue(parnum) - MinParValue(parnum) + 1) * rand); 
        end
    end
end
return;