%%Simula:Solido Elastico y Fracturas
%%Obtiene un vector para sonido
%%
clearvars;
close all;
clc

numcalculos=800;%24*3*5;%%24cuad p/seg * 10 seg * 5 calculos por cuadro
sismo=.1*sin(0:6*2*pi/numcalculos:6*2*pi);
K1=1400;%%constante de resorte
K2=.4;%%amortiguamiento
rompimiento=1.6;%%nivel de rompimiento
gravedad=[0;0;-5];%%Fuerza externa
T=0.005;%%intervalo de tiempo
d1=5;%%dimension x de la malla
d2=5;%%dimensión y
d3=5;%%dimensión z
numpuntos=d1*d2*d3;
indPtoMed=round((d1+d1*(d2-1)+d1*d2*(d3-1))/2);
k=0;%%indice para partículas
numgrap=1;%%indice de graficas
sonido=1;%%indice de onda
%%Bloque para considerar mallas de espesor 1
    if d1==1 
        lx=1;lxp=1;incx=1; else lx=d1-1;lxp=d1;incx=d1-1;
    end
    if d2==1
        ly=0;lyp=0;incy=1; else ly=d2-2;lyp=d2-1;incy=d2-1;
    end
    if d3==1
        lz=0;lzp=0;incz=1; else lz=d3-2;lzp=d3-1;incz=d3-1;
    end
%%termina bloque
for z=0:d3-1%%Bloque de Inicialización de viga
   for y=0:d2-1
      for x=1:d1
         k=k+1;
         p(k).r=[x;y;z];%%posición inicial de las partículas
         p(k).v=[0;0;0];%%velocidad inicial
         p(k).F=[0;0;0];%%
         w=1;%%indice para vecinos
         for nz=z-1:z+1
            for ny=y-1:y+1
         		for nx=x-1:x+1%26 vecinos de la particula + ellamisma              
                  if (1<=nx & nx<=d1)&(0<=ny & ny<=d2-1)&(0<=nz & nz<=d3-1)
                     p(k).n(w).ind=nx+d1*ny+d1*d2*nz;%indice del vecino w
                     p(k).n(w).disteq=norm(p(k).r-[nx;ny;nz]);%distancia de equilibrio con el vecino w
                  else p(k).n(w).ind=0;
                  end
                  w=w+1;
               end
            end
         end
         p(k).n(14).ind=0;%particula misma
      end
   end
