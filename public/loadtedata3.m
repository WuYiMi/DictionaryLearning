function [train_data,test_data,full_data,train_c1,train_c2]= loadtedata3(fault_id)
A=load('F:\SDL0912\data\mode1fault10000\m3.mat');
A=A.simout;
A=A';
B=load(['data/mode1fault10000/m1f' int2str(fault_id) '.mat']);
B=B.simout;
B=B';
% X1=A(1:22,5001:7000);
% X2=B(1:22,2801:4800);
% T1=A(1:22,7001:7200);
% T2=B(1:22,4801:5000);
% T3=B(1:22,5001:5600);

X1=A(1:31,2001:8000); %1000训练集1
X2=B(1:31,2001:8000); %1000训练集2
T1=A(1:31,8001:8100); %100测试集1，正常
T2=B(1:31,8001:8100); %100测试集2，正常
T3=B(1:31,9501:9700); %200测试集2，故障

train_data=[X1,X2];
test_data=[T1,T2,T3];

full_data=[X1,X2,test_data];
train_c1=X1;
train_c2=X2;
