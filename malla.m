clear all;
close all;
vec=2;%vecinos considerados en calculo
K=5;%Constante del resorte entre la masa
K2=.5;%Amortiguamiento
T=.01;%Tiempo
D=60;%Dimension
H=zeros(D);%posición 
Hf=zeros(D);%Auxiliar
V=zeros(D);%velocidad
H(D/4-1:D/4+1,D/4-1:D/4+1)=1;%impulso
H(3*D/4-1:3*D/4+1,3*D/4-1:3*D/4+1)=1;%impulso

for m=1:1000%calculos
   surf(H,'FaceColor','interp','FaceLighting','phong');
   camlight right;
   axis([0,D,0,D,-1,1]);
	for j=vec+1:D-vec
   		for i=vec+1:D-vec
            Hm=sum(sum(H(i-vec:i+vec,j-vec:j+vec)))-H(i,j);
      		X=((2*vec)+1)^2*H(i,j)-Hm;
      		V(i,j)=V(i,j)-(K*X+K2*V(i,j))*T;
            Hf(i,j)=H(i,j)+V(i,j)*T;
      end;
   end; 
   H=Hf;
   pause(0.001);
end;