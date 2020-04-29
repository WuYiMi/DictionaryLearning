function [train_data,test_data]=data_gen_temp()

    %% =========== CSTH Data 4000==========
%     load('data2\temp4000\model 0\CSTH_model_0_temp');  
%     load('data2\temp4000\model 5.5\CSTH_model_5_temp');
%     train_data=[model_1(1501:2500,:);model_2(1501:2500,:)]';
%     test_data=[model_1(2501:2600,:);model_2(2501:2600,:);model_2(3011:3610,:)]';
    %% =========== CSTH Data 2000==========
      load('data\CSTH\public2000\model 0\CSTH_model_0');
      load('data\CSTH\temp2000\model 0\CSTH_model_0_test');
      load('data\CSTH\public2000\model 5\CSTH_model_5');
      load('data\CSTH\temp2000\model 5.5\CSTH_model_2_test_2');
      train_data=[model_0(501:1500,:);model_5(501:1500,:)]';
      test_data=[model_1_test(351:450,:);model_2_test(351:450,:);model_2_test(901:1500,:)]';
end


