clear all
close all
clc;

%% load data
% load('matlab.mat')
[train_c1,train_c2,test_data]=gene_data();
% load('F:\SDL1007\data\numerical\revised\matlab.mat');
train_data=[train_c1,train_c2];
full_data=[train_data,test_data];

%% parameter set up
t1 = 1;  % sparsity of every sub_dict
t2 = 1; % sparsity of dict
%t2=2;
d_sizes=[30,30,15]; % 特色字典1,特色字典2,公共字典
dict_size=sum(d_sizes);  %字典总大小
iteration_int = 200;  % iteration number
iterations = 500;  % iteration number
numbers=[4000,100,100,200]; %训练数据，正常数据1,正常数据2和异常数据的数目
confidence=0.96; %置信度
CPV=0.85;%方差贡献率
para=[10,10,10];

params_L.sparsitythres =t2; % sparsity prior
params_L.sqrt_alpha = 4; % weights for label constraint term
params_L.sqrt_beta = 2; % weights for classification err term
params_L.dictsize = dict_size; % dictionary size
params_L.iterations = iterations; % iteration number
params_L.iterations4ini = iteration_int; % iteration number for initialization
params_L.cluster_num=2;

%% Others method
% %% run PCA
% [num_Pcs,pca_fault,pca_ucl,pca_error]=Pca_model(train_data,test_data,[0,sum(numbers(2:3)),numbers(4)],confidence,CPV);
% fprintf('\nPca_model done!');
% 
% %% run mixPCA
% [mix_pca_fault,mix_pca_error,mix_pca_ucl]=MixPCA_fcn(train_data,test_data,[0,sum(numbers(2:3)),numbers(4)],confidence,CPV);
% fprintf('\nMixPca_model done!');
% 
% %% run IFAC paper
% 
% [lcdl_fault,lcdl_thres,lcdl_drr]=Lcdl_function(train_data,full_data,[numbers(1),sum(numbers(2:3)),numbers(4)],params_L,confidence);
% fprintf('\nLCDL done!');

%% individual learning 
D=offlineLearn_R(train_data,train_c1,train_c2,d_sizes,t1,para,iterations,iteration_int);
[dl_fault,dl_thres,dl_dre,dl_label_rate,dl_dre1,dl_label] = onlineMonitor_R(D,d_sizes,full_data,t2,confidence,numbers);

%% Our method
% offline learning
D=offlineLearn(train_data,train_c1,train_c2,d_sizes,t1,para,iterations,iteration_int);

% online Monitoring
[sdl_fault,sdl_thres,sdl_dre,sdl_label_rate,sdl_dre1,sdl_label] = onlineMonitor(D,d_sizes,full_data,t2,confidence,numbers);



%% show results
Results_FaultRates=[dl_fault,sdl_fault];
Results_Errors=[dl_dre';sdl_dre'];
Results_Thres=[dl_thres;sdl_thres];

drawPlot(Results_Errors(1,:)',Results_Thres(1,:),'IDL',3,2,1);
drawPlot(Results_Errors(2,:)',Results_Thres(2,:),'SDL',3,2,2);
Results_Errors=Results_Errors';
fprintf('\n END!');

