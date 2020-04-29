function [nT2,nSPE] = Pca_online(test_data,X_mean,E,T2UCL,QUCL,P,lamda)
%使用pca模型进行在线监测
%   此处显示详细说明

X_std = diag(E); 
%标准化处理
n = size(test_data,1);
test_data=(test_data-repmat(X_mean,n,1))./repmat(X_std',n,1);
%求T2 统计量， Q统计量
[r,y] = size(P*P');
I = eye(r,y);
T2 = zeros(n,1);
Q = zeros(n,1);
for i = 1:n
    T2(i)=test_data(i,:)*P*inv(lamda)*P'*test_data(i,:)'; %inv 求逆矩阵
    Q(i) = norm((I - P*P')*test_data(i,:)')^2;
end
nSPE=Q/QUCL;
nT2=T2/T2UCL;



end

