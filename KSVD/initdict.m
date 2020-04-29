function [ D,X ] = initdict( traindata,dictsize,iterations,t )
% wym 180903
% get the initializate dictionary by training historydata
D = []; 
para.data = traindata;
para.Tdata = t;
para.iternum = iterations;
para.memusage = 'high';
para.dictsize = dictsize;    % normalization
[D,X,E] = ksvd(para,'');    % ksvd process
end

