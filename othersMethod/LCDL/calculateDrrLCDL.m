function [drr,a_new] = calculateDrr(D,data,sparsity)
dim=size(D,1);
p3=zeros(dim,size(D,2));
P = eye(size(D,2)); 
P=[P;p3];
D=[D,eye(size(D,1))];
G = D'*D;
a_new = omp(D'*data,G,sparsity);
drr=[];
for i=1:size(data,2)
drr=[drr,norm(data(:,i)-D*P*P'*a_new(:,i),2)^2];
end









