function [ g ] = Gaussian_Improved( X,u,E )
%   Gaussian_Improved 计算PCA高斯密度函数
%   X   matrix(800x5) 数据矩阵
%   u   vector(1,5)  均值向量
%   E  matrix(5x5)  协方差矩阵
%   P_select matrix(5x2)    选择投影向量矩阵
%   lamda_select matrix(2x2)    选择投影特征矩阵
%   T  matrix(800x2)  得分矩阵
%   g   value  密度值

%对协方差矩阵进行特征分解， lamda 为特征值构成的对角阵， T 的列为单位特征向量，且与lamda 中的特征值一一对应

E(isnan(E)) = 0;
[P,lamda] = eig(E); 
[D,I] = sort(diag(lamda),'descend'); % 降序，默认的是升序
P = P(:,I);

[X_row,X_col] = size(X);
X=X-repmat(u,X_row,1); %(X-u)
% D = flipud(diag(lamda));
num_pc = 1;
while sum(D(1:num_pc))/sum(D) < 0.99
num_pc = num_pc +1;
end
% if num_pc<5
%     num_pc
% end
%取方差为0.99的lamda 对角阵
lamda_select=diag(D(1:num_pc));
%取与lamda 相对应的特征向量
P_select = P(:,1:num_pc);
%投影
T=X*P_select;
w=((det(lamda_select)*(2*pi)^num_pc)^(-1/2));
lamda_1=inv(lamda_select);
g=0;
for i=1:X_row
    g=g+w*exp(-0.5*T(i,:)*lamda_1*T(i,:)');
end

end




