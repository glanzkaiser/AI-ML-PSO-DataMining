function s=mystrrep(s1,pos,s3)
%MYSTRREP gantikan strings
%pakai    s=mystrrep(s1,pos,s3) gantikan s1(pos) dengan s3.
%         pos adalah vektor dari posisi dalam s1 ke s3

if (pos>length(s1))|(pos<1),
   error('Can''t replace a position that doesn''t exist!');
end;

s=s1;
pos=sort(pos);
tpos=pos;
delta=0;

for i=1:length(pos),

   s=[s(1:tpos(i)-1),s3,s(tpos(i)+1:length(s))];
   delta=delta+length(s3)-1;tpos=pos+delta;

end;
