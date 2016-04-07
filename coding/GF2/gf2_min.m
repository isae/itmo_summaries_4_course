function M=gf2_min(a,TABMUL)
% Finds min polynomial having root a 
M=1;
b=a; 
while 1,
    M=gf2_mul_pol(M,[b 1],TABMUL);
    b=TABMUL(b+1,b+1);
    if b==a, return; end;
end;