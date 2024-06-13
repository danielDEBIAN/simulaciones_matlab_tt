function p=bloque(p1,p2,Alto,Ancho,p, Material);
%Alto=eje z;Ancho=eje y;largo=eje x (dist entre p1 y p2)
%Acero=1
%Concreto=2
puntoRes=p2-p1;
normaXYZ=norm(puntoRes);
normaXY=norm([puntoRes(1);puntoRes(2)]);
senFi=puntoRes(3)/normaXYZ;
cosFi=normaXY/normaXYZ;
if normaXY==0
   senTeta=0;
   cosTeta=1;
else
   senTeta=puntoRes(2)/normaXY;
   cosTeta=puntoRes(1)/normaXY;
end
%matrices Rotacion
rotacionY=[cosFi  0 -senFi ;...
             0    1   0    ;...
           senFi  0  cosFi];
rotacionZ=[cosTeta -senTeta 0;...
           senTeta  cosTeta 0;...
              0       0     1];
R1=rotacionZ*rotacionY;
%%%%%%%%%%Construye un paralelepipedo%%%%%%%%%%%%
k=length(p);%%indice para partículas
if k==1
   k=0;
end
incAlto=0.5;%
incAncho=0.5;%Ancho/2;%eje z
incLargo=0.5;%%normaXYZ/5;%eje x
if Material==1
    masaMaterial=2;%20000;
elseif Material==2
    masaMaterial=8500;
end
for z=-Alto/2:incAlto:Alto/2%%Bloque de Inicialización de posiciones
   for y=-Ancho/2:incAncho:Ancho/2
      for x=0:incLargo:normaXYZ
         k=k+1;
         %p(k).movil=1;%movil
         p(k).r=R1*[x;y;z]+p1;%;%%posición inicial de las partículas
         p(k).v=[0;0;0];%%velocidad inicial
         p(k).Acel=[0;0;0];%fuerza
         p(k).Masa=masaMaterial;%Masa
         p(k).Material=Material;
      end
   end
end
indFinal=k;
return;