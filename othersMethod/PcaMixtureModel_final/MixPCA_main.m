clc
clear all
%% ---------------数据读取-------------
n_class=2; %类别数
data_split=[100,200];
%  载入 训练数据 和 测试数据
load('dataSet/sz_data2.mat')
train_data=train_data';
[num,dim]=size(train_data);
test_data=test_data(:,num+1:end)';
test_data=double(test_data);

%% ---------------离线建模--------------
%gmmEM算法估计

n_class = pcaEM_BYY(train_data);

[model,inx] = pcaEM2(train_data,n_class);
% %估计后的均值点 mu 对比 
EM_mu = model.mu; 
% %各个model的协方差对比
EM_E = model.E;
pai=model.pai;
T2UCL=[];
QUCL=[];
P=zeros(dim,dim,n_class);
lamda_select=zeros(dim,dim,n_class);
for i=1:n_class
    index=find(inx==i);
    [T2UCL(i),QUCL(i),p,ls]=Pca_offline(train_data(index,:),EM_mu(i,:),EM_E(:,:,i));
    [row,col]=size(p);
    P(1:row,1:col,i)=p;
    [row,col]=size(ls);
    lamda_select(1:row,1:col,i)=ls;
end

%% -------------在线监控---------------
%估算监测样本所属的工况
idx_class=calBayesian(test_data,n_class,EM_mu,EM_E,pai);

nSPE=[];
nT2=[];
for i=1:n_class
    idx=find(idx_class==i);
    P_i=clearEmpty(P(:,:,i));
    lamda_i=clearEmpty(lamda_select(:,:,i));
    T2UCL_i=T2UCL(i);
    QUCL_i=QUCL(i);
    [nT2(idx),nSPE(idx)]=Pca_online(test_data(idx,:),EM_mu(i,:),EM_E(:,:,i),T2UCL(i),QUCL(i),P_i,lamda_i);
end
%计算故障误报率和检出率
nT2_FAR=length(find(nT2(1:data_split(1))>1))/data_split(1);
nT2_FDR=length(find(nT2(data_split(1)+1:end)>1))/data_split(2);
nSPE_FAR=length(find(nSPE(1:data_split(1))>1))/data_split(1);
nSPE_FDR=length(find(nSPE(data_split(1)+1:end)>1))/data_split(2);
%% -------------可视化---------------
showResults(nT2,nSPE);
results_rate=[nT2_FAR,nT2_FDR,nSPE_FAR,nSPE_FDR];
results_nT2=nT2';
results_nSPE=nSPE';


