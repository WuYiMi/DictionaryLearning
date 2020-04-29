function [ T2UCL,QUCL,P,lamda_select ] = Pca_offline(data,u,E,confidence,CPV)
%使用pca模型进行统计评估
%   此处显示详细说明

Xtrain = double(data);
%载入测试数据
%标准化处理：
X_mean =u; %按列求Xtrain 平均值
X_std = diag(E); %求标准差
[X_row,X_col] = size(Xtrain); %求Xtrain 行、列数
Xtrain=(Xtrain-repmat(X_mean,X_row,1))./repmat(X_std',X_row,1);
%求协方差矩阵
sigmaXtrain=E;
%对协方差矩阵进行特征分解， lamda 为特征值构成的对角阵， T 的列为单位特征向量，且与lamda 中的特征值一一对应：
[D,P_all,lamda_select,P,num_pc]=selectLamdaP(E,CPV);
lamda=diag(D);
% [T,lamda] = eig(sigmaXtrain);
% % disp(' 特征根（由小到大） ');
% % disp(lamda);
% % disp(' 特征向量： ');
% % disp(T);
% %取对角元素( 结果为一列向量) ，即lamda 值，并上下反转使其从大到小排列，主元个数初值为1，若累计贡献率小于90%则增加主元个数
% D = flipud(diag(lamda));
% num_pc = 1;
% while sum(D(1:num_pc))/sum(D) < 0.9
% num_pc = num_pc +1;
% end
% %取与lamda 相对应的特征向量
% P = T(:,X_col-num_pc+1:X_col);

%求置信度为99%、95%时的T2 统计控制限
%T2UCL1=num_pc*(X_row-1)*(X_row+1)*finv(0.99,num_pc,X_row - num_pc)/(X_row*(X_row - num_pc));
T2UCL=num_pc*(X_row-1)*finv(confidence,num_pc,X_row - num_pc)/(X_row - num_pc);
%置信度为99%的Q统计控制限
% for i = 1:3
% theta(i) = sum((D(num_pc+1:X_col)).^i);
% end
% h0 = 1 - 2*theta(1)*theta(3)/(3*theta(2)^2);
% ca = norminv(0.99,0,1);
% QUCL = theta(1)*(h0*ca*sqrt(2*theta(2))/theta(1)+ 1 + theta(2)*h0*(h0 - 1)/theta(1)^2)^(1/h0);

[r,y] = size(P*P');
I = eye(r,y);
Q = zeros(X_row,1);
for i = 1:X_row
Q(i) = norm((I - P*P')*Xtrain(i,:)')^2;
end
g=var(Q)/(2*mean(Q));
h=mean(Q)/g;
QUCL=g*chi2inv(confidence,h);


end

