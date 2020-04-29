function [ limit ,dre] = cal( traindata,D,t,confidence)
% calculate historydata onlineDL & offlineDL(parameter:traindata) 
% reconstruction error and initial control limit
% 180918
dre = Dre(D,traindata,t);  %º∆À„ŒÛ≤Ó
range=KDE_fcn(dre,confidence);
limit=range(2);
end

