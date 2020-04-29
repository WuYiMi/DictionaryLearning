function [ g ] = Gaussian_Improved2( X,u,lamda,P )
%   Gaussian_Improved ����PCA��˹�ܶȺ���
%   X   matrix(800x5) ���ݾ���
%   u   vector(1,5)  ��ֵ����
%   E  matrix(5x5)  Э�������
%   P_select matrix(5x2)    ѡ��ͶӰ��������
%   lamda_select matrix(2x2)    ѡ��ͶӰ��������
%   T  matrix(800x2)  �÷־���
%   g   value  �ܶ�ֵ
%��Э���������������ֽ⣬ lamda Ϊ����ֵ���ɵĶԽ��� T ����Ϊ��λ��������������lamda �е�����ֵһһ��Ӧ
[X_row,X_col] = size(X);
X=X-repmat(u,X_row,1); %(X-u)

%ͶӰ
T=X*P;
w=((det(lamda)*(2*pi)^num_pc)^(-1/2));
lamda_1=inv(lamda);
g=0;
for i=1:X_row
    g=g+w*exp(-0.5*T(i,:)*lamda_1*T(i,:)');
end
end