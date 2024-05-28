clear all;
close all;
K=100;%constante de resorte
K2=10;%amortiguamiento
T=0.0031;%intervalo de tiempo
d=5 ;%dimension de la malla
X=[zeros(d,1)';(1:d)]';
Xf=X;
X(d,:)=X(d,:)+[.1,0];
V=zeros(d,2);
for k=1:1000
   for i=3:d
      R1=X(i,:)-X(i-1,:);
      R2=X(i-1,:)-X(i-2,:);
      DX=R1-R2;
      V(i,:)=V(i,:)+(-K*DX-K2*V(i,:))*T;
      Xf(i,:)=X(i,:)+V(i,:)*T;
   end;
   X=Xf;
  	plot(X(:,1),X(:,2),'+:');
   axis([-4,4,0,d+1]);
   pause(0);
end;  