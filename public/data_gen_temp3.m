function [train_data,test_data]=data_gen_temp3(Type,Size1,Size2,Size3)
    %% =========== CSTH Data 2000==========
    %% temp=temp*1.103 test21013
          load('F:\SDL1007\data\CSTH_MODE2\TEMP\trian2.mat')
          load('F:\SDL1007\data\CSTH_MODE2\TEMP\trian5.mat')
          load('F:\SDL1007\data\CSTH_MODE2\TEMP\test21013.mat')
          load('F:\SDL1007\data\CSTH_MODE2\TEMP\test51013.mat')
          train_data=[trian2(501:1500,:);trian5(501:1500,:)]';
          test_data=[test21013(351:450,:);test51013(351:450,:);test21013(901:1500,:)]';    
%          C= kmeans(train_data',2);
end
