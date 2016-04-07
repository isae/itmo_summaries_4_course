% Prepare GF(q)
p=[1 0 0 1 1];
[V,L]=gf2(p);
q=length(V);
TABMUL=zeros(q);
for i=0:q-1
    for j=0:q-1
        TABMUL(i+1,j+1)=gf2_mul(i,j,V);
    end;
end;
% Construct BCH code, correcting t errors
D=[1 3 5]; 
n=q-1;       %(primitive BCH)
t=length(D);
g=gen_pol(V(D+2),TABMUL);
r=length(g)-1;
k=n-r;

% Message
%m=rand(1,k)>1/2;
m=[0     0     1     1     1];
% Codeword
c=gf2_mul_pol(m,g,TABMUL);

% Channel
Loc=[2 15 14];
b=c;
b(Loc)=xor(b(Loc),1);

% Compute syndrome
S=zeros(1,2*t);
for i=1:2*t
    S(i)=gorner(b,V(i+2), TABMUL);
end;




