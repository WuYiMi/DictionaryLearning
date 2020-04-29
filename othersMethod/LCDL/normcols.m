function matout=normcols(matin)
l2norms = sqrt(sum(matin.*matin,1)+eps);  %二范数归一化
matout = matin./repmat(l2norms,size(matin,1),1);