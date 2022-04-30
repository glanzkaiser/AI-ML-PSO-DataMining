function GAconstrain
tic
clc
figure(1)
clf
clear all
format long

%------------------------        parameters        ----
% file dry sama lalu set parameter 
var=2;            % jumlah variabel ( item = jumlah variabel 
n=100;            % jumlah populasi
m0=30;            % jumlah generasi = max value
nmutationG=20;                  %jumlah anak mutasi (Gaussian)
nmutationR=20;                  %jumlah anak mutasi (random)
nelit=2;                        %jumlah anak
valuemin=ones(1,var)*-5*pi;     % min possible value dari variabel
valuemax=ones(1,var)*5*pi;      % max possible value dari variabel
A=[1 1;-0.5 +1;1 -1;-1 -1];     % constrains: Ax+B>0
B=[5*pi 0 5*pi +5*pi+10];
%-------------------------------------------------------------------------
[r,c]=size(A);
if c~=var
    disp('jumlah kolom A = var')
    A
    var
    return
end
nmutation=nmutationG+nmutationR;
sigma=(valuemax-valuemin)/10;    %Parameter berhubungan dg Gaussian
max1=zeros(nelit,var);
parent=zeros(n,var);
cu=[valuemin(1) valuemax(1) valuemin(2) valuemax(2)];
for l=1:var
    p(:,l)=valuemin(l)+rand(n,1).*(valuemax(l)-valuemin(l));
end
initial=p;
m=m0;
maxvalue=ones(m,1)*-1e10;
maxvalue(m)=-1e5;
g=0;
meanvalue(m)=0;
%-------------   ****    termination criteria   ****-------------
while abs(maxvalue(m)-maxvalue(m-(m0-1)))>0.001*maxvalue(m) &...
        (abs(maxvalue(m))>1e-10 & abs(maxvalue(m-(m0-1)))>1e-10)...
        & m<10000 & abs(maxvalue(m)-meanvalue(m))>1e-5 | m<20
    sigma=sigma./(1.05);% kecilkan nilai sigma
    g=g+1;
    if g>10 & nmutationR>0
        g=0;
        nmutationR=nmutationR-1;
        nmutation=nmutationG+nmutationR;
    end


    for i=1:n
        y(i)=fun00(p(i,:));
        flag(i)=0;
    end
    if var==2
        figure(1)
        hold off
        plot00(cu)
        hold on
        plot3(p(:,1),p(:,2),y,'ro')
        title({'algortima genetika: constrained problem'...
            ,'Performance of GA ( o : each individual)',...
            'blue o:possible solution & red o impossible solution ',...
            'black o: best solution'},'color','b')
    end
    s=sort(y);
    maxy=max(y);
    miny=min(y);
    for i=1:n
        k=length(B);
        for j=1:k
            x=p(i,:);
            if (A(j,:)*x'+B(j))<=0
                y(i)=miny;
                flag(i)=1;
            end
        end
    end
    if var==2
        for i=1:n
            if flag(i)==0
                plot3(p(i,1),p(i,2),y(i),'bo')
            end
        end
    end
    s=sort(y);
    maxvalue1(1:nelit)=s(n:-1:n-nelit+1);
    if nelit==0
        maxvalue1(1)=s(n);
        for i=1:n
            if y(i)==maxvalue1(1)
                max1(1,:)=p(i,:);
            end
        end
    end
    for k=1:nelit
        for i=1:n
            if y(i)==maxvalue1(k)
                max1(k,:)=p(i,:);
            end
        end
    end
    if var==2
        hold on
        plot3(max1(1,1),max1(1,2),maxvalue1(1),'kh')
    end
    y=y-min(y)*1.02;
    sumd=y./sum(y);
    meanvalue=y./(sum(y)/n);


    %-------------   ****   Selection: Rolette wheel   ****-------------
    for l=1:n
        sel=rand;
        sumds=0;
        j=1;
        while sumds<sel
            sumds=sumds+sumd(j);
            j=j+1;
        end
        parent(l,:)=p(j-1,:);
    end
    p=zeros(n,var);

    %-------------   ****    regeneration   ****-------------
    for l=1:var


        %-------------   ****    cross-over   ****-------------
        for j=1:ceil((n-nmutation-nelit)/2)
            t=rand*1.5-0.25;
            p(2*j-1,l)=t*parent(2*j-1,l)+(1-t)*parent(2*j,l);
            p(2*j,l)=t*parent(2*j,l)+(1-t)*parent(2*j-1,l);
        end


        for k=1:nelit
            p((n-nmutation-k+1),l)=max1(k,l);
        end


        %-------------   ****    mutasi   ****-------------
        for i=n-nmutation+1:n-nmutationR
            phi=1-2*rand;
            z=erfinv(phi)*(2^0.5);
            p(i,l)=z*sigma(l)+parent(i,l);

        end
        for i=n-nmutationR+1:n
            p(i,1:var)=valuemin(1:var)+rand(1,var).*(valuemax(1:var)...
                -valuemin(1:var));
        end
        for i=1:n
            for l=1:var
                if p(i,l)<valuemin(l)
                    p(i,l)=valuemin(l);
                elseif p(i,l)>valuemax(l)
                    p(i,l)=valuemax(l);
                end
            end
        end
    end
    p;
    m=m+1;
    max1;
    maxvalue(m)=maxvalue1(1);
    maxvalue00(m-m0)=maxvalue1(1);
    mean00(m-m0)=sum(s)/n;
    meanvalue(m)=mean00(m-m0);
    figure(1)
    if var~=2
        hold off
        plot(maxvalue00)
        hold on
        plot(mean00,'g')
        hold on
        title({'Performance of GA',...
            'best value GA:blue, mean value GA:green',''}...
            ,'color','b')
        xlabel('number of generations')
        ylabel('value')
    end
    pause(0.001)
end

clc
num_of_fun_evaluation=n*m
max_point_GA=max1(1,:)
maxvalue_GA=maxvalue00(m-m0)
if var==2
    figure(1)
    hold on
    plot3(max1(1,1),max1(1,2),maxvalue1,'yp')
    hold on
end
figure(2)
title('Performance of GA(best value)','color','b')
xlabel('number of generations')
ylabel('max value of best solution')
hold on
plot(maxvalue00)
hold on
toc