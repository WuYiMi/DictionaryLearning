load('matlab.mat');
train_c1=traindata1;
train_c2=traindata2;
test_data=testdata;
% [train_c1,train_c2,test_data]=gene_data();
train_data=[train_c1,train_c2];
full_data=[train_data,test_data];

t1 = 1;  % sparsity of every sub_dict
t2 = 1; % sparsity of dict
%t2=2;
d_sizes=[30,30,15]; % 特色字典1,特色字典2,公共字典
dict_size=sum(d_sizes);  %字典总大小
iteration_int = 200;  % iteration number
iterations = 500;  % iteration number
numbers=[4000,100,100,200]; %训练数据，正常数据1,正常数据2和异常数据的数目
number=[4000,200,200];
confidence=0.99; %置信度
CPV=0.85;%方差贡献率
para=[10,10,10];

params_L.sparsitythres =t2; % sparsity prior
params_L.sqrt_alpha = 4; % weights for label constraint term
params_L.sqrt_beta = 2; % weights for classification err term
params_L.dictsize = dict_size; % dictionary size
params_L.iterations = iterations; % iteration number
params_L.iterations4ini = iteration_int; % iteration number for initialization
params_L.cluster_num=2;
%% offline dictionary learning
% offline learning
[D_offinit]=initdict(train_data,dict_size,iterations,t1);
[limit_off,dre_off]=cal(train_data,D_offinit,t1,confidence);
[dre_testoff,state_off]=cal_test(test_data,D_offinit,t1,limit_off);
% time2=toc; 

 FAR_off=length(find(state_off(1:number(2))==0))/number(2);
 FDR_off=length(find(state_off(number(2)+1:number(2)+number(3))==0))/number(3);
 limit_off=limit_off*ones(size(dre_testoff));
drawPlot([dre_testoff],limit_off,'OFDL',2,2,3); 

%% Our method
% offline learning
D=offlineLearn(train_data,train_c1,train_c2,d_sizes,t1,para,iterations,iteration_int);

% online Monitoring
[sdl_fault,sdl_thres,sdl_dre,sdl_label_rate,sdl_dre1,sdl_label] = onlineMonitor(D,d_sizes,full_data,t2,confidence,numbers);

drawPlot(sdl_dre,sdl_thres','SDL',2,2,4);

