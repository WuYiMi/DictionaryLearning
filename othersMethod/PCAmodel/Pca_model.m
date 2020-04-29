function [num_pc,pca_fault,pca_ucl,pca_error]=Pca_model(Xtrain,Xtest,numbers,confidence,CPV)
Xtrain=Xtrain';
Xtest=Xtest';
%标准化处理：
X_mean = mean(Xtrain); %按列求Xtrain 平均值
X_std = std(Xtrain); %求标准差
[X_row,X_col] = size(Xtrain); %求Xtrain 行、列数

% end
Xtrain=(Xtrain-repmat(X_mean,X_row,1))./repmat(X_std,X_row,1);
%  Xtrain=(Xtrain-repmat(X_mean,X_row,1));
%求协方差矩阵
sigmaXtrain = cov(Xtrain);
%对协方差矩阵进行特征分解， lamda 为特征值构成的对角阵， T 的列为单位特征向量，且与lamda 中的特征值一一对应：
[T,lamda] = eig(sigmaXtrain);

%取对角元素( 结果为一列向量) ，即lamda 值，并上下反转使其从大到小排列，主元个数初值为1，若累计贡献率小于90%则增加主元个数
D = flipud(diag(lamda));
num_pc = 1;
while sum(D(1:num_pc))/sum(D) < CPV
num_pc = num_pc +1;
end
%取与lamda 相对应的特征向量
P = T(:,X_col-num_pc+1:X_col);
%求置信度为99%、95%时的T2 统计控制限

T2UCL2=num_pc*(X_row-1)*(X_row+1)*finv(confidence,num_pc,X_row - num_pc)/(X_row*(X_row - num_pc));
%置信度为99%的Q统计控制限
for i = 1:3
theta(i) = sum((D(num_pc+1:X_col)).^i);
end
h0 = 1 - 2*theta(1)*theta(3)/(3*theta(2)^2);
ca = norminv(confidence,0,1);
QUCL = theta(1)*(h0*ca*sqrt(2*theta(2))/theta(1)+ 1 + theta(2)*h0*(h0 - 1)/theta(1)^2)^(1/h0);
%在线监测：
%标准化处理
[n,m]= size(Xtest);
Xtest=(Xtest-repmat(X_mean,n,1))./repmat(X_std,n,1);
% Xtest=(Xtest-repmat(X_mean,n,1));
%求T2 统计量， Q统计量
[r,y] = size(P*P');
I = eye(r,y);
T2 = zeros(n,1);
Q = zeros(n,1);

for i = 1:n
T2(i)=Xtest(i,:)*P*inv(lamda(m-num_pc+1:m,m-num_pc+1:m))*P'*Xtest(i,:)'; %inv 求逆矩阵
Q(i) = Xtest(i,:)*(I - P*P')*Xtest(i,:)';
end

hide=numbers(1);
normal=numbers(2);
abnormal=numbers(3);
show_T2=T2(hide+1:end,:);
show_Q=Q(hide+1:end,:);

%% 计算T2 故障率
label = ones(size(show_T2,1),1);
for i=1:size(Xtest(hide+1:end,:),1)
    if(show_T2(i)>T2UCL2)
       label(i,:)=0;    
    end
end

T2_FAR=(length(find(label(1:normal)==0))/normal);  %计算故障虚报率
T2_FDR=length(find(label(normal+1:end)==0))/abnormal;  %故障预报率


%% 计算SPE 故障率
label = ones(size(show_Q,1),1);
for i=1:size(Xtest(hide+1:end,:),1)
    if(show_Q(i)>QUCL)
       label(i,:)=0;    
    end
end

SPE_FAR=(length(find(label(1:normal)==0))/normal);  %计算故障虚报率
SPE_FDR=length(find(label(normal+1:end)==0))/abnormal;  %故障预报率

pca_fault=[T2_FAR,T2_FDR,SPE_FAR,SPE_FDR];
pca_ucl=[T2UCL2,QUCL];
pca_error=[show_T2,show_Q];