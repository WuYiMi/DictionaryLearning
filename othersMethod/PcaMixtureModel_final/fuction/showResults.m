function  showResults(nT2,nSPE)
%SHOWRESULTS ���չʾ

[~,num]=size(nT2);
%��ͼ
figure
subplot(2,1,1);
plot(1:num,nT2,'k');
title('��Ԫ����ͳ�����仯ͼ','FontName','simhei.ttf');
xlabel('������','FontName','simhei.ttf');
ylabel('nT^2');
hold on;
line([0,num],[1,1],'LineStyle','--','Color','r');
subplot(2,1,2);
plot(1:num,nSPE,'k');
% axis([0 num 0 1.5]);
xlabel('������','FontName','simhei.ttf');
ylabel('nSPE','FontName','simhei.ttf');
hold on;
line([0,num],[1,1],'LineStyle','--','Color','r');

end

