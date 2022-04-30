function outstr=lstr2cel(instr)
%LSTR2CEL mengkonversi in-line string (dipisah;) ke cell strings
%pakai:  out=lstr2cel(in)
%      pakai  char(out) untuk konversi ke matriks string


if isempty(instr),              %kalau instr kosong, kembali ke cell kosong
   outstr={''}; 
   return;
end;

if size(instr,1)>1,             %kalau sudah ada baris, lanjut ke lstr

   instr=cel2lstr(instr); 

end;

if iscell(instr),               %kalau instr ada cell, kembali

   outstr=instr;
   return; 

end;

instr=char(instr);             %memastikan non-cell input

instr=deblank(instr);          %hapus  jejak yang terhapus

if ~(instr(1)==''''&instr(length(instr))=='''')
   instr=[ '''',instr,''''];   %tempatkan place dari mulai dan akhir
end;

%%%%%%%%%%%%%%%%
%round brackets
%%%%%%%%%%%%%%%%
openrb=findstr(instr,'(');
closerb=findstr(instr,')');

%temukan posisi
numopenrb = length(openrb);
numcloserb = length(closerb);

%memastikan pencocokkan 
while (numcloserb < numopenrb)
  
   instr = [ instr(1:end-1),')',instr(end) ];

   closerb = findstr(instr,')');

   numcloserb = length(closerb);

end;


while (numcloserb > numopenrb)

   instr = [ '(',instr(1:end-1),instr(end) ];

   openrb = findstr(instr,'(');

   numopenrb = length(openrb);

end;

instr = strrep(instr,',)',')');
   
comma=findstr(instr,','); 
noch=[];
ch=[];


for ii=1:length(comma),

   for jj=1:numopenrb,

%     temukan((comma(ii)>openrb(jj)).*(comma(ii)<closerb(jj))),
        if find((comma(ii)>openrb(jj)).*(comma(ii)<closerb(jj))),
           noch=[noch,comma(ii)];
        else
           ch=[ch,comma(ii)];
        end;

    end;
  
end;

if ~isempty(noch),

   for ii=1:length(noch),
      instr(noch(ii))='#';
   end;

end;


opensb=findstr(instr,'[');
closesb=findstr(instr,']');

numopensb = length(opensb);
numclosesb = length(closesb);

%cocokkan pencocokan
if (numclosesb ~= numopensb)
 
   instr(closesb) = [];
   opensb=findstr(instr,'[');
   instr(opensb) = [];
   opensb=[];
   closesb=[];
   numopensb=0;
   numclosesb=0;

end;

instr = strrep(instr,',]',']');
comma=findstr(instr,','); 
noch=[];
ch=[];

for ii=1:length(comma),

   for jj=1:length(opensb),

      if find((comma(ii)>opensb(jj)).*(comma(ii)<closesb(jj))),
         noch=[noch,comma(ii)];
      else
         ch=[ch,comma(ii)];
      end;

   end;

end;

if ~isempty(noch),

   for ii=1:length(noch),
      instr(noch(ii))='#';
   end;

end;

instr=strrep(instr,',',''',''');     %gantikan  ,  dari  ',']
instr=strrep(instr,'#',',');         %gantikan  #  dari commas

dinst = deblank(instr);
ldi = length(dinst);
if (dinst(ldi-1:ldi)==''''''),
   dinst = [ dinst(1),'[',dinst(2:ldi-1),''']''' ];
end
instr=dinst;

eval(['outstr=strvcat(',instr,');'] , 'outstr=1;'); 
                                
outstr = cellstr(outstr);
