function [D1,D2,DC]=rtog(data1,data2,D1_int,D2_int,DC_int,para,iterations,t1)

size1=size(D1_int,2); 
size2= size(D2_int,2); 
size3 = size(DC_int,2); 
D1=D1_int;
D2=D2_int;
DC=DC_int;
D=[D1_int,D2_int,DC_int];
data=[data1,data2];
for i=1:iterations
  %% 利用 sparse coding 求解A1,A2   
  M1=getD(0,size1,size1+size2+size3,size3);
  O1=zeros(size(M1',1),size(data1,2));
  X1=[data1;data1;O1];
  Q1=getB(0,size1,size1+size2+size3,size3);
  DA1=D*(Q1*Q1');
  DB1=normcols([D;DA1;M1']);
  A1=omp(DB1,X1,DB1'*DB1,t1);
  A1=A1/sqrt(2);
  
  
  M2=getD(size1,size2,size1+size2+size3,size3);
  O2=zeros(size(M2',1),size(data2,2));
  X2=[data2;data2;O2];
  Q2=getB(size1,size2,size1+size2+size3,size3);
  DA2=D*(Q2*Q2');
  DB2=normcols([D;DA2;M2']);
  A2=omp(DB2,X2,DB2'*DB2,t1); 
  A2=A2/sqrt(2);


 %% 更新D1   
   for j = 1:size1
        Q=getA(0,size1,size1+size2+size3);
        Wc1=Q'*A1;
        % D1=D*Q;
        ak=Wc1(j,:);
        if(norm(ak,2)~=0)
            
        B=D*getC(0,size1,size1+size2+size3);
        F=zeros(size(D1,1),size(ak,2));
   for n=1:size1
       if(n~=j)           
             F=F+D1(:,n)*Wc1(n,:);   
       end
       
   end
%   GT0=D1*getA(0,size1,size1+size2+size3)'*A1;
   GT1=D*getA(size1,size2,size1+size2+size3)*getA(size1,size2,size1+size2+size3)'*A1;
   GT2=D*getA(size1+size2,size3,size1+size2+size3)*getA(size1+size2,size3,size1+size2+size3)'*A1;
   G=GT1+2*GT2; 
   
   H=2*F+G;
   
   J=2*data1-H;
   E=norm(ak,2)^2*eye(size(B,1));
    d=0.5*inv(E)*J*ak';
   D1(:,j)=d/norm(d);
   A1(j,:)=norm(d)*ak;
       
        end
        
   end
  
   D=full([D1,D2,DC]);
   
  %% 更新D2  
   for j=1:size2
   Q=getA(size1,size2,size1+size2+size3);
   Wc2=Q'*A2;
   ak=Wc2(j,:);
   if(norm(ak,2)~=0)
       
    B=D*getC(size1,size2,size1+size2+size3);
   %D2=D*Q;
    F=zeros(size(D2,1),size(ak,2));
    for n=1:size2
       if(n~=j)
            F=F+D2(:,n)*Wc2(n,:);
       end     
    end
  
    GT3=D*getA(0,size1,size1+size2+size3)*getA(0,size1,size1+size2+size3)'*A2;
    GT4=D*getA(size1+size2,size3,size1+size2+size3)*getA(size1+size2,size3,size1+size2+size3)'*A2;
    G=GT3+2*GT4;
   
    H=2*F+G;
    J=2*data2-H;
     E=norm(ak,2)^2*eye(size(B,1));
    d=0.5*inv(E)*J*ak';
%     d=inv(n2*B*B'+norm(ak,2)^2*eye(size(B,1)))*J*ak'*0.5;
    D2(:,j)=d/norm(d);
    A2(size1+j,:)=norm(d)*ak;
   end
    
   end
  D=full([D1,D2,DC]);
  %% 更新D3  
   for j=1:size3
   Q=getA(size1+size2,size3,size1+size2+size3);
   %Wc3=Q'*A3;
   % Gamma=Q'*A3;
   Wc1=Q'*A1;
   Wc2=Q'*A2;
   Wc3=[Wc1,Wc2];
   ak=Wc3(j,:);
   if(norm(ak,2)~=0)
    B=D*getC(size1+size2,size3,size1+size2+size3);
    %DC=D*Q;
    F=zeros(size(DC,1),size(ak,2));
    for n=1:size3
       if(n~=j)
       F=F+DC(:,n)*Wc3(n,:);
       end    
   end
  %A1=A3(:,1:size(data1,2));
  %A2=A3(:,size(data1,2)+1:end);
    G1=D*getA(0,size1,size1+size2+size3)*getA(0,size1,size1+size2+size3)'*A2;
    G2=D*getA(size1,size2,size1+size2+size3)*getA(size1,size2,size1+size2+size3)'*A1;
    G3=D*getA(0,size1,size1+size2+size3)*getA(0,size1,size1+size2+size3)'*A1;
    G4=D*getA(size1,size2,size1+size2+size3)*getA(size1,size2,size1+size2+size3)'*A2;
    H1=[data1-G3-G2,data2-G1-G4];
    H2=[data1-G3,data2-G4];
   
    H=H1+H2-2*F;
%     d=inv(n3*B*B'+norm(ak,2)^2*eye(size(B,1)))*H*ak'*0.5;
    E=norm(ak,2)^2*eye(size(B,1));
    d=0.5*inv(E)*H*ak';
    DC(:,j)=d/norm(d,2);
%   A3(size1+size2+j,:)=norm(d,2)*ak;
    R=norm(d,2)*ak;
    A1(size1+size2+j,:)=R(1:size(A1,2));
    A2(size1+size2+j,:)=R(size(A1,2)+1:end);
   end
   end
    D=full([D1,D2,DC]);

end