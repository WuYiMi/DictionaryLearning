function [D1,D2,DC]=rnew2(data1,data2,D1_int,D2_int,DC_int,para,iterations,t1)

size1=size(D1_int,2); 
size2= size(D2_int,2); 
size3 = size(DC_int,2); 
sizec=size1+size2+size3;%字典长度
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
        Q1=getA(0,size1,sizec);
        Q2=getA(size1,size2,sizec);
        Q3=getA(size1+size2,size3,sizec);
        
  for j = 1:size1
        W11=Q1'*A1;
        W12=Q2'*A1;
        W13=Q3'*A1;
        W21=Q1'*A2;
        W22=Q2'*A2;
        W23=Q3'*A2;   
        M11=data1-D2*W12-DC*W13;
        M21=data2-D2*W22-DC*W23;
        M31=data1-DC*W13;
        ak=W11(j,:);
        bk=W21(j,:);
        if(2*(norm(ak,2)^2)+(norm(bk,2)^2)~=0)
            
%         B=D*getC(0,size1,size1+size2+size3);
        F1=zeros(size(D1,1),size(ak,2));
        F2=zeros(size(D1,1),size(bk,2));
        for n=1:size1
            if(n~=j)           
            F1=F1+D1(:,n)*W11(n,:);   
            F2=F2+D1(:,n)*W21(n,:);
            end
       
        end
%   GT0=D1*getA(0,size1,size1+size2+size3)'*A1;
%    GT1=D*getA(size1,size2,size1+size2+size3)*getA(size1,size2,size1+size2+size3)'*A1;
%    GT2=D*getA(size1+size2,size3,size1+size2+size3)*getA(size1+size2,size3,size1+size2+size3)'*A1;
%    G=GT1+2*GT2; 
        N11=M11-F1;
        N21=M21-F2;
        N31=M31-F1;   
        term1=1/(2*(norm(ak,2)^2)+(norm(bk,2)^2));
        term2=(N11*ak'+N21*bk'+N31*ak');
        d=term1*term2;
        D1(:,j)=d/norm(d);
        A1(j,:)=norm(d)*ak;  
        A2(j,:)=norm(d)*bk; 
        end
        
   end
  
   D=full([D1,D2,DC]);
   
  %% 更新D2  
   for j=1:size2
    W11=Q1'*A1;
        W12=Q2'*A1;
        W13=Q3'*A1;
        W21=Q1'*A2;
        W22=Q2'*A2;
        W23=Q3'*A2;
        M12=data1-D1*W11-DC*W13;
        M22=data2-D1*W21-DC*W23;
        M32=data2-DC*W23;
        ck=W12(j,:);
        dk=W22(j,:);
        if((norm(ck,2)^2)+2*(norm(dk,2)^2)~=0)
    F3=zeros(size(D2,1),size(ck,2));
    F4=zeros(size(D2,1),size(dk,2));
    for n=1:size2
       if(n~=j)
            F3=F3+D2(:,n)*W12(n,:);
            F4=F4+D2(:,n)*W22(n,:);
       end     
    end
N12=M12-F3;
N22=M22-F4;
N32=M32-F4;   
   term1=1/((norm(ck,2)^2)+2*(norm(dk,2)^2));
   term2=(N12*ck'+N22*dk'+N32*dk');
   d=term1*term2;
    D2(:,j)=d/norm(d);
    A1(size1+j,:)=norm(d)*ck;
        A2(size1+j,:)=norm(d)*dk;
   end
    
   end
  D=full([D1,D2,DC]);
  %% 更新D3  
   for j=1:size3
        W11=Q1'*A1;
        W12=Q2'*A1;
        W13=Q3'*A1;
        W21=Q1'*A2;
        W22=Q2'*A2;
        W23=Q3'*A2;   
        M13=data1-D1*W11-D2*W12;
        M23=data2-D1*W21-D2*W22;
        M33=data1-D1*W11;
        M43=data2-D2*W22;
        ek=W13(j,:);
        fk=W23(j,:);
        if((norm(ek,2)^2)+(norm(fk,2)^2)~=0)
            F5=zeros(size(DC,1),size(ek,2));
            F6=zeros(size(DC,1),size(fk,2));
            for n=1:size3
                if(n~=j)
                    F5=F5+DC(:,n)*W13(n,:);
                    F6=F6+DC(:,n)*W23(n,:);
                end    
            end
            N13=M13-F5;
            N23=M23-F6;
            N33=M33-F5;
            N43=M43-F6;
            term1=1/(2*(norm(ek,2)^2)+2*(norm(fk,2)^2));
            term2=(N13*ek'+N23*fk'+N33*ek'+N43*fk');
            d=term1*term2;
            DC(:,j)=d/norm(d,2);
            A1(size1+size2+j,:)=norm(d,2)*ek;
            A2(size1+size2+j,:)=norm(d,2)*fk;
        end
   end
   D=full([D1,D2,DC]);

end