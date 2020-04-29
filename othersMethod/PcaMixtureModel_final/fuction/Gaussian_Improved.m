function [ g ] = Gaussian_Improved( X,u,E )
%   Gaussian_Improved ����PCA��˹�ܶȺ���
%   X   matrix(800x5) ���ݾ���
%   u   vector(1,5)  ��ֵ����
%   E  matrix(5x5)  Э�������
%   P_select matrix(5x2)    ѡ��ͶӰ��������
%   lamda_select matrix(2x2)    ѡ��ͶӰ��������
%   T  matrix(800x2)  �÷־���
%   g   value  �ܶ�ֵ

%��Э���������������ֽ⣬ lamda Ϊ����ֵ���ɵĶԽ��� T ����Ϊ��λ��������������lamda �е�����ֵһһ��Ӧ

E(isnan(E)) = 0;
[P,lamda] = eig(E); 
[D,I] = sort(diag(lamda),'descend'); % ����Ĭ�ϵ�������
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
%ȡ����Ϊ0.99��lamda �Խ���
lamda_select=diag(D(1:num_pc));
%ȡ��lamda ���Ӧ����������
P_select = P(:,1:num_pc);
%ͶӰ
T=X*P_select;
w=((det(lamda_select)*(2*pi)^num_pc)^(-1/2));
lamda_1=inv(lamda_select);
g=0;
for i=1:X_row
    g=g+w*exp(-0.5*T(i,:)*lamda_1*T(i,:)');
end

end




