function g=gen_pol(D,TABMUL)

g=1;
for i=1:length(D)
    b=gf2_min(D(i),TABMUL);
    g=gf2_mul_pol(g,b,TABMUL);
end;