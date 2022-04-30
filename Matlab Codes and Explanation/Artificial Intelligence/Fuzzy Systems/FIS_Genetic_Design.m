% jalankan FIS dengan hasil optimasi genetika

Generated_FIS_Name = input('Enter the initial FIS name: ','s');
genfuzinfsys=readfis(Generated_FIS_Name);

for i=1:1:length(genfuzinfsys.input)
    genfuzinfsys.input(i).range(2)=genfuzinfsys.input(i).range(2)+dist;
    genfuzinfsys.input(i).range(1)=genfuzinfsys.input(i).range(1)-dist;
end
delta_name = input('Enter the name of the tuned-parameter array: ','s');
delta = eval(delta_name);

delta_num=0;
for i=1:1:length(genfuzinfsys.input)
    for j=1:1:length(genfuzinfsys.input(i).mf)
        delta_num = delta_num + 1;
        genfuzinfsys.input(i).mf(j).params(1)=genfuzinfsys.input(i).mf(j).params(1)+delta(delta_num);
        delta_num = delta_num + 1;
        genfuzinfsys.input(i).mf(j).params(2)=genfuzinfsys.input(i).mf(j).params(2)+delta(delta_num);
       
        genfuzinfsys.input(i).mf(j).params(3)=genfuzinfsys.input(i).mf(j).params(3)+delta(delta_num);
        delta_num = delta_num + 1;
        genfuzinfsys.input(i).mf(j).params(4)=genfuzinfsys.input(i).mf(j).params(4)+delta(delta_num);
    end

end

AddConvert_2 % alasan utk pake kalkulasi redundant utk menyiapkan compatibility between antara submission
             % dan project besar

Save_FIS=input('Enter the final FIS name: ','s');
writefis(genfuzinfsys,Save_FIS);
Save_MAT=[Save_FIS,'.mat'];
save(Save_MAT);
