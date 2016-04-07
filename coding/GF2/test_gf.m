
p=[1 0 0 1 1];
[V,L]=gf2(p);

% LL=zeros(1,16);
% for i=0:15
%     LL(i+1)=gf2_log(i,V);
% end
% disp([(1:16)' V' L' LL']);


q=length(V);
TABMUL=zeros(q);
for i=0:q-1
    for j=0:q-1
        TABMUL(i+1,j+1)=gf2_mul(i,j,V);
    end;
end;
%     
% a=[1 11 4];
% b=[6 15];
% c=gf2_mul_pol(a,b,TABMUL);

M=gf2_min(6,TABMUL);

g=gen_pol([2 8],TABMUL);



