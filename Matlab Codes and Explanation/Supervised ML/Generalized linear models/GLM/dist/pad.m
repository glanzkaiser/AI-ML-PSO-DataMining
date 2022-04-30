function out=pad(in,l,how)

if nargin<3, 
   how=-1; 
end;

if how>0, 
   how=1; 
end;

cellflag=0;

if iscell(in), 

   in=char(in); 
   cellflag=1; 

end;

out=[];
for i=1:size(in,1)

   add=blanks( l-size(in(i,:),2) );

   if how<0,
      outl=[add(ones(1,size(in(i,:),1)),:),in(i,:)];
   else
      outl=[in,add(ones(1,size(in(i,:),1)),:)];
   end;

   out=[out;outl];

end;

%buat output sebuah cell array kalau input adalah cell array
if logical(cellflag), 
   out=cellstr(out); 
end;
