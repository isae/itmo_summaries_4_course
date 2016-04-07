function x=gf2_inv(y,V,L)
q=length(V);
dy=L(y+1);
dx=q-1-dy;
x=V(dx+2);