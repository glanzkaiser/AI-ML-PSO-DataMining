function out=cel2lstr(in)


if isempty(in), 
   out=in; 
   return; 
end;

if isstr(in),

   out=deblank(in(1,:));
   for i=2:size(in,1),
      out=[out,',',deblank(in(i,:))];
   end;

elseif ~iscellstr(in), 

%   error('Must enter a cell of strings!');
   out = in;

else

   tstr=in(:);
   out=[];

   for i=1:length(tstr),

      if ~isempty(deblank(tstr{i})),
         out=[out,',',tstr{i}];
      end;

   end;

   out(1)=[];

end;
