function doubleup=RPEATSTR(strmat)
%RPEATSTR temukan occurence yang diulang dalam string matrix

lstrmat=size(strmat,1);
doubleup=zeros(lstrmat,1);

for i=1:lstrmat-1,

   for j=i+1:lstrmat,

      if strcmp(deblank(strmat(i,:)),deblank(strmat(j,:))),
         doubleup(j)=1;
      end;

   end;

end;
