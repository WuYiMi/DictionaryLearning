function [Dinit,X]=initialization(training_feats,dictsize,iterations,sparsitythres)
Dinit = []; 
para.data = training_feats;
para.Tdata = sparsitythres;
para.iternum = iterations;
para.memusage = 'high';
    % normalization
para.dictsize = dictsize;
    % ksvd process
[Dinit,X,E] = ksvd(para,'');
end
