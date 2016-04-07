function [V L]=gf2(p)
m=length(p)-1;
q=2^m;
V=zeros(1,q);
L=zeros(1,q);
p=bin2word(p);
V(1)=0;L(1)=-1;
V(2)=1; L(2)=0;
for i=3:q
    v=V(i-1)*2;
    if v>=q, v=bitxor(v,p); end;
    V(i)=v;
    L(v+1)=i-2;
end;


