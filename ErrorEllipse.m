%  [ traindata1,traindata2,testdata,m1,m2,m3,m4 ] = gene_data();

%% ��������
load('matlab.mat');
% traindata1=m2;
% traindata2=m4;

%% ��ά�������Ƚ���PCA��ά
train_data = [traindata1(:,201:300),traindata2(:,201:300)];
CPV=0.95;
Confidence=0.95;
[T2_thres, Q_thres, P,num_pc,X_mean,pp,lamda,sigmaXtrain ]=PCA ([traindata1,traindata2], CPV , Confidence )
P=[pp(:,1),pp(:,3)];
PCs=train_data'*P;


%% ��ά�������Թ���ά���裬ֱ�ӻ���ԭʼ���ݣ���ʱԭʼ��������ӦΪPCs
scatter(PCs(1:100,1),PCs(1:100,2));
hold on;

scatter(PCs(101:200,1),PCs(101:200,2));
hold on;


%% ����������Բ��������Ҫ�������޸�

datamatrix=PCs(101:200,:);
p=0.90
data = datamatrix;

% ����Э���������������������ֵ

covariance = cov(data);

[eigenvec, eigenval ] = eig(covariance);

% ��ȡ�����������

[largest_eigenvec_ind_c, r] = find(eigenval == max(max(eigenval)));

largest_eigenvec = eigenvec(:, largest_eigenvec_ind_c);

% ��ȡ�������ֵ

largest_eigenval = max(max(eigenval));

% ������С������������С����ֵ

if(largest_eigenvec_ind_c == 1)

    smallest_eigenval = max(eigenval(:,2))

    smallest_eigenvec = eigenvec(:,2);

else

    smallest_eigenval = max(eigenval(:,1))

    smallest_eigenvec = eigenvec(1,:);

end

% ����X��������������ֱ�ӵļнǣ�ֵ��Ϊ[-pi,pi]

angle = atan2(largest_eigenvec(2), largest_eigenvec(1));

% ���н�Ϊ��ʱ����2pi����ֵ

if(angle < 0)

    angle = angle + 2*pi;

end

% �������ݵ����о�ֵ����ʽΪ2��1�ľ���

avg = mean(data);

% ����������Բ�Ĳ�������������ֵ����ת�Ƕȡ���ֵ���������

chisquare_val = sqrt(chi2inv(p,2));

theta_grid = linspace(0,2*pi);

phi = angle;

X0=avg(1);

Y0=avg(2);

a=chisquare_val*sqrt(largest_eigenval);

b=chisquare_val*sqrt(smallest_eigenval);

% ����ԲͶ�䵽ֱ���������� 

ellipse_x_r  = a*cos( theta_grid );

ellipse_y_r  = b*sin( theta_grid );

% ��ת����

R = [ cos(phi) sin(phi); -sin(phi) cos(phi) ];

% ��ˣ���ת��Բ

r_ellipse = [ellipse_x_r;ellipse_y_r]' * R;

%% ��ӡ������Բ
ans1=r_ellipse(:,1) + X0;
ans2=r_ellipse(:,2) + Y0;
ans=[ans1,ans2];
% plot(r_ellipse(:,1) + X0,r_ellipse(:,2) + Y0,'-')
% 
% hold on;