end%%Termina inicialización de viga
%%BOLITA EXTERNA (nodo N+1)%%%%%%%%%%%%%%%%%%
N=k+1;
    p(N).r=[2,-2,2]';   %posicion 
    p(N).v=[0,-5,0]';  %velocidad 
    p(N).F=[0,0,0]';   %fuerza
    [Xs,Ys,Zs] = sphere;%esfera
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pf=p;%auxiliar
%%
for k=1:numcalculos%%calculos
    
    %if k>10; gravedad=[0;0;0]; end;%%libera sistema de fuerza externa
  	%% CALCULOS
    
	for z=0:(d3-1)%%%%%todos 0:d3-1
     	for y=0:(d2-1)%%%todos 0:d2-1
        	for x=1:d1%%%todos 1:d1
                ind=x+d1*y+d1*d2*z;
     			DX=[0;0;0];
                if(z==0)
                    p(ind).r(1)=p(ind).r(1)+sismo(k);
                end
     			for w=1:27% vecinos de la particula + ellamisma
        			if (p(ind).n(w).ind ~= 0) %existe o no esta roto
        				DR=(p(ind).r-p(p(ind).n(w).ind).r);%vector posición relativa
                        dr=norm(DR);
                        if dr>(rompimiento*p(ind).n(w).disteq)
                            pf(ind).n(w).ind=0;
                        end            
                        r=DR/dr;%unitario en la dirección de desplazamiento              
                        DX=DX+(dr-p(ind).n(w).disteq)*r;%vector desplazamiento
                    end
                end%vecinos
                
                %%interaccion con bola externa
                DR=p(N).r-p(ind).r;%vector a vecino
                modulo=norm(DR);%distancia de nodo a vecino
                F=[0,0,0]';
                if (modulo<1)%si está cerca la bola
                    %U=DR/modulo;%vector unitario
                    F=10*DR/(modulo^3);%fuerza tipo coulomb
                    %p(k).F=p(k).F-F;%suma vectorial de fuerzas
                    p(N).F=p(N).F+F;%fuerza de reacción
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if (0<z)%(1<x & x<d1)% & (0<y & y<d2-1)%fijo x=1 y x=d1
%                     if (x==round(d1/2)); gravedad=[0;0;-20];
%                     else gravedad=[0;0;-2];
%                     end;
  	  				pf(ind).v=p(ind).v+(-K1*DX-K2*p(ind).v+gravedad-F)*T;
                    pf(ind).r=p(ind).r+pf(ind).v*T;              
                end                  
     		end%x
    	end%y 
    end%z    
    %%terminan calculos de nodos de estructura
    %%calculo de bola externa
    pf(N).v=(p(N).F-0*p(N).v+[0,0,0]')*T+p(N).v;
    pf(N).r=p(N).v*T+p(N).r;
    pf(N).F=[0,0,0]';
    p=pf;
    %% terminan calculos 
    if (mod(k,5)==0)%para formar onda 
      S(sonido)=p(indPtoMed).r(2);
      sonido=sonido+1;
    end
    %%empieza graficación
    if (mod(k,5)==0)%solo grafica cada 5 calculos por precisión  
   	numpolig=0;clear X;clear Y;clear Z;
   	if (d1>1 & d2>1)%%calcula poligonos de planos Z
   		for z=0:incz:lzp
            for y=0:ly
         		for x=1:lx
            		ind1=x+d1*y+d1*d2*z;
            		if (p(ind1).n(15).ind ~= 0 & p(ind1).n(17).ind  ~= 0 & p(ind1).n(18).ind  ~= 0)                   
            			numpolig=numpolig+1;
            			ind2=x+1+d1*y+d1*d2*z;
            			ind3=x+1+d1*(y+1)+d1*d2*z;
            			ind4=x+d1*(y+1)+d1*d2*z;
            			XI(:,numpolig)=[ind1;ind2;ind3;ind4];            
            			X(:,numpolig)=[p(ind1).r(1);p(ind2).r(1);p(ind3).r(1);p(ind4).r(1)];
            			Y(:,numpolig)=[p(ind1).r(2);p(ind2).r(2);p(ind3).r(2);p(ind4).r(2)];
            			Z(:,numpolig)=[p(ind1).r(3);p(ind2).r(3);p(ind3).r(3);p(ind4).r(3)];
                    end
                end%x
	  		 end%y
   		end%z
   	end%%plano z
    if (d1>1 & d3>1)%%calcula poligonos de planos Y  
		for y=0:incy:lyp
      		for z=0:lz
         		for x=1:lx
            		ind1=x+d1*y+d1*d2*z;
            		if (p(ind1).n(15).ind ~= 0 & p(ind1).n(23).ind  ~= 0 & p(ind1).n(24).ind  ~= 0)                   
            			numpolig=numpolig+1;
            			ind2=x+1+d1*y+d1*d2*z;
            			ind3=x+1+d1*y+d1*d2*(z+1);
            			ind4=x+d1*y+d1*d2*(z+1);
            			XI(:,numpolig)=[ind1;ind2;ind3;ind4];            
			            X(:,numpolig)=[p(ind1).r(1);p(ind2).r(1);p(ind3).r(1);p(ind4).r(1)];
         			    Y(:,numpolig)=[p(ind1).r(2);p(ind2).r(2);p(ind3).r(2);p(ind4).r(2)];
			            Z(:,numpolig)=[p(ind1).r(3);p(ind2).r(3);p(ind3).r(3);p(ind4).r(3)];
                    end
		   	    end%x
             end%y
		 end%z
     end%%plano y
   	if (d2>1 & d3>1)%%calcula poligonos de planos X
   		for x=1:incx:lxp
      		for z=0:lz
         		for y=0:ly
            		ind1=x+d1*y+d1*d2*z;
            		if (p(ind1).n(23).ind ~= 0 & p(ind1).n(17).ind  ~= 0 & p(ind1).n(26).ind  ~= 0)                   
            			numpolig=numpolig+1;
            			ind2=x+d1*y+d1*d2*(z+1);
            			ind3=x+d1*(y+1)+d1*d2*(z+1);
			            ind4=x+d1*(y+1)+d1*d2*z;
         			    XI(:,numpolig)=[ind1;ind2;ind3;ind4];           
			            X(:,numpolig)=[p(ind1).r(1);p(ind2).r(1);p(ind3).r(1);p(ind4).r(1)];
         			    Y(:,numpolig)=[p(ind1).r(2);p(ind2).r(2);p(ind3).r(2);p(ind4).r(2)];
			            Z(:,numpolig)=[p(ind1).r(3);p(ind2).r(3);p(ind3).r(3);p(ind4).r(3)];
                    end
                end%y              
            end%z
		 end%x
     end%%plano x
      
      %%grafica en matlab
        hold off
        fill3(X,Y,Z,Z);
        hold on;
        surf(.51*Xs+p(N).r(1),.51*Ys+p(N).r(2),.51*Zs+p(N).r(3));
        %set(gcf,'position',[0,0,1000,1000]);
        dMax=max([d1,d2,d3]);
        axis([-dMax,2*dMax,-dMax,2*dMax,-dMax,2*dMax]);
        %axis([-2,d1+2,-2,d2+2,-10,d3+2]);
        xlabel('x');   ylabel('y');   zlabel('z');
        M(numgrap)=getframe;
		numgrap=numgrap+1;
   end%graficacion
   
end;%%terminan k calculos
movie(M);
%sound(S,10000);
%%Genera video en formato avi 
vid=VideoWriter('simSis1');
open(vid);
writeVideo(vid,M);
close(vid);