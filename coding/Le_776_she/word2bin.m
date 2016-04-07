function y=word2bin(x,L)
% x is integer vector,
% y is its binary representation
% L (or l) is length of binary vector

if nargin==1,
    %x=max(x);
    L=ceil(log2(max(x)+1)); 
end;
[m,n]=size(x);
if m<n, x=x'; m=n; end;  
y=zeros(m,L);
while any(x>0),
  %y(:,L)=bitand(x,1);
  y(:,L)=mod(x,2);
  x=floor(x/2);
  L=L-1;
  if L==0, break; end;
end;
