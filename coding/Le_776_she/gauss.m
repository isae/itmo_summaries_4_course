function y=gauss(x1,x2)
% Computes    
%  y= 1/sqrt(2*pi) * integral from x1 to x2 of exp(-t^2/2) dt
% gauss(x) = integral from x1 to infinity
% x1 and x2 can be both vectors of the same length 
% or one vector and one scalar

y=erfc(x1/sqrt(2))/2;
if nargin ==2
   y=y-erfc(x2/sqrt(2))/2;
   f= x1>=x2;
   y(f)=0;
end;



    


