function p=gf2_mul(a,b,V)
p=0; q=length(V);
if (a<0)||(b<0)||(a>q)||(b>q),
    error('out of field')
end;
if a>0 && b>0
    la=gf2_log(a,V);
    lb=gf2_log(b,V);
    lc=mod(la+lb,q-1);
    p=V(lc+2);
end;
