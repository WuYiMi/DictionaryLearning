function [train_data,test_data]=data_gen_level2(Type,Size1,Size2,Size3)
    %% =========== CSTH Data 2000==========
      load('E:\Code\SDL0930\data\CSTH_SENSOR_FAULT\Level_fault\Level_fault_traindata_mode5.5.mat');
      load('E:\Code\SDL0930\data\CSTH_SENSOR_FAULT\Level_fault\Level_fault_traindata_mode0.mat');
load('E:\Code\SDL0930\data\CSTH_SENSOR_FAULT\Level_fault\Level_fault_testdata_mode5.5.mat');
load('E:\Code\SDL0930\data\CSTH_SENSOR_FAULT\Level_fault\Level_fault_testdata_mode0.mat');
      train_data=[TrainData1(501:1500,:);TrainData2(501:1500,:)]';
      test_data=[TestData1(351:450,:);TestData2(351:450,:);TestData1(801:1400,:)]';
end
