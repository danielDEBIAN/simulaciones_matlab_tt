%SIMULA CUERDA
clc
clearvars;
close all;
K1=500;%%constante de resorte
K2=.2;%%amortiguamiento
rompimiento=100;%%nivel de rompimiento
Fext=[0;-9.8;0];%%Fuerza externa
T=0.01;%%intervalo de tiempo
numgrap=0;%%indice de graficas
sonido=1;%%indice de onda
%%%INICIALIZACI?N
numPart=10;
k=0;%%indice para part?culas
for x=1:numPart
    k=k+1;
    p(k).r=[x;0;0]; p(k).v=[0;0;0];
    p(k).fija=0;
    w=0;%%indice para vecinos
	for nx=x-1:2:x+1% vecinos de la particula + ellamisma              
       if (1<=nx & nx<=numPart)
       	 w=w+1;
       	 p(k).n(w).ind=nx;%indice del vecino w
          p(k).n(w).disteq=0.1;
       end
    end
    p(k).numVec=w;
end%%Termina inicializaci?n
p(1).fija=1;
p(numPart).fija=1;
pf=p;%auxiliar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numcalculos=2000;%%24cuad p/seg * 10 seg * 5 calculos por cuadro
Amp=0;
for k=1:numcalculos%%CALCULOS
  	%% CALCULOS
   for in=1+1:numPart-1
      if (in==floor(numPart/3) && k<70)
         %Amp=Amp+.5;
         Fext=[0;-30;0];
      else
		   Fext=[0;0;0];      
	   end;%%libera sistema de fuerza externa
      if (p(in).fija==0)%exeptua el calculo particulas fijas
      	DX=[0;0;0]; %calcula el desplazamiento
     		for w=1:p(in).numVec% vecinos de la particula + ellamisma
      		if (p(in).n(w).ind ~= 0) %existe o no esta roto
      			DR=p(in).r-p(p(in).n(w).ind).r;%vector posici?n relativa
               dr=norm(DR);
            end 
				% if dr==0  in;dr=0.001;      end
        		if 0%dr>(rompimiento*p(in).n(w).disteq)%rompimiento es la fracci?n a superar
           		pf(in).n(w).ind=0;
        		end            
     			r=DR/dr;%unitario en la direccion de desplazamiento              
        		DX=DX+(dr-p(in).n(w).disteq)*r;%vector desplazamiento
	    	end        
       	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       	pf(in).v=p(in).v+(-K1*DX-K2*p(in).v+Fext)*T;
       	pf(in).r=p(in).r+pf(in).v*T;              
     end%%exeptua particulas fijas                  
  end
  p=pf;
   %%%%%%%%%%%%%%%%%%%%% terminan calculos %%%%%%%%%%%%%%%   
    if (mod(k,2)==0)%para formar onda 
      S(sonido)=p(numPart/2).r(2);%4indPtoMed).r(2);
      sonido=sonido+1;
    end
    if 1 %GRAFICACION
       for x=1:numPart
          XX(x)=p(x).r(1);
          YY(x)=p(x).r(2);
       end
       plot(XX,YY,'.-');
       axis([-1,numPart+.5,-1,1]);
      pause(0.001);
  end%graficacion
end;%%terminan k calculos
figure(2);plot(S);
pause(0);
sound(0.7*S/max(S),10000);
pause(1);
F = fft(S);
figure(3);plot(abs(F))