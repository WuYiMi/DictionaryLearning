%  [ traindata1,traindata2,testdata,m1,m2,m3,m4 ] = gene_data();

%% 导入数据
load('matlab.mat');
% traindata1=m2;
% traindata2=m4;

%% 高维数据首先进行PCA降维
train_data = [traindata1(:,201:300),traindata2(:,201:300)];
CPV=0.95;
Confidence=0.95;
[T2_thres, Q_thres, P,num_pc,X_mean,pp,lamda,sigmaXtrain ]=PCA ([traindata1,traindata2], CPV , Confidence )
P=[pp(:,1),pp(:,3)];
PCs=train_data'*P;


%% 二维数据则略过降维步骤，直接画出原始数据，此时原始数据名称应为PCs
scatter(PCs(1:100,1),PCs(1:100,2));
hold on;

scatter(PCs(101:200,1),PCs(101:200,2));
hold on;


%% 计算置信椭圆，如无需要，请勿修改

datamatrix=PCs(101:200,:);
p=0.90
data = datamatrix;

% 计算协方差矩阵、特征向量、特征值

covariance = cov(data);

[eigenvec, eigenval ] = eig(covariance);

% 求取最大特征向量

[largest_eigenvec_ind_c, r] = find(eigenval == max(max(eigenval)));

largest_eigenvec = eigenvec(:, largest_eigenvec_ind_c);

% 求取最大特征值

largest_eigenval = max(max(eigenval));

% 计算最小特征向量和最小特征值

if(largest_eigenvec_ind_c == 1)

    smallest_eigenval = max(eigenval(:,2))

    smallest_eigenvec = eigenvec(:,2);

else

    smallest_eigenval = max(eigenval(:,1))

    smallest_eigenvec = eigenvec(1,:);

end

% 计算X轴和最大特征向量直接的夹角，值域为[-pi,pi]

angle = atan2(largest_eigenvec(2), largest_eigenvec(1));

% 当夹角为负时，加2pi求正值

if(angle < 0)

    angle = angle + 2*pi;

end

% 计算数据的两列均值，格式为2乘1的矩阵

avg = mean(data);

% 配置置信椭圆的参数，包括卡方值、旋转角度、均值、长短轴距

chisquare_val = sqrt(chi2inv(p,2));

theta_grid = linspace(0,2*pi);

phi = angle;

X0=avg(1);

Y0=avg(2);

a=chisquare_val*sqrt(largest_eigenval);

b=chisquare_val*sqrt(smallest_eigenval);

% 将椭圆投射到直角坐标轴中 

ellipse_x_r  = a*cos( theta_grid );

ellipse_y_r  = b*sin( theta_grid );

% 旋转矩阵

R = [ cos(phi) sin(phi); -sin(phi) cos(phi) ];

% 相乘，旋转椭圆

r_ellipse = [ellipse_x_r;ellipse_y_r]' * R;

%% 打印置信椭圆
ans1=r_ellipse(:,1) + X0;
ans2=r_ellipse(:,2) + Y0;
ans=[ans1,ans2];
% plot(r_ellipse(:,1) + X0,r_ellipse(:,2) + Y0,'-')
% 
% hold on;


