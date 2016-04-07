function c=gf2_mul_pol(a,b,TABMUL)
da=length(a)-1;
db=length(b)-1;
dc=da+db;
c=zeros(1,dc+1);

for i=1:db+1
    % multiply a by constant b_i
    for j=1:da+1
        z=TABMUL(a(j)+1,b(i)+1);
        c(j+i-1)=bitxor(c(j+i-1),z);
    end;
end;