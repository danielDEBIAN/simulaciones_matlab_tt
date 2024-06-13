clear all;
close all;
vec=1;%vecinos considerados en el calculo
K=10;%elasticidad
K2=0.1;%amortiguamiento
T=0.002;%incremento
d=50;%elementos
%posisción inicial
H=zeros(d,1);
H(d/2-1:d/2)=.55;
Hf=zeros(d,1);%auxiliar
V=zeros(d,1);%velocidad
%Y=[0:24]/25;
%Y(25:50)=-[25:50]/25+2;
%H=Y;
for k=1:10000%calculos
   plot(H);
   axis ([0,d,-1.2,1.2]);
   	for i=vec+1:d-vec
     	Hm=sum(H(i-vec:i+vec))-H(i);
      X=2*vec*H(i)-Hm;
      V(i)=V(i)+(-K*X-K2*V(i))*T;
      Hf(i)=H(i)+V(i)*T;
   end;
   H(d/2-1:d/2)=.1;

   H=Hf;
   pause(0.000001);
end;  