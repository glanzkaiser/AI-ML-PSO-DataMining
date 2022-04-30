function time=mytime
%MYTIME kembalikan current time ke fomat
%pakai:   mytime

ss=fix(clock);
if ss(4)>12,				%JAM
   time=[num2str(ss(4)-12),':'];tag='pm';
else
   time=[num2str(ss(4)),':'];tag='am';
end;

if ss(5)<10, 				%MENIT
   time=[time,'0',num2str(ss(5)),':'];
else
   time=[time,num2str(ss(5)),':'];
end;

if ss(6)<10,				%DETIK
   time=[time,'0',num2str(ss(6)),tag];
else
   time=[time,num2str(ss(6)),tag];
end;
