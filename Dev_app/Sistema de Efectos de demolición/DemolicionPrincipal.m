%%Simula: de Efectos de demolicion sobre estructuras para simular fracturas
%%y colisiones.
%%Sobre las particulas base de la estructura
%%se aplica el movimiento del piso en caso de ser necesrio
%%
clc;
clearvars;close all;
% Creación de estructura
Amplitud=0.5;%del bloque
p(1).r=[0;0;0];
%techo
p=bloque([-2.25;0;2.75],[2.25;0;2.75],Amplitud,4.5,p,1);%Techo
%Vigas de soporte,.
p=bloque([2;-2;2],[2;-2;0],Amplitud,Amplitud,p,1);%Columna
p=bloque([2;2;2],[2;2;0],Amplitud,Amplitud,p,1);%Columna
p=bloque([-2;-2;2],[-2;-2;0],Amplitud,Amplitud,p,1);%Columna
p=bloque([-2;2;2],[-2;2;0],Amplitud,Amplitud,p,1);%Columna

%Acero=1
%Concreto=2
p=unePuntos(p,Amplitud);
GraficaAlambres(p);
%%

%%% Inicialización de constantes
%pause(001);
Masa=3;%3000;%densidad del concreto 2.2 T/m^3, M= densidad*Vol
rompimiento=10;%0.02;%0.02;%nivel de rompimiento
debilitamiento=-10;%-0.02;%-0.02;%nivel para debilitar el material
T=0.001;%%intervalo de tiempo (delta T) segundos
GraficarCada=0.01;%Segundos
IntervaloGraf=10;%ceil(GraficarCada/T);
PO=.01;%Periodo de oscilación segundos;
numgrap=1;%%indice de graficas
%load estructuraP1.mat;
numPart=length(p);
%SalvaDatos(numgrap,p);
% Calculo de Iteración
for k=1:90/T%numero de calculos para todo el solido
    
   for ind1=1:numPart%para cada particula 
      p=InteraccionConVecinos(ind1,p,rompimiento,debilitamiento);%calcula fuerza
      if p(ind1).r(3)<0.1 %& k<5/T%las que estan en el suelo se aplica mov. oscilatorio
        p(ind1).r(1)=p(ind1).r(1)+0.5*sin(2*pi*k*T/PO);%oscilación de la base 0 a 10 segundos;%mov eje x
        %%Si no hay friccion con el suelo
%         p(ind1).Acel(3)=-p(ind1).Acel(3);
%         p(ind1).v(3)=-p(ind1).v(3);
%         p(ind1).v=p(ind1).v+p(ind1).Acel*T;
%         p(ind1).r=p(ind1).r+p(ind1).v*T+p(ind1).Acel*T^2/2;
      else
         p(ind1).v=p(ind1).v+p(ind1).Acel*T;
         p(ind1).r=p(ind1).r+p(ind1).v*T+p(ind1).Acel*T^2/2;
      end
      p(ind1).Acel=[0;0;0];%inicializa para siguiente ciclo
   end%para cada partícula
   if (mod(k,IntervaloGraf)==0)%grafica cada N calculos por precisión
      %if (mod(k,IntervaloGraf*10)==0)%salva cada N calculos en archivo
      %   save EstActl
      %end
      iteracion=k
      figure(1);GraficaAlambres(p);
      M(numgrap)=getframe;
	  numgrap=numgrap+1;
      pause(0.001);
	end%graficacion
end %calculos
movie(M);
vid=VideoWriter('simSis2');
open(vid);
writeVideo(vid,M);
close(vid);