Results = [];
Lable_Rate = [];

fid1 = fopen('Results.txt','wt');
fid2 = fopen('Rate.txt','wt');

for i=1:5
Results_FaultRates = randperm(8)
sdl_label_rate = randn(1,2)
Results = [Results;Results_FaultRates];%% 记录28个结果
Lable_Rate = [Lable_Rate;sdl_label_rate];
save('Res.mat','Results','Lable_Rate');

fprintf(fid1,'%g\t',Results_FaultRates);
fprintf(fid1,'\n');
  % 写入模态识别率
fprintf(fid2,'%g\t',sdl_label_rate);
fprintf(fid2,'\n');

end
fclose(fid1);
fclose(fid2);