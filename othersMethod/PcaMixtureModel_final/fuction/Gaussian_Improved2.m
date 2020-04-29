function [ g ] = Gaussian_Improved2( X,u,lamda,P )
%   Gaussian_Improved 计算PCA高斯密度函数
%   X   matrix(800x5) 数据矩阵
%   u   vector(1,5)  均值向量
%   E  matrix(5x5)  协方差矩阵
%   P_select matrix(5x2)    选择投影向量矩阵
%   lamda_select matrix(2x2)    选择投影特征矩阵
%   T  matrix(800x2)  得分矩阵
%   g   value  密度值
%对协方差矩阵进行特征分解， lamda 为特征值构成的对角阵， T 的列为单位特征向量，且与lamda 中的特征值一一对应
[X_row,X_col] = size(X);
X=X-repmat(u,X_row,1); %(X-u)

%投影
T=X*P;
w=((det(lamda)*(2*pi)^num_pc)^(-1/2));
lamda_1=inv(lamda);
g=0;
for i=1:X_row
    g=g+w*exp(-0.5*T(i,:)*lamda_1*T(i,:)');
end
end