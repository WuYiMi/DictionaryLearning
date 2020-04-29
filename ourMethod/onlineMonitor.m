function [rdl_fault,rdl_thres,rdl_dre,label_rate,dre1,label] = onlineMonitor(D,d_sizes,test_data,t2,confidence,numbers)

%%  calculate DRE 
dre1 = calculateDrenew(D,d_sizes,test_data,t2);

%% calculate the fault_thres
label = ones(size(test_data,2),1);            %%%%%ones生成M*1全1阵
dre2 = zeros(size(test_data,2),1);
for i=1:size(test_data,2)
    if dre1(:,1,i)<dre1(:,2,i)
        dre2(i)=dre1(:,1,i);                        %%%M为每列最小值组成的行向量，L为各最大值行号
        label(i)=1;
    elseif dre1(:,1,i)>dre1(:,2,i)
        dre2(i)=dre1(:,2,i);                        %%%M为每列最小值组成的行向量，L为各最大值行号
        label(i)=2;
    else
         dre2(i)=dre1(:,2,i);
         a = randperm(2);
         label(i)=a(1);
    end
end
%----------控制线设置--------------
hide = numbers(1);                    %%%% hide表示训练数据的数目
normal1 = numbers(2);
normal2 = numbers(3);
abnormal = numbers(4);
show_dre = dre2(hide+1:end,:);           %%%%%%取出测试数据的误差

dre2_train = dre2(1:hide);         %%%%
range=KDE_fcn(dre2_train,confidence);
fault_thres=range(2);
%% classification
for i=1:size(test_data,2)
   if(dre2(i)>fault_thres)
       label(i)=0;    
   end
 end

% count label
normal=normal1+normal2;

FAR=length(find(label(hide+1:hide+normal)==0))/normal;  %计算故障虚报率
FDR=length(find(label(hide+normal+1:end)==0))/abnormal;  %故障预报率

AA=(length(find(label(hide+1:hide+normal1)==1))/normal1);  %mode1识别率
AB=(length(find(label(hide+normal1+1:hide+normal1+normal2)==2))/normal2);  %mode2识别率

rdl_fault=[FAR,FDR];
label_rate=[AA,AB];
rdl_thres=[fault_thres];
rdl_dre=show_dre;

