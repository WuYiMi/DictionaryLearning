function dre = calculateDrenew_R(D,d_sizes,data,sparsity)
s1=d_sizes(1);s2=d_sizes(2);

dre=zeros(1,2,size(data,2));
for i=1:size(data,2)
       G=D'*D;
       a = omp(D,data(:,i),G,sparsity);    %%%%%���xi��D��ϡ��
       % ������ɫ�ֵ�1+�����ֵ��ʾ���ݵ���� 
       dre(:,1,i)=(norm(data(:,i)-D(:,1:s1)*a(1:s1,:)))^2;
       % ������ɫ�ֵ�2+�����ֵ��ʾ���ݵ���� 
       dre(:,2,i)=(norm(data(:,i)-D(:,s1+1:s1+s2)*a(s1+1:s1+s2,:)))^2; 
       
end









