function [ traindata1,traindata2,testdata ] = gene( n,m )
%UNTITLED Summary of this function goes here
%   18/09/09
A = [0.5768 0.3766;0.7382 0.0566;0.8291 0.4009;0.6519 0.2070;0.3972 0.8045];
B= [1,0;0,1;0,0;0,0;0,0];
X1=[];
for i=1:n
    s1 = normrnd(-10,sqrt(1));
    s2 = normrnd(-5,sqrt(1));
    s3= normrnd(-6,sqrt(1));
    s4= normrnd(5,sqrt(1));
    S1=[s1;s2];
    S2=[s3;s4];
    e1 = normrnd(0,0.01,5,1);
%     m1(:,i)=A*S1;
%     m2(:,i)=B*S2;
    x1=A*S1+B*S2+e1;
    X1=[X1,x1];
end

X2=[];
for i=1:m
    s1 = normrnd(-10,sqrt(1));
    s2 = normrnd(-5,sqrt(1));
    s3 = unifrnd(2,3);
    s4 = normrnd(7,sqrt(1));

%         s3 = unifrnd(-3,-2);
%         s4 = normrnd(5,sqrt(1));
    S1=[s1;s2];
    S2=[s3;s4];
    e1 = normrnd(0,0.01,5,1);
%     m3(:,i)=A*S1;
%     m4(:,i)=B*S2;
    x1=A*S1+B*S2+e1;
    X2=[X2,x1];
end



Y1=[];
for i=1:100
    s1 = normrnd(-10,sqrt(1));
    s2 = normrnd(-5,sqrt(1));
    s3= normrnd(-6,sqrt(1));
    s4= normrnd(5,sqrt(1));
    S1=[s1;s2];
    S2=[s3;s4];
    e1 = normrnd(0,0.01,5,1);
    x1=A*S1+B*S2+e1;
    Y1=[Y1,x1];
end

Y2=[];
for i=1:100
    s1 = normrnd(-10,sqrt(1));
    s2 = normrnd(-5,sqrt(1));
    s3 = unifrnd(2,3);
    s4 = normrnd(7,sqrt(1));
%         s3 = unifrnd(-3,-2);
%         s4 = normrnd(5,sqrt(1));
    S1=[s1;s2];
    S2=[s3;s4];
    e1 = normrnd(0,0.01,5,1);
    x1=A*S1+B*S2+e1;
    Y2=[Y2,x1];
end

Y3=[];
for i=1:200
    s1 = normrnd(-10,sqrt(1));
    s2 = normrnd(-5,sqrt(1));
    s3 = unifrnd(2,3);
%         s3= normrnd(-10,sqrt(1));
    s4 = normrnd(7,sqrt(1));
    S1=[s1;s2];
    S2=[s3;s4];
    e1 = normrnd(0,0.5,5,1);
    x1=A*S1+B*S2+e1;
%     x1(3) = x1(3) - 1.0;
%     x1(4) = x1(4) + 0.9;
    x1(1) = x1(1) - 2.8;
    x1(2) = x1(2) - 3.8;
    Y3=[Y3,x1];
end
traindata1=X1;
traindata2=X2;
testdata=[Y1,Y2,Y3];
end


