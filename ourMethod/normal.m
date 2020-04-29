function Data_norm = normal(Data,Data_mean,Data_std)
X_col = size(Data,2);
 Data_norm = Data./repmat(Data_std,1,X_col);
% Data_norm = (Data-repmat(Data_mean,1,X_col))./repmat(Data_std,1,X_col);
end

