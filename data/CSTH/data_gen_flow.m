function [train_data,test_data]=data_gen_flow(Type,Size1,Size2,Size3)
%     %% CSTH Data 4000
%     load('data2\flow4000\model 0\CSTH_model_0_flow');  % 01 表示没有故障的model_1
%     load('data2\flow4000\model 5.5\CSTH_model_5_flow');
%     train_data=[model_1(1501:2500,:);model_2(1501:2500,:)]';
%     test_data=[model_1(2501:2600,:);model_2(2501:2600,:);model_2(3011:3610,:)]';
    
    
        %% =========== CSTH Data 2000==========
      load('data\CSTH\flow2000\model 0\CSTH_model_0_train');
      load('data\CSTH\flow2000\model 0\CSTH_model_0_test');
      load('data\CSTH\flow2000\model 5.5\CSTH_model_5_train');
      load('data\CSTH\flow2000\model 5.5\CSTH_model_5_test');
      train_data=[model_1_train(501:1500,:);model_2_train(501:1500,:)]';
      test_data=[model_1_test(351:450,:);model_2_test(351:450,:);model_2_test(501:1100,:)]';
end


