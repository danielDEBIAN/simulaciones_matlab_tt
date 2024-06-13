%calcula la fuerza de interacción de una partícula con sus vecinos
function p=InteraccionConVecinos(ind1,p,rompimiento,debilitamiento);
for ind2=1:p(ind1).numVec % para todos los vecinos de la particula ind1-esima
   indVec=p(ind1).n(ind2).ind;
   if (indVec>ind1) %si no esta roto y no se ha calculado
	  DR=(p(ind1).r-p(indVec).r); %vector posición relativa
      dr=norm(DR);
      delta=(dr-p(ind1).n(ind2).disteq)/p(ind1).n(ind2).disteq;
      %%%%%%%codigo para simular fracturas%%%%%%%%%%%%%
%       if delta>rompimiento %
%          p(ind1).n(ind2).ind=0;%rompimiento
%       end
%       %%%%%%%codigo para simular debilitamiento
%       if delta<debilitamiento %si se comprime mucho se debilita el material
%          p(ind1).n(ind2).ind=0;%rompimiento
%       end
      if dr>0         
         ru=DR/dr;%unitario en la dirección de desplazamiento
         Acelij=FuerzaEnlace(delta,ru,p(ind1).Material)/p(ind1).Masa;%
         p(ind1).Acel=p(ind1).Acel-Acelij;%fuerza en la particula
         p(indVec).Acel=p(indVec).Acel+Acelij;%fuerza en su vecina(reaccion)
      end      
   end%(indVec >ind1)%si no esta roto
end%termina para todos los vecinos
L=length(p);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CHOQUES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for indVec=ind1+1:L % para todas las particulas
   DR=(p(ind1).r-p(indVec).r); %vector posición relativa
   dr=norm(DR);
   if dr<.47 %en metros(rango de choque)      
      if dr>0         
         ru=DR/dr;%unitario en la dirección de desplazamiento
         Acelij=1000*ru/(dr);%
         %p(ind1).v=.3*p(ind1).v;
         p(ind1).Acel=p(ind1).Acel+Acelij;%fuerza en la particula
         %p(indVec).v=.3*p(indVec).v;
         p(indVec).Acel=p(indVec).Acel-Acelij;%fuerza en su vecina(reaccion)
      end
   end%(indVec >ind1)%si no esta roto
end%termina para todos los vecinos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AcelExt=[0;0;-9.8];%%Fuerza externa (gravedad)
K2=0.2;%%amortiguamiento
Ffric=-K2*p(ind1).v;
p(ind1).Acel=p(ind1).Acel+AcelExt+Ffric;         