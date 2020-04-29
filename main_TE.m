clear all
close all
clc;

%% load data
% ���ñ�������
Results = [];
Lable_Rate = [];    
fid1 = fopen('Results.txt','wt');
fid2 = fopen('Rate.txt','wt');
for fault_id=8:8
% fault_id=2; %��������
% [train_data,test_data,full_data,train_c1,train_c2]=load_te_data(fault_id);
% [train_data,test_data,full_data,train_c1,train_c2]=loadtedata2(fault_id);
[train_data,test_data,full_data,train_c1,train_c2]=loadtedata3(fault_id);
%% parameter set up
t1 = 2;  % sparsity of every dict
t2 = 2; % sparsity of dict
d_sizes=[80,80,40]; % ��ɫ�ֵ�1,��ɫ�ֵ�2,�����ֵ�
dict_size=sum(d_sizes);  %�ֵ��ܴ�С
iteration_int = 100;  % iteration number
iterations = 1200;  % iteration number
% numbers=[4000,200,200,600]; %ѵ�����ݣ���������1,��������2���쳣���ݵ���Ŀ
numbers=[12000,100,100,200]; %ѵ�����ݣ���������1,��������2���쳣���ݵ���Ŀ
confidence=0.95; %���Ŷ�
CPV=0.85;%�������
para=[10,10,10];

params_L.sparsitythres =t2; % sparsity prior
params_L.sqrt_alpha = 4; % weights for label constraint term
params_L.sqrt_beta = 2; % weights for classification err term
params_L.dictsize = dict_size; % dictionary size
params_L.iterations = iterations; % iteration number
params_L.iterations4ini = iteration_int; % iteration number for initialization
params_L.cluster_num=2;



%% Others method
%% run PCA
tic;
[num_Pcs,pca_fault,pca_ucl,pca_error]=Pca_model(train_data,test_data,[0,sum(numbers(2:3)),numbers(4)],confidence,CPV);
fprintf('\nPca_model done!');
toc;

%% run mixPCA
tic;
[mix_pca_fault,mix_pca_error,mix_pca_ucl]=MixPCA_fcn(train_data,test_data,[0,sum(numbers(2:3)),numbers(4)],confidence,CPV);
fprintf('\nMixPca_model done!');
toc;

%% run IFAC paper
tic;
[lcdl_fault,lcdl_thres,lcdl_drr]=Lcdl_function(train_data,full_data,[numbers(1),sum(numbers(2:3)),numbers(4)],params_L,confidence);
fprintf('\nLCDL done!');
toc;

%% Our method

% offline learning
tic;
D=offlineLearn(train_data,train_c1,train_c2,d_sizes,t1,para,iterations,iteration_int);
fprintf('\nofflineLearn done!');
toc;
% online Monitoring
tic;
[sdl_fault,sdl_thres,sdl_dre,sdl_label_rate,sdl_dre1,sdl_label] = onlineMonitor(D,d_sizes,full_data,t2,confidence,numbers);
fprintf('\nonlineMonitor done!');
toc;
fprintf('\nSDL done!');


%% show results
Results_FaultRates=[pca_fault,mix_pca_fault,lcdl_fault,sdl_fault];
Results_Errors=[pca_error';mix_pca_error';lcdl_drr;sdl_dre'];
Results_Thres=[pca_ucl';mix_pca_ucl';lcdl_thres;sdl_thres];

drawPlot(Results_Errors(1,:)',Results_Thres(1,:),'T^2',3,2,1);
drawPlot(Results_Errors(2,:)',Results_Thres(2,:),'SPE',3,2,2);
drawPlot(Results_Errors(3,:)',Results_Thres(3,:),'nT^2',3,2,3);
drawPlot(Results_Errors(4,:)',Results_Thres(4,:),'nSPE',3,2,4);
drawPlot(Results_Errors(5,:)',Results_Thres(5,:),'LCDL',3,2,5);
drawPlot(Results_Errors(6,:)',Results_Thres(6,:),'RDL',3,2,6);
Results_Errors=Results_Errors';
fprintf('\n END!');
Results = [Results;Results_FaultRates];%% ��¼28�����
Lable_Rate = [Lable_Rate; sdl_label_rate];%% ��¼28�������µ�ģ̬ʶ����
save('Res.mat','Results','Lable_Rate');
%% д�ļ�
  % д��FDR,FAR
fprintf(fid1,'%g\t',Results_FaultRates);%�Կո�ķ�ʽд�벻ͬ������
fprintf(fid1,'\n');%����
  % д��ģ̬ʶ����
fprintf(fid2,'%g\t',sdl_label_rate);
fprintf(fid2,'\n');
end
fclose(fid1);
fclose(fid2);


