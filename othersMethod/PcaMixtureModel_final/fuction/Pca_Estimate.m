function [ output_args ] = Pca_Estimate(data,test_data,u,E)
%使用pca模型进行统计评估
%   此处显示详细说明

Xtrain = double(data);
%载入测试数据
Xtest = double(test_data);
%标准化处理：
X_mean =u; %按列求Xtrain 平均值
X_std = diag(E); %求标准差
[X_row,X_col] = size(Xtrain); %求Xtrain 行、列数
% for i = 1:X_col
%Xtrain(:,i)=(Xtrain(:,i) - X_mean(i)./X_std(i));
%Xtest(:,i) = (Xtest(:,i) - X_mean(i)./X_std(i));
% end
Xtrain=(Xtrain-repmat(X_mean,X_row,1))./repmat(X_std',X_row,1);
%求协方差矩阵
sigmaXtrain=E;
%对协方差矩阵进行特征分解， lamda 为特征值构成的对角阵， T 的列为单位特征向量，且与lamda 中的特征值一一对应：
[D,P_all,lamda_select,P,num_pc]=selectLamdaP(E);
lamda=diag(D);
% [T,lamda] = eig(sigmaXtrain);
% % disp(' 特征根（由小到大） ');
% % disp(lamda);
% % disp(' 特征向量： ');
% % disp(T);
% %取对角元素( 结果为一列向量) ，即lamda 值，并上下反转使其从大到小排列，主元个数初值为1，若累计贡献率小于90%则增加主元个数
% D = flipud(diag(lamda));
% num_pc = 1;
% while sum(D(1:num_pc))/sum(D) < 0.9
% num_pc = num_pc +1;
% end
% %取与lamda 相对应的特征向量
% P = T(:,X_col-num_pc+1:X_col);

%求置信度为99%、95%时的T2 统计控制限
T2UCL1=num_pc*(X_row-1)*(X_row+1)*finv(0.99,num_pc,X_row - num_pc)/(X_row*(X_row - num_pc));
T2UCL2=num_pc*(X_row-1)*finv(0.99,num_pc,X_row - num_pc)/(X_row - num_pc);
%置信度为99%的Q统计控制限
% for i = 1:3
% theta(i) = sum((D(num_pc+1:X_col)).^i);
% end
% h0 = 1 - 2*theta(1)*theta(3)/(3*theta(2)^2);
% ca = norminv(0.99,0,1);
% QUCL = theta(1)*(h0*ca*sqrt(2*theta(2))/theta(1)+ 1 + theta(2)*h0*(h0 - 1)/theta(1)^2)^(1/h0);

[r,y] = size(P*P');
I = eye(r,y);
Q = zeros(X_row,1);
for i = 1:X_row
Q(i) = norm((I - P*P')*Xtrain(i,:)')^2;
end
g=var(Q)/(2*mean(Q));
h=mean(Q)/g;
QUCL=g*chi2inv(0.99,h);





%在线监测：
%标准化处理
n = size(Xtest,1);
% Xtest=(Xtest-repmat(X_mean,n,1))./repmat(X_std',n,1);
Xtest=(Xtest-repmat(X_mean,n,1));
%求T2 统计量， Q统计量
[r,y] = size(P*P');
I = eye(r,y);
T2 = zeros(n,1);
Q = zeros(n,1);
for i = 1:n
T2(i)=Xtest(i,:)*P*inv(lamda_select)*P'*Xtest(i,:)'; %inv 求逆矩阵
Q(i) = norm((I - P*P')*Xtest(i,:)')^2;
end
Q=Q/QUCL;
T2=T2/T2UCL2;

% %绘图
% figure
% subplot(2,1,1);
% plot(1:n,T2,'k');
% title(' 主元分析统计量变化图','FontName','simhei.ttf');
% xlabel(' 采样数','FontName','simhei.ttf');
% ylabel('T^2');
% hold on;
% line([0,n],[T2UCL1,T2UCL1],'LineStyle','--','Color','r');
% line([0,n],[T2UCL2,T2UCL2],'LineStyle','--','Color','g');
% subplot(2,1,2);
% plot(1:n,Q,'k');
% xlabel(' 采样数','FontName','simhei.ttf');
% ylabel('Q','FontName','simhei.ttf');
% hold on;
% line([0,n],[QUCL,QUCL],'LineStyle','--','Color','r');


% %贡献图
% %1.确定造成失控状态的得分
% S = Xtest(1,:)*P(:,1:num_pc);
% r = [];
% for i = 1:num_pc
% if S(i)^2/lamda(i) > T2UCL2/num_pc
% r = cat(2,r,i);   %  cat 矩阵按行连接
% end
% end
% %2.计算每个变量相对于上述失控得分的贡献
% cont = zeros(length(r),5);
% for i = length(r)
% for j = 1:5
% cont(i,j) =abs(S(i)/D(i)*P(j,i)*Xtest(1,j));
% end
% end
% %3.计算每个变量的总贡献
% CONTJ = zeros(5,1);
% for j = 1:5
% CONTJ(j) = sum(cont(:,j));
% end
% %4.计算每个变量对Q的贡献
% e = Xtest(1,:)*(I - P*P');
% contq = e.^2;
% %5. 绘制贡献图
% figure;
% subplot(2,1,1);
% bar(CONTJ,'k');
% xlabel(' 变量号','FontName','simhei.ttf');
% ylabel('T^2 贡献率 %','FontName','simhei.ttf');
% subplot(2,1,2);
% bar(contq,'k');
% xlabel(' 变量号','FontName','simhei.ttf');
% ylabel('Q 贡献率 %','FontName','simhei.ttf');

end

