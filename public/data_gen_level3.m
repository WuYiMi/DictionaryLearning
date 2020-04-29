function [train_data,test_data]=data_gen_level3(Type,Size1,Size2,Size3)
    %% =========== CSTH Data 2000==========
    %% level=level+0.5 test305
          load('F:\SDL1007\data\CSTH_MODE2\TEMP\trian3.mat')
          load('F:\SDL1007\data\CSTH_MODE2\TEMP\trian4.mat')
          load('F:\SDL1007\data\CSTH_MODE2\LEVEL\add\test305.mat')
          load('F:\SDL1007\data\CSTH_MODE2\LEVEL\add\test405.mat')      
          train_data=[train3(501:1500,:);train4(501:1500,:)]';
          test_data=[test305(351:450,:);test405(701:800,:);test305(801:1400,:)]';
end