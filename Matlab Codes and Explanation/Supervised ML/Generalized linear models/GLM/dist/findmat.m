function [where,ind]=findmat(instr, searchstr)
%FINDMAT menemukan dimana searchstr terjadi dalam (matrix)  instr
%pakai:  [where,ind]=findmat(instr, searchstr)
% 
%check error
if size(searchstr,1)>1, 
   error('Can only search for one-line strings!');
end;

ind=zeros(size(instr,1),1);

if size(instr,1)==1, 

   if strcmp(searchstr,blanks(length(searchstr))),
      padchar='%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%';
      padchar=[padchar,padchar,padchar];
   else
      padchar=blanks(100);
   end;

   ins=[instr,padchar];

   %memastikan searchstr dicari
   where=findstr(ins,searchstr);

   if ~isempty(where), 
      ind=length(where); 
   end;

   where=mmat2str(where);

else

   where=[];

   if strcmp(searchstr,blanks(length(searchstr))),

      padchar='%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%';
      padchar=[padchar,padchar,padchar];

   else

      padchar=blanks(100);

   end;

   for i=1:size(instr,1), 

      ins=[instr(i,:),padchar];
      ok=findstr(ins,searchstr);
      ind(i)=length(ok);
      where=str2mat(where, mmat2str( ok ));

   end;

   if ~isempty(where), 
      where(1,:)=[]; 
   end;

end;

%%%SUBFUNCTION mmat2str
function outstr=mmat2str(matrix)
%pakai  outstr=mmat2str(matrix)
%     dimana matrix adalah matrik yang diubah ke string
%            outstr adalah string resultan


if isstr(matrix), 
   outstr=matrix;
   return;
end;

[rows, cols] = size(matrix);
if rows*cols ~= 1, 
   outstr = '['; 
else 
   outstr = ''; 
end;

for i=1:rows,

   for j=1:cols,

      %setiap kasus yang dari awal
      if matrix(i,j) == Inf,
         outstr=[outstr,'Inf'];
      elseif matrix(i,j) == -Inf,
         outstr=[outstr,'-Inf'];
      else
         outstr=[outstr,sprintf('%.15g',real(matrix(i,j)))];

         %kompleks kan entries
         if imag(matrix(i,j))<0,
            outstr=[outstr,'-i*',sprintf('%.15g',abs(imag(matrix(i,j))))];
         elseif(imag(matrix(i,j)) > 0)
            outstr=[outstr,'+i*',sprintf('%.15g',imag(matrix(i,j)))];
         end;

      end;
      outstr=[outstr ' '];

   end;

   l=length(outstr); 
   outstr(l:l+1)='; '; %baris selesai

end;

if rows==0, 	%kosongkan case
   outstr=[outstr,'  ']; 
end;

l=length(outstr);

if rows*cols ~= 1
   outstr(l-1)=']';
   outstr(l)=[];
else    
   outstr(l-1:l)=[];
end;
