function dists=distlist(fname)
%DISTLIST menghasilkan list error distribusi yang ada di glmlab
%pakai:  dists=distlist(fname)
%   dimana  fname  adalah nama file yang dibaca
%          dists  adalah list;

if strcmp(computer,'PCWIN'),
   fid=fopen(fname,'r');
else
   fid=fopen(fname,'rt');
end;

dists=[];

while ~feof(fid),
   dists=str2mat(dists,fgetl(fid));
end;

for i=1:size(dists,1),

   d=dists(i,:);
   d=strrep(d,'.m','  ');
   dd(i)=strcmp(d,blanks(length(d)));
   ddd(i)=~strcmp(d(1),'d');
   d(1)=' ';
   dists(i,:)=d;

end;

dists((dd|ddd),:)=[];
fclose(fid);
