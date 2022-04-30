clear all, close all, clc
%thetha0=0 / 1 parameter saja
% to minimize, so J(thetha1) cost fuction have to be minimum
x=[1 2 4 0];%variabel 1
y=[.5 1 2 0];% output
plot (x,y,'o')
axis ([0 10 0 10])
idx=[0 10];
idy=[0 10];
hold on
plot(idx,idy,'-r');
% syms thetha0 thetha1 m
[b m]=size(x);
% dimana m adalah jumlah iterasi according ke data latih
% dan thetha 0-1 adalah variabel

thetha0=input('Insert value of thetha0: ');
thetha1=input('Insert value of thetha1: ');
% update thetha0,1 parameters until bertemu
for i=1:1:m
    hyp(i)=thetha0+thetha1*x(i);
    
end


% J=0;%Cost function initiation J
err=0;
for i=1:1:m
    err=err+(hyp(i)-y(i))^2;
end
J=(1/(2*m))*err; %fungsi harga ke  Thetha0,1 
while (true)
sum0=0;
hypo=0;
for j=1:1:m
    hypo(j)=thetha0+thetha1*x(j);
    sum0=sum0+hypo(j)-y(j);
end
temp0=thetha0-alpha*(1/m)*sum0;
% --------------for thetha1----------------
sum1=0;
for j=1:1:m
    sum1=sum1+(hypo(j)-y(j))*x(j);
end
temp1=thetha1-alpha*(1/m)*sum1;
plothypo=hypo;%just for plot

    if (abs(temp0-thetha0)<=0.001)
        if (abs(temp1-thetha1)<=0.001)
            break;
        end
    end
thetha0=temp0;
thetha1=temp1;
 i=i+1;
%--------------------------
 to(i)=thetha0;
 t1(i)=thetha1;
end
hold on
plot(x,hypo,'-b');