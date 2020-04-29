function [ output_args ] = Pca_Estimate(data,test_data,u,E)
%ʹ��pcaģ�ͽ���ͳ������
%   �˴���ʾ��ϸ˵��

Xtrain = double(data);
%�����������
Xtest = double(test_data);
%��׼������
X_mean =u; %������Xtrain ƽ��ֵ
X_std = diag(E); %���׼��
[X_row,X_col] = size(Xtrain); %��Xtrain �С�����
% for i = 1:X_col
%Xtrain(:,i)=(Xtrain(:,i) - X_mean(i)./X_std(i));
%Xtest(:,i) = (Xtest(:,i) - X_mean(i)./X_std(i));
% end
Xtrain=(Xtrain-repmat(X_mean,X_row,1))./repmat(X_std',X_row,1);
%��Э�������
sigmaXtrain=E;
%��Э���������������ֽ⣬ lamda Ϊ����ֵ���ɵĶԽ��� T ����Ϊ��λ��������������lamda �е�����ֵһһ��Ӧ��
[D,P_all,lamda_select,P,num_pc]=selectLamdaP(E);
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
T2UCL1=num_pc*(X_row-1)*(X_row+1)*finv(0.99,num_pc,X_row - num_pc)/(X_row*(X_row - num_pc));
T2UCL2=num_pc*(X_row-1)*finv(0.99,num_pc,X_row - num_pc)/(X_row - num_pc);
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
QUCL=g*chi2inv(0.99,h);





%���߼�⣺
%��׼������
n = size(Xtest,1);
% Xtest=(Xtest-repmat(X_mean,n,1))./repmat(X_std',n,1);
Xtest=(Xtest-repmat(X_mean,n,1));
%��T2 ͳ������ Qͳ����
[r,y] = size(P*P');
I = eye(r,y);
T2 = zeros(n,1);
Q = zeros(n,1);
for i = 1:n
T2(i)=Xtest(i,:)*P*inv(lamda_select)*P'*Xtest(i,:)'; %inv �������
Q(i) = norm((I - P*P')*Xtest(i,:)')^2;
end
Q=Q/QUCL;
T2=T2/T2UCL2;

% %��ͼ
% figure
% subplot(2,1,1);
% plot(1:n,T2,'k');
% title(' ��Ԫ����ͳ�����仯ͼ','FontName','simhei.ttf');
% xlabel(' ������','FontName','simhei.ttf');
% ylabel('T^2');
% hold on;
% line([0,n],[T2UCL1,T2UCL1],'LineStyle','--','Color','r');
% line([0,n],[T2UCL2,T2UCL2],'LineStyle','--','Color','g');
% subplot(2,1,2);
% plot(1:n,Q,'k');
% xlabel(' ������','FontName','simhei.ttf');
% ylabel('Q','FontName','simhei.ttf');
% hold on;
% line([0,n],[QUCL,QUCL],'LineStyle','--','Color','r');


% %����ͼ
% %1.ȷ�����ʧ��״̬�ĵ÷�
% S = Xtest(1,:)*P(:,1:num_pc);
% r = [];
% for i = 1:num_pc
% if S(i)^2/lamda(i) > T2UCL2/num_pc
% r = cat(2,r,i);   %  cat ����������
% end
% end
% %2.����ÿ���������������ʧ�ص÷ֵĹ���
% cont = zeros(length(r),5);
% for i = length(r)
% for j = 1:5
% cont(i,j) =abs(S(i)/D(i)*P(j,i)*Xtest(1,j));
% end
% end
% %3.����ÿ���������ܹ���
% CONTJ = zeros(5,1);
% for j = 1:5
% CONTJ(j) = sum(cont(:,j));
% end
% %4.����ÿ��������Q�Ĺ���
% e = Xtest(1,:)*(I - P*P');
% contq = e.^2;
% %5. ���ƹ���ͼ
% figure;
% subplot(2,1,1);
% bar(CONTJ,'k');
% xlabel(' ������','FontName','simhei.ttf');
% ylabel('T^2 ������ %','FontName','simhei.ttf');
% subplot(2,1,2);
% bar(contq,'k');
% xlabel(' ������','FontName','simhei.ttf');
% ylabel('Q ������ %','FontName','simhei.ttf');

end

