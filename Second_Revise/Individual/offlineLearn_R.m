function [ D_int ] = offlineLearn_R( train_data,train_c1,train_c2,d_size,t1,para,iterations,iterations1)
%OFFLINELEARN ÀëÏß×ÖµäÑ§Ï°

%% get initial dictionary Dinit
fprintf('\nDictionary initialization... ');
D1_int=initialization(train_c1,d_size(1),iterations1,t1);
D2_int=initialization(train_c2,d_size(2),iterations1,t1);
fprintf('done!');
D_int=[D1_int,D2_int];
end

