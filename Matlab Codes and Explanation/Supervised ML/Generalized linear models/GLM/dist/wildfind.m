function limits=wildfind(string,searchstr)
%pakai:    limits=wildfind(string, searchstr)
%   dimana limits adalah posisi seacrhstr  dalam  string

wildchar=findstr(searchstr,'*');

if length(wildchar)>1,
   error('hanya 1 wildcard (the ''*'' character) diikuti.');
end;

if isempty(wildchar),

   number=findstr(string,searchstr);
   limits=zeros(number,2);
   limits=[number', (number+length(searchstr)-1)'];

else

   str1=searchstr(1:wildchar-1);
   str2=searchstr(wildchar+1:length(searchstr));
   one=[findstr(string,str1),length(string)];
   two=findstr(string,str2);

   if length(one)==1, 
      limits=[];return;
   end;

   limits=zeros(length(two),2); %limit dari pencarian string

   for i=1:length(two),

      thisone=[];
      possibles=[];
      possibles=diff(one<two(i)); %kandidates untuk akhir dari searchstr
      thisone=[(possibles~=0),0];

      if ~isempty(one(logical(thisone))),
         limits(i,:)=[one(logical(thisone)),two(i)];
      end;

   end;

   %temukan 'gaps' dengan jarak min
   if ~isempty(limits),

      select=[1;diff(limits(:,1))];
      limits=limits(select>0,:);

   end;

end;

deleteme=[];

for i=1:size(limits,1),
   if limits(i,:)==zeros(size(limits(i,:))),

      deleteme=[deleteme;i];

   end;

end;

if ~isempty(deleteme), 
   limits(deleteme,:)=[]; 
end;
