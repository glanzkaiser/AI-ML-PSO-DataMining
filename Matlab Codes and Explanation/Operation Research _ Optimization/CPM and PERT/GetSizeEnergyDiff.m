function out=GetSizeEnergyDiff(cells, c, nb_c)

global LAM_AREA

e_area=0;
if c>0
    e_area = e_area + LAM_AREA*(1 - 2*cells.area(c) + 2*cells.target_area(c));
end
if nb_c>0
    e_area = e_area + LAM_AREA*(1 + 2*cells.area(nb_c) - 2*cells.target_area(nb_c));
end

out = e_area;

end