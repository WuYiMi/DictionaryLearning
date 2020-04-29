function idx_class = calBayesian( X,K,mu,E,pai )
%calBayesian 贝叶斯后验概率计算
    [num_data,~]=size(X);
    Yz = zeros(num_data,K);
    for n = 1:num_data
        Y_nK = zeros(1,K);
        for k=1:K
            Y_nK(k) = pai(k)* Gaussian_Improved(X(n,:),mu(k,:),E(:,:,k));
        end
        Yz(n,:) = Y_nK/sum(Y_nK);
    end
   [~,idx_class]=max(Yz,[],2);
end


