function [rdl_fault,rdl_thres,rdl_dre,label_rate,dre1,label] = onlineMonitor(D,d_sizes,test_data,t2,confidence,numbers)

%%  calculate DRE 
dre1 = calculateDrenew(D,d_sizes,test_data,t2);

%% calculate the fault_thres
label = ones(size(test_data,2),1);            %%%%%ones����M*1ȫ1��
dre2 = zeros(size(test_data,2),1);
for i=1:size(test_data,2)
    if dre1(:,1,i)<dre1(:,2,i)
        dre2(i)=dre1(:,1,i);                        %%%MΪÿ����Сֵ��ɵ���������LΪ�����ֵ�к�
        label(i)=1;
    elseif dre1(:,1,i)>dre1(:,2,i)
        dre2(i)=dre1(:,2,i);                        %%%MΪÿ����Сֵ��ɵ���������LΪ�����ֵ�к�
        label(i)=2;
    else
         dre2(i)=dre1(:,2,i);
         a = randperm(2);
         label(i)=a(1);
    end
end
%----------����������--------------
hide = numbers(1);                    %%%% hide��ʾѵ�����ݵ���Ŀ
normal1 = numbers(2);
normal2 = numbers(3);
abnormal = numbers(4);
show_dre = dre2(hide+1:end,:);           %%%%%%ȡ���������ݵ����

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

FAR=length(find(label(hide+1:hide+normal)==0))/normal;  %��������鱨��
FDR=length(find(label(hide+normal+1:end)==0))/abnormal;  %����Ԥ����

AA=(length(find(label(hide+1:hide+normal1)==1))/normal1);  %mode1ʶ����
AB=(length(find(label(hide+normal1+1:hide+normal1+normal2)==2))/normal2);  %mode2ʶ����

rdl_fault=[FAR,FDR];
label_rate=[AA,AB];
rdl_thres=[fault_thres];
rdl_dre=show_dre;

