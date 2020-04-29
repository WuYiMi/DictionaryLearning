function [T2_thres, Q_thres, P,num_pc,X_mean,p,lamda,sigmaXtrain ]=PCA (Train_Data, CPV , Confidence )
Xtrain=Train_Data';
% Xtest=Test_Data';
X_mean = mean(Xtrain); 
[X_row,X_col] = size(Xtrain);
Xtrain=(Xtrain-repmat(X_mean,X_row,1));%���Ļ�����
sigmaXtrain = cov(Xtrain);%��Э�������
[p,lamda] = eig(sigmaXtrain);%��Э���������������ֽ⣬ lamda Ϊ����ֵ���ɵĶԽ��� T ����Ϊ��λ��������������lamda �е�����ֵһһ��Ӧ��
num_pc = 1;
D =flipud(diag(lamda)); %����ֵ�ɴ�С����
p=fliplr(p);
lamda=rot90(lamda,2);
while sum(D(1:num_pc))/sum(D) < CPV %������ȷ����Ԫ����
num_pc = num_pc +1;
end
P = p(:,1:num_pc);%ѡȡ��������
T=Xtrain*P;
I=eye(X_col,X_col);
for i=1:X_row
    T2(:,i)=T(i,:)*inv(lamda(1:num_pc,1:num_pc))*T(i,:)';%����ͳ����T2��Q
    Q2(i,:)=Xtrain(i,:)*(I - P*P');
    q2(i) =Xtrain(i,:)*(I - P*P')*Xtrain(i,:)';
end
    Q= sum((Q2').^2,1);%��Q���й�һ��
    T2_limit=KDE_fcn(T2',Confidence);%��T2��Q����ֵ
    T2_thres=T2_limit(2);
    Q_limit=KDE_fcn(Q',Confidence);
    Q_thres=Q_limit(2);
end