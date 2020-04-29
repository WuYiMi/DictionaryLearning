function [nT2,nSPE] = Pca_online(test_data,X_mean,E,T2UCL,QUCL,P,lamda)
%ʹ��pcaģ�ͽ������߼��
%   �˴���ʾ��ϸ˵��

X_std = diag(E); 
%��׼������
n = size(test_data,1);
test_data=(test_data-repmat(X_mean,n,1))./repmat(X_std',n,1);
%��T2 ͳ������ Qͳ����
[r,y] = size(P*P');
I = eye(r,y);
T2 = zeros(n,1);
Q = zeros(n,1);
for i = 1:n
    T2(i)=test_data(i,:)*P*inv(lamda)*P'*test_data(i,:)'; %inv �������
    Q(i) = norm((I - P*P')*test_data(i,:)')^2;
end
nSPE=Q/QUCL;
nT2=T2/T2UCL;



end

