function  showResults(nT2,nSPE)
%SHOWRESULTS 结果展示

[~,num]=size(nT2);
%绘图
figure
subplot(2,1,1);
plot(1:num,nT2,'k');
title('主元分析统计量变化图','FontName','simhei.ttf');
xlabel('采样数','FontName','simhei.ttf');
ylabel('nT^2');
hold on;
line([0,num],[1,1],'LineStyle','--','Color','r');
subplot(2,1,2);
plot(1:num,nSPE,'k');
% axis([0 num 0 1.5]);
xlabel('采样数','FontName','simhei.ttf');
ylabel('nSPE','FontName','simhei.ttf');
hold on;
line([0,num],[1,1],'LineStyle','--','Color','r');

end

