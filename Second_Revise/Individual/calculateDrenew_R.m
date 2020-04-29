function dre = calculateDrenew_R(D,d_sizes,data,sparsity)
s1=d_sizes(1);s2=d_sizes(2);

dre=zeros(1,2,size(data,2));
for i=1:size(data,2)
       G=D'*D;
       a = omp(D,data(:,i),G,sparsity);    %%%%%求出xi在D的稀疏
       % 利用特色字典1+公共字典表示数据的误差 
       dre(:,1,i)=(norm(data(:,i)-D(:,1:s1)*a(1:s1,:)))^2;
       % 利用特色字典2+公共字典表示数据的误差 
       dre(:,2,i)=(norm(data(:,i)-D(:,s1+1:s1+s2)*a(s1+1:s1+s2,:)))^2; 
       
end









