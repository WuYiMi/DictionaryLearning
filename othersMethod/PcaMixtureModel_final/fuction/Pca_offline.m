function [ T2UCL,QUCL,P,lamda_select ] = Pca_offline(data,u,E,confidence,CPV)
%ʹ��pcaģ�ͽ���ͳ������
%   �˴���ʾ��ϸ˵��

Xtrain = double(data);
%�����������
%��׼������
X_mean =u; %������Xtrain ƽ��ֵ
X_std = diag(E); %���׼��
[X_row,X_col] = size(Xtrain); %��Xtrain �С�����
Xtrain=(Xtrain-repmat(X_mean,X_row,1))./repmat(X_std',X_row,1);
%��Э�������
sigmaXtrain=E;
%��Э���������������ֽ⣬ lamda Ϊ����ֵ���ɵĶԽ��� T ����Ϊ��λ��������������lamda �е�����ֵһһ��Ӧ��
[D,P_all,lamda_select,P,num_pc]=selectLamdaP(E,CPV);
lamda=diag(D);
% [T,lamda] = eig(sigmaXtrain);
% % disp(' ����������С���� ');
% % disp(lamda);
% % disp(' ���������� ');
% % disp(T);
% %ȡ�Խ�Ԫ��( ���Ϊһ������) ����lamda ֵ�������·�תʹ��Ӵ�С���У���Ԫ������ֵΪ1�����ۼƹ�����С��90%��������Ԫ����
% D = flipud(diag(lamda));
% num_pc = 1;
% while sum(D(1:num_pc))/sum(D) < 0.9
% num_pc = num_pc +1;
% end
% %ȡ��lamda ���Ӧ����������
% P = T(:,X_col-num_pc+1:X_col);

%�����Ŷ�Ϊ99%��95%ʱ��T2 ͳ�ƿ�����
%T2UCL1=num_pc*(X_row-1)*(X_row+1)*finv(0.99,num_pc,X_row - num_pc)/(X_row*(X_row - num_pc));
T2UCL=num_pc*(X_row-1)*finv(confidence,num_pc,X_row - num_pc)/(X_row - num_pc);
%���Ŷ�Ϊ99%��Qͳ�ƿ�����
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

