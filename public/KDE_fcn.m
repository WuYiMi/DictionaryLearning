function range=KDE_fcn(x,a)
pd = fitdist(x,'Kernel');
t=fmincon(@(x)icdf(pd,x)-icdf(pd,x-a),a,[],[],[],[],[a],[1]);   %a�����趨�����Ÿ���
range=[icdf(pd,t-a), icdf(pd,t)];  %�����������