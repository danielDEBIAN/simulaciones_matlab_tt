clear all;
close all;
Um=4;%umbral de rompimiento
K=350;%constante de resorte
K2=0.5;%amortiguamiento
T=0.001;%intervalo de tiempo
d=5;%dimension de la malla
X=(0:d)';
U=ones(d,1);
Xf=X;
%X(d/2)=X(d/2)+.3;%impulso inicial
V=zeros(d+1,1);
for k=1:10000
   for i=2:d
      if U(i-1)
         dx1=X(i)-X(i-1);
         if abs(dx1)>Um
            U(i-1)=0;dx1=0;
         end
      else dx1=0;
      end
      if U(i)
         dx2=X(i)-X(i+1);
         if abs(dx2)>Um
            U(i)=0;dx2=0;
         end
      else dx2=0;
      end
      DX=dx1+dx2;%2*X(i)-(X(i-1)+X(i+1));
      V(i)=V(i)-(K*DX+K2*V(i))*T;
      Xf(i)=X(i)+V(i)*T;
   end;
  	%DX=-1+X(d+1)-X(d);
   %V(d+1)=V(d+1)+(-K*DX-K2*V(d+1))*T;
   Xf(d+1)=X(d+1)+.03;%V(d+1)*T;
   X=Xf;
   %plot(X,'o');
   plot(X,zeros(d+1,1),'o');
   axis([0,20,-3*d,3*d]);
   pause(0);
end;




