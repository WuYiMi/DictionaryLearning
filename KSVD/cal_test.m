function [ dre, state ,spc_off] = cal_test( traindata,D,t ,limit)
% get offlineDL testdata & onlinedata(parameter:traindata) 
% state and reconstruction error
% 10/21
m=size(traindata,2);
dre=zeros(m,1);
W=zeros(size(D,2),m);
state=zeros(m,1);
n=size(traindata,1);
for i=1:m
W(:,i)=omp(D,traindata(:,i),D'*D,t);
dre(i)=norm(traindata(:,i)-D*W(:,i),2)^2;
if dre(i)>limit
    state(i)=0;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     if i>=4000 && i<4100
if i>=2000 && i<2100
                    EYE=eye(n);
            DC=[D,EYE];
            tc=4;
            a_new=omp(DC,traindata(:,i),DC'*DC,tc);
            f=a_new(end-(n-1):end);
            f=full(f);
            sum_f=sum(f.^2);
            for ite=1:n
%                 spc_off(i-4000+1,ite)=f(ite)*f(ite)/sum_f;
                spc_off(i-2000+1,ite)=f(ite)*f(ite)/sum_f;

            end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    state(i)=1;
end

end
end

