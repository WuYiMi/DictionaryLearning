function [ D,P,lamda_select,P_select,num_pc] = selectLamdaP( E,CPV)
%   ����Э������� E
%   ����ֵ�ֽ� ���������0.99ѡȡ����ֵ����������
%   ���� lamda_select��P_select
[P,lamda] = eig(E); 
[D,I] = sort(diag(lamda),'descend'); % ����Ĭ�ϵ�������
P = P(:,I);
num_pc = 1;
while sum(D(1:num_pc))/sum(D) < CPV
num_pc = num_pc +1;
end
%ȡ����Ϊ0.99��lamda �Խ���
lamda_select=diag(D(1:num_pc));
%ȡ��lamda ���Ӧ����������
P_select = P(:,1:num_pc);
end

