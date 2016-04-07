function x=bin2word(y)
% transfrom matrix y to integers row by row 
[k,n]=size(y);
p=2.^[n-1:-1:0];
x=p*y';
