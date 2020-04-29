function drawPlot(errors,thres,yl,a,b,c)
if nargin == 3
    a=0;b=0;c=0;
end

if(a==0)
    figure();
else    
    subplot(a,b,c);
end
plot(1:size(errors,1),errors,'k');
hold on;
ylabel(yl);
hold on;
line([0,size(errors,1)],[thres,thres],'LineStyle','--','Color','r');

end