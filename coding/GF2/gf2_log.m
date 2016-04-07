function l=gf2_log(x,V)
l=-2;
if x<0 || x>length(V), error('wrong  input'); end;
f=find(V==x);

l=f-2;