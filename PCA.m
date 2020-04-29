function [T2_thres, Q_thres, P,num_pc,X_mean,p,lamda,sigmaXtrain ]=PCA (Train_Data, CPV , Confidence )
Xtrain=Train_Data';
% Xtest=Test_Data';
X_mean = mean(Xtrain); 
[X_row,X_col] = size(Xtrain);
Xtrain=(Xtrain-repmat(X_mean,X_row,1));%中心化处理
sigmaXtrain = cov(Xtrain);%求协方差矩阵
[p,lamda] = eig(sigmaXtrain);%对协方差矩阵进行特征分解， lamda 为特征值构成的对角阵， T 的列为单位特征向量，且与lamda 中的特征值一一对应：
num_pc = 1;
D =flipud(diag(lamda)); %特征值由大到小排列
p=fliplr(p);
lamda=rot90(lamda,2);
while sum(D(1:num_pc))/sum(D) < CPV %贡献率确定主元个数
num_pc = num_pc +1;
end
P = p(:,1:num_pc);%选取特征向量
T=Xtrain*P;
I=eye(X_col,X_col);
for i=1:X_row
    T2(:,i)=T(i,:)*inv(lamda(1:num_pc,1:num_pc))*T(i,:)';%计算统计量T2，Q
    Q2(i,:)=Xtrain(i,:)*(I - P*P');
    q2(i) =Xtrain(i,:)*(I - P*P')*Xtrain(i,:)';
end
    Q= sum((Q2').^2,1);%对Q进行归一化
    T2_limit=KDE_fcn(T2',Confidence);%求T2，Q的阈值
    T2_thres=T2_limit(2);
    Q_limit=KDE_fcn(Q',Confidence);
    Q_thres=Q_limit(2);
end