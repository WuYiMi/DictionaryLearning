function [ D ] = offlineLearn( train_data,train_c1,train_c2,d_size,t1,para,iterations,iterations1)
%OFFLINELEARN ÀëÏß×ÖµäÑ§Ï°

%% get initial dictionary Dinit
fprintf('\nDictionary initialization... ');
D1_int=initialization(train_c1,d_size(1),iterations1,t1);
D2_int=initialization(train_c2,d_size(2),iterations1,t1);
DC_int=initialization(train_data,d_size(3),iterations1,t1);
fprintf('done!');
D_int=[D1_int,D2_int,DC_int];

%% dictionary learning 
fprintf('\nDictionary learning by SDL...');
% [D1,D2,DC] = rtog(train_c1,train_c2,D1_int,D2_int,DC_int,para,iterations,t1);
% [D1,D2,DC] = rnew(train_c1,train_c2,D1_int,D2_int,DC_int,para,iterations,t1);
[D1,D2,DC] = rnew2(train_c1,train_c2,D1_int,D2_int,DC_int,para,iterations,t1);
D=[D1,D2,DC];
fprintf('done!')
end

