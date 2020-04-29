function [num_pc,pca_fault,pca_ucl,pca_error]=Pca_model(Xtrain,Xtest,numbers,confidence,CPV)
Xtrain=Xtrain';
Xtest=Xtest';
%��׼��������
X_mean = mean(Xtrain); %������Xtrain ƽ��ֵ
X_std = std(Xtrain); %���׼��
[X_row,X_col] = size(Xtrain); %��Xtrain �С�����

% end
Xtrain=(Xtrain-repmat(X_mean,X_row,1))./repmat(X_std,X_row,1);
%  Xtrain=(Xtrain-repmat(X_mean,X_row,1));
%��Э�������
sigmaXtrain = cov(Xtrain);
%��Э���������������ֽ⣬ lamda Ϊ����ֵ���ɵĶԽ��� T ����Ϊ��λ��������������lamda �е�����ֵһһ��Ӧ��
[T,lamda] = eig(sigmaXtrain);

%ȡ�Խ�Ԫ��( ���Ϊһ������) ����lamda ֵ�������·�תʹ��Ӵ�С���У���Ԫ������ֵΪ1�����ۼƹ�����С��90%��������Ԫ����
D = flipud(diag(lamda));
num_pc = 1;
while sum(D(1:num_pc))/sum(D) < CPV
num_pc = num_pc +1;
end
%ȡ��lamda ���Ӧ����������
P = T(:,X_col-num_pc+1:X_col);
%�����Ŷ�Ϊ99%��95%ʱ��T2 ͳ�ƿ�����

T2UCL2=num_pc*(X_row-1)*(X_row+1)*finv(confidence,num_pc,X_row - num_pc)/(X_row*(X_row - num_pc));
%���Ŷ�Ϊ99%��Qͳ�ƿ�����
for i = 1:3
theta(i) = sum((D(num_pc+1:X_col)).^i);
end
h0 = 1 - 2*theta(1)*theta(3)/(3*theta(2)^2);
ca = norminv(confidence,0,1);
QUCL = theta(1)*(h0*ca*sqrt(2*theta(2))/theta(1)+ 1 + theta(2)*h0*(h0 - 1)/theta(1)^2)^(1/h0);
%���߼�⣺
%��׼������
[n,m]= size(Xtest);
Xtest=(Xtest-repmat(X_mean,n,1))./repmat(X_std,n,1);
% Xtest=(Xtest-repmat(X_mean,n,1));
%��T2 ͳ������ Qͳ����
[r,y] = size(P*P');
I = eye(r,y);
T2 = zeros(n,1);
Q = zeros(n,1);

for i = 1:n
T2(i)=Xtest(i,:)*P*inv(lamda(m-num_pc+1:m,m-num_pc+1:m))*P'*Xtest(i,:)'; %inv �������
Q(i) = Xtest(i,:)*(I - P*P')*Xtest(i,:)';
end

hide=numbers(1);
normal=numbers(2);
abnormal=numbers(3);
show_T2=T2(hide+1:end,:);
show_Q=Q(hide+1:end,:);

%% ����T2 ������
label = ones(size(show_T2,1),1);
for i=1:size(Xtest(hide+1:end,:),1)
    if(show_T2(i)>T2UCL2)
       label(i,:)=0;    
    end
end

T2_FAR=(length(find(label(1:normal)==0))/normal);  %��������鱨��
T2_FDR=length(find(label(normal+1:end)==0))/abnormal;  %����Ԥ����


%% ����SPE ������
label = ones(size(show_Q,1),1);
for i=1:size(Xtest(hide+1:end,:),1)
    if(show_Q(i)>QUCL)
       label(i,:)=0;    
    end
end

SPE_FAR=(length(find(label(1:normal)==0))/normal);  %��������鱨��
SPE_FDR=length(find(label(normal+1:end)==0))/abnormal;  %����Ԥ����

pca_fault=[T2_FAR,T2_FDR,SPE_FAR,SPE_FDR];
pca_ucl=[T2UCL2,QUCL];
pca_error=[show_T2,show_Q];