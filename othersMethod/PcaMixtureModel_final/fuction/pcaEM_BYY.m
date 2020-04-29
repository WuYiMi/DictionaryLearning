function  K = pcaEM_BYY(data)
% 贝叶斯阴阳算法求解 最佳K
%
global num_data K
K=2;
% [X] = mapminmax(data);  %X为N*D型数据
% X = 8*zscore(data);
X=data;
[dim num_data] = size(data');

[inx, C,~] = kmeans(X,K);
mu = C;
pai = zeros(1,K);
E = zeros(dim,dim,K);
for k=1:K
    pai(k) = sum(inx==k);   
    E(:,:,k) = eye(dim);
end
pai = pai/num_data;

model.mu=mu;
model.E=E;
model.pai=pai;

model_optim=pcaEmFcn(X,K,model);
mu=model_optim.mu;
E=model_optim.E;
pai=model_optim.pai;
Jk=compu_Jk(X,mu,E,pai);
loss_val=sum(Jk);
while 1
    [~,i]=min(Jk);
    %分裂 W
    pai_r=0.5*pai(i);
    pai(i)=[];
    pai=[pai pai_r pai_r];
    %分裂 u
    mu_r=mu(i,:);
    A_1=select_lamda_1(E(:,:,i)); %计算A_1
    mu(i,:)=[];
    mu=[mu;mu_r-0.5*A_1';mu_r+0.5*A_1'];
    %分裂E
    a=0.5;
    b=0.5;
    E_r=E(:,:,i);
    E_1=E_r+((b-b*a^2-1)*0.5+1)*(A_1*A_1');
    E(:,:,i)=[];
    E=cat(3,E,E_1,E_1);
    Jk=compu_Jk(X,mu,E,pai);
    loss_new=sum(Jk);
    if loss_new <= loss_val
        break;
    end
    K=k+1;
end

end

%---------------------------------------------------------------
function Jk = compu_Jk(X,mu,E,pai)
    num_data=size(X,1);
    K=size(mu,1);
    Jk = zeros(num_data,K);
   
    for n = 1:num_data
        J_nK = zeros(1,K);
        lnwg = zeros(1,K);
        for k=1:K
            J_nK(k) = pai(k)* cul_Gaussian(X(n,:),mu(k,:),E(:,:,k));
            if J_nK(k)==0
                lnwg(k)=0;
            else
                lnwg(k)=log(J_nK(k));
            end
        end
        if sum(J_nK)~=0
            Jk(n,:) = (J_nK.*lnwg)/sum(J_nK);
        else
            Jk(n,:) = [1 J_nK(2:end)].*lnwg;
        end
    end
    Jk=sum(Jk);
end

function g = cul_Gaussian(X,mu,E)
    num_pc=size(X,2);
    w=((det(E)*(2*pi)^num_pc)^(-1/2));
    g=w*exp(-0.5*(X-mu)*inv(E)*(X-mu)');
end

function A_1 = select_lamda_1(E)
    [P,lamda] = eig(E); 
    [D,I] = sort(diag(lamda),'descend'); % 降序，默认的是升序
    P = P(:,I);
    A_1=(D(1)^1/2)*P(:,1);
end

