function [train_data,test_data]=data_gen_flow3(Type,Size1,Size2,Size3)
    %% =========== CSTH Data 2000==========
    %% flow=flow*1.1 test5110
          load('F:\SDL1007\data\CSTH_MODE2\TEMP\trian4.mat')
          load('F:\SDL1007\data\CSTH_MODE2\TEMP\trian5.mat')
          load('F:\SDL1007\data\CSTH_MODE2\FLOW\mode45\test411.mat')
          load('F:\SDL1007\data\CSTH_MODE2\FLOW\mode45\test5110.mat')      
          train_data=[train4(501:1500,:);trian5(501:1500,:)]';
          test_data=[test411(701:800,:);test5110(351:450,:);test5110(801:1400,:)]';
end
