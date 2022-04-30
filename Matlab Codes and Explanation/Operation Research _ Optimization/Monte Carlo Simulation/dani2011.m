
m=30000;
n=1000;
h=zeros(1,m);
ht=zeros(1,m);
for j=1:m;
    A =rand(1,n);
    head =0;
    for i=1:n;
         if(A(i)<=0.2)
              head=head+1;
         end
    end
    h(j)=head;
end
h_max=max(h);
h_min=min(h);
r=h_min:h_max;
[nb]=hist(h,r);
hist(h,r)
for x=h_min:h_max
    Ht(x)=m*nchoosek(n,x)*((0.2)^x*(0.8)^(n-x));
end
plot(r,Ht(r),r,nb,'r')


