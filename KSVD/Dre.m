function [ dre, W] = Dre( D,traindata,t )
%calculate the reconstruction error of traindata(parameter)
%by w.y.m 1809
m=size(traindata,2);
dre=zeros(m,1);
W=zeros(size(D,2),m);
for i=1:m
W(:,i)=omp(D,traindata(:,i),D'*D,t);
dre(i)=norm(traindata(:,i)-D*W(:,i),2)^2;
end
end

