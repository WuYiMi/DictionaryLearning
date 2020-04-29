clear;
close all;
clc;

%% load data
% [train_data,test_data]=data_gen_temp3(); 
% [train_data,test_data]=data_gen_level2(); %dict_size=30-30-15 con=99%
% [train_data,test_data]=data_gen_flow3();
% [train_data,test_data]=data_gen_flow2();%30-30-15 99%  
[train_data,test_data]=data_gen_level3(); 
train_c1=train_data(:,1:1000);
train_c2=train_data(:,1001:2000);
full_data=[train_data,test_data];
%% parameter set up temp
t1 = 2;  % sparsity of every sub_dict
t2 = 2; % sparsity of dict
d_sizes=[60,60,15]; % 特色字典1,特色字典2,公共字典
dict_size=sum(d_sizes);  %字典总大小
iteration_int = 500;  % iteration number
iterations = 800;  % iteration number
numbers=[2000,100,100,600]; %训练数据，正常数据1,正常数据2和异常数据的数目
confidence=0.99; %置信度
CPV1=0.85;
CPV2=0.85;%方差贡献率
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
[num_Pcs,pca_fault,pca_ucl,pca_error]=Pca_model(train_data,test_data,[0,sum(numbers(2:3)),numbers(4)],confidence,CPV1);
fprintf('\nPca_model done!');

%% run mixPCA
% X=mapminmax(train_data);
% Y=mapminmax(test_data);
% X=zscore(train_data);
% Y=zscore(test_data);
[mix_pca_fault,mix_pca_error,mix_pca_ucl]=MixPCA_fcn(train_data,test_data,[0,sum(numbers(2:3)),numbers(4)],confidence,CPV2);
fprintf('\nMixPca_model done!');

%% run IFAC paper

[lcdl_fault,lcdl_thres,lcdl_drr]=Lcdl_function(train_data,full_data,[numbers(1),sum(numbers(2:3)),numbers(4)],params_L,confidence);
fprintf('\nLCDL done!');

%% Our method
% offline learning
D=offlineLearn(train_data,train_c1,train_c2,d_sizes,t1,para,iterations,iteration_int);

% online Monitoring
[sdl_fault,sdl_thres,sdl_dre,sdl_label_rate,sdl_dre1,sdl_label] = onlineMonitor(D,d_sizes,full_data,t2,confidence,numbers);



%% show results
Results_FaultRates=[pca_fault,mix_pca_fault,lcdl_fault,sdl_fault];
Results_Errors=[pca_error';mix_pca_error';lcdl_drr;sdl_dre'];
Results_Thres=[pca_ucl';mix_pca_ucl';lcdl_thres;sdl_thres];

drawPlot(Results_Errors(1,:)',Results_Thres(1,:),'T^2',3,2,1);
drawPlot(Results_Errors(2,:)',Results_Thres(2,:),'SPE',3,2,2);
drawPlot(Results_Errors(3,:)',Results_Thres(3,:),'nT^2',3,2,3);
drawPlot(Results_Errors(4,:)',Results_Thres(4,:),'nSPE',3,2,4);
drawPlot(Results_Errors(5,:)',Results_Thres(5,:),'LCDL',3,2,5);
drawPlot(Results_Errors(6,:)',Results_Thres(6,:),'SDL',3,2,6);

Results_Errors=Results_Errors';
fprintf('\n END!');

