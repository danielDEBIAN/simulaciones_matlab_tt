%Analiza y elimina puntos cercanos y define vecinos cercanos para
%estructura
function p=unePuntos(p,Amplitud)
%bloque que elimina las partículas muy cercanas
i=1;
numPart=length(p);
while(i<numPart)
   j=i+1;
   while(j<=numPart)      
      distEq=norm(p(i).r-p(j).r);
      if distEq<Amplitud*0.8 %menores al mínimo
         p(j)=[];%se elimina
         numPart=numPart-1;%disminuye
      else
         j=j+1;
      end
   end
   i=i+1;
end%
%define vecinos cercanos
for i=1:numPart
   w=0;%%indice para vecinos de la k-esima particula
   for j=i+1:numPart
      distEq=norm(p(i).r-p(j).r);
      if distEq<=Amplitud*1.5;%
         w=w+1;
         p(i).n(w).ind=j;%indice del vecino w
         p(i).n(w).disteq=distEq;%distancia de equilibrio con el vecino w
      end
   end
   p(i).numVec=w;%Numero de vecinos de la particula k
end%%Termina inicialización
return;