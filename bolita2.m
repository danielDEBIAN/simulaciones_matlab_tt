clear all;
close all;
K=200;
K2=.71;
T=0.01;
d=30 ;
%Y=[0:24]/25;
%Y(25:50)=-[25:50]/25+2;
%Y(51:100)=zeros(50,1);
%H=Y;      
H=zeros(d,1);
%H(d/2-3:d/2+2)=[1,1,1,1,1,1];
%H(d/2)=[1];
Hf=zeros(d,1);
V=zeros(d,1);
Yp=2;
Vp=0;
unido=0;

%V(d/2,1)=-10;
%plot(H);
for k=1:1000
	for i=4:d-3
     	Hm=mean([H(i-3),H(i-2),H(i-1),H(i+1),H(i+2),H(i+3)]);
      X=H(i)-Hm;
      V(i)=V(i)+(-K*X-K2*V(i))*T;
      Hf(i)=H(i)+V(i)*T;
   end;
   H=Hf;
   Vp=Vp-1*T;
   Yp=Yp+Vp*T;
   if unido==1 & Yp>H(d/2)
      unido=0;
   elseif unido==1
      Yp=H(d/2);
      Vp=V(d/2);
   elseif unido==0 & Yp<H(d/2) 
      Yp=H(d/2);
      V(d/2)=V(d/2)+Vp;
      
      unido=1;
   elseif unido==0
      
   end;
   plot(H);
   axis ([0,d,-2,2]);
   hold on;
   plot(d/2,Yp,'*');
   pause(0.000001);
   hold off;
end;  