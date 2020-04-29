function [train_data,test_data,full_data,train_c1,train_c2]= load_te_data(fault_id)
A=load('C:\Users\wym\Desktop\Mode3Fault\data\TEmode3fault\Mode1-fs.mat');
A=A.simout;
A=A';
B=load(['data/TEmode3fault/Mode3-fs' int2str(fault_id) '.mat']);
B=B.simout;
B=B';
% X1=A(1:22,5001:7000);
% X2=B(1:22,2801:4800);
% T1=A(1:22,7001:7200);
% T2=B(1:22,4801:5000);
% T3=B(1:22,5001:5600);

X1=A(1:22,6001:7000); %1000ѵ����1
X2=B(1:22,3901:4900); %1000ѵ����2
T1=A(1:22,7001:7100); %100���Լ�1������
T2=B(1:22,4901:5000); %100���Լ�2������
T3=B(1:22,5001:5200); %200���Լ�2������

train_data=[X1,X2];
test_data=[T1,T2,T3];

full_data=[X1,X2,test_data];
train_c1=X1;
train_c2=X2;
