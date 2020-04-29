function [ D,P,lamda_select,P_select,num_pc] = selectLamdaP( E,CPV)
%   传入协方差矩阵 E
%   特征值分解 按方差贡献率0.99选取特征值和特征向量
%   返回 lamda_select，P_select
[P,lamda] = eig(E); 
[D,I] = sort(diag(lamda),'descend'); % 降序，默认的是升序
P = P(:,I);
num_pc = 1;
while sum(D(1:num_pc))/sum(D) < CPV
num_pc = num_pc +1;
end
%取方差为0.99的lamda 对角阵
lamda_select=diag(D(1:num_pc));
%取与lamda 相对应的特征向量
P_select = P(:,1:num_pc);
end

