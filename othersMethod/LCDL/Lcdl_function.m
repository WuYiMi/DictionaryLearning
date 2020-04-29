function [lcdl_fault,lcdl_thres,lcdl_drr]=Lcdl_function(train_data,test_data,numbers,params,confidence)


%% constant
sparsitythres =params.sparsitythres; % sparsity prior
sqrt_alpha = params.sqrt_alpha; % weights for label constraint term
sqrt_beta =  params.sqrt_beta; % weights for classification err term
dictsize = params.dictsize; % dictionary size
iterations = params.iterations; % iteration number
% iterations4ini = params.iterations4ini; % iteration number for initialization
 iterations4ini = 1000;
cluster_num = params.cluster_num;
[train_label,c]=kmeans(train_data',cluster_num);
train_label=train_label';
%% dictionary learning process
% get initial dictionary Dinit and Winit
fprintf('\nLC-KSVD initialization... ');
% D=D0  Q=Q0  Y=training  W=W0   A=T
[Dinit,Tinit,Winit,Q_train] = initialization4LCKSVD(train_data,train_label,dictsize,iterations4ini,sparsitythres);
fprintf('done!');

% run LC K-SVD Training (reconstruction err + class penalty)
fprintf('\nDictionary learning by LC-KSVD1...');
[D1,X1,T1,W1] = labelconsistentksvd1(train_data,Dinit,Q_train,Tinit,train_label,iterations,sparsitythres,sqrt_alpha);
fprintf('done!');



%%  calculate DRR
[drr1,a_new1]=calculateDrrLCDL(D1,test_data,sparsitythres);

hide=numbers(1);
normal=numbers(2);
abnormal=numbers(3);
show_drr=drr1(:,hide+1:end);


drr1_train = confidence*drr1(1:hide);
fault_thres = max(drr1_train);
% fault_thres=calculateThres(drr1(1:hide),0.02);

label = ones(size(test_data,2),1);
for i=1:size(test_data,2)
    if(drr1(i)>fault_thres)
       label(i)=0;    
    end
end

FAR=(length(find(label(hide+1:hide+normal)==0))/normal);  %计算故障虚报率
FDR=length(find(label(hide+normal+1:end)==0))/abnormal;  %故障预报率



lcdl_fault=[FAR,FDR];
lcdl_thres=fault_thres;
lcdl_drr=show_drr;


% axis([0 size(test_data,2),0 2]);
