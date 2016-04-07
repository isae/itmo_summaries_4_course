function A=g2code(G)

%G - is array of basis codewords in int format
% A - array of codewords in int format
k=length(G);
A=zeros(1,2^k);
A(2)=G(1);
J=2;
for j=2:k
    A(J+1:2*J)=bitxor(A(1:J),G(j));
    J=J*2;
end;
