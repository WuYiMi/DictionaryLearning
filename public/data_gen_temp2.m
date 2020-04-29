function [train_data,test_data]=data_gen_temp2(Type,Size1,Size2,Size3)
    %% =========== CSTH Data 2000==========
          load('F:\SDL1007\data\CSTH_SENSOR_FAULT\Level_fault\Level_fault_traindata_mode5.5.mat');
          load('F:\SDL1007\data\CSTH_SENSOR_FAULT\Level_fault\Level_fault_traindata_mode0.mat');
          load('F:\SDL1007\data\CSTH_SENSOR_FAULT\Temperature_fault\Mode1108.mat')
          load('F:\SDL1007\data\CSTH_SENSOR_FAULT\Temperature_fault\Mode2108.mat');
          train_data=[TrainData1(501:1500,:);TrainData2(501:1500,:)]';
          test_data=[Mode1(351:450,:);Mode2(351:450,:);Mode2(801:1400,:)]';
%           C= kmeans(train_data',2);
end
