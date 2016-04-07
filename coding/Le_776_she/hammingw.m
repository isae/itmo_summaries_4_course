function w=hammingw(x, hamm_w)
% computes haming weight of binary
% word(s) x using precomputed table
 if ~exist('hamm_w'), 
     global hamm_w;
     hamm_w=zeros(1,1024);
     hamm_w(1)=0;j=1;
     for i=1:10,
         hamm_w(j+1:j+j)=hamm_w(1:j)+1; j=j+j;
     end;
 end;
w=zeros(size(x));
while sum(x)>0,
    w=w+hamm_w(bitand(x,65535)+1);
    x=bitshift(x,-16);
end;
  
