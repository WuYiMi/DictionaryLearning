function [ results_rate,results_error,results_ucl ] = MixPCA_fcn(train_data,test_data,numbers,confidence,CPV)
warning('off');
%% ---------------���ݶ�ȡ-------------
%  ���� ѵ������ �� ��������
train_data=train_data';
% train_data=zscore(train_data);
[num,dim]=size(train_data);
test_data=test_data';
% test_data=zscore(test_data);
t_size=size(test_data,1);
% test_data=double(test_data);

%% ---------------���߽�ģ--------------
%gmmEM�㷨����

n_class = pcaEM_BYY(train_data);

[model,inx] = pcaEM2(train_data,n_class);
% %���ƺ�ľ�ֵ�� mu �Ա� 
EM_mu = model.mu; 
% %����model��Э����Ա�
EM_E = model.E;
pai=model.pai;
T2UCL=[];
QUCL=[];
P=zeros(dim,dim,n_class);
lamda_select=zeros(dim,dim,n_class);
for i=1:n_class
    index=find(inx==i);
    [T2UCL(i),QUCL(i),p,ls]=Pca_offline(train_data(index,:),EM_mu(i,:),EM_E(:,:,i),confidence,CPV);
    [row,col]=size(p);
    P(1:row,1:col,i)=p;
    [row,col]=size(ls);
    lamda_select(1:row,1:col,i)=ls;
end

%% -------------���߼��---------------
%���������������Ĺ���
idx_class=calBayesian(test_data,n_class,EM_mu,EM_E,pai);

nSPE=[];
nT2=[];
% test_data = 8*zscore(test_data);
for i=1:n_class
    idx=find(idx_class==i);
    P_i=clearEmpty(P(:,:,i));
    lamda_i=clearEmpty(lamda_select(:,:,i));
    T2UCL_i=T2UCL(i);
    QUCL_i=QUCL(i);
    [nT2(idx),nSPE(idx)]=Pca_online(test_data(idx,:),EM_mu(i,:),EM_E(:,:,i),T2UCL(i),QUCL(i),P_i,lamda_i);
end
%����������ʺͼ����
nT2_FAR=length(find(nT2(1:numbers(2))>1))/numbers(2);
nT2_FDR=length(find(nT2(numbers(2)+1:end)>1))/numbers(3);
nSPE_FAR=length(find(nSPE(1:numbers(2))>1))/numbers(2);
nSPE_FDR=length(find(nSPE(numbers(2)+1:end)>1))/numbers(3);
%% -------------���ӻ�---------------
%showResults(nT2,nSPE);
results_rate=[nT2_FAR,nT2_FDR,nSPE_FAR,nSPE_FDR];
results_error=[nT2',nSPE'];
results_ucl=[1,1];
end

