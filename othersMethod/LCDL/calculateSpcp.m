function Spc = calculateSpcp(a_new,dim)
e=eye(dim);
num=size(a_new,1);
P=zeros(num-dim,dim);
P=[P;eye(dim)];
Pa=P'*a_new;
Pa=Pa.^2;
Spc=Pa./sum(Pa);
