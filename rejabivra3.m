clear all;close all;
K1=50;%constante de resorte
K2=0.5;%amortiguamiento
gravedad=[0,0,-2];
T=0.04;%intervalo de tiempo
d1=10;%dimension x de la malla
d2=3;%dimensión y
d3=3;%dimensión z
k=1;
for z=1:d3
   for y=1:d2
      for x=1:d1
         R(k,:)=[x,y,z];%posición inicial de las partículas
         k=k+1;
      end%x
   end%y
end%z
Rf=R;%auxiliar
V=zeros(d1*d2*d3,3);%velocidad inicial
%hold on
for k=1:100%calculos
   numpolig=0;
   
	for z=0:d3-1:d3-1%%%%%%todos 0:d3-1
   	for y=0:(d2-2)%%%todos 0:d2-1
         for x=1:d1-1%%%todos 1:d1
            numpolig=numpolig+1;
            X(:,numpolig)=[R(x+d1*y+d1*d2*z,1);R(x+1+d1*y+d1*d2*z,1);R(x+1+d1*(y+1)+d1*d2*z,1);R(x+d1*(y+1)+d1*d2*z,1)];
            Y(:,numpolig)=[R(x+d1*y+d1*d2*z,2);R(x+1+d1*y+d1*d2*z,2);R(x+1+d1*(y+1)+d1*d2*z,2);R(x+d1*(y+1)+d1*d2*z,2)];
            Z(:,numpolig)=[R(x+d1*y+d1*d2*z,3);R(x+1+d1*y+d1*d2*z,3);R(x+1+d1*(y+1)+d1*d2*z,3);R(x+d1*(y+1)+d1*d2*z,3)];
   	   end%x
	  	end%y
     end%z
     for y=0:d2-1:d2-1
      for z=0:d3-2
         for x=1:d1-1
            numpolig=numpolig+1;
            X(:,numpolig)=[R(x+d1*y+d1*d2*z,1);R(x+1+d1*y+d1*d2*z,1);R(x+1+d1*y+d1*d2*(z+1),1);R(x+d1*y+d1*d2*(z+1),1)];
            Y(:,numpolig)=[R(x+d1*y+d1*d2*z,2);R(x+1+d1*y+d1*d2*z,2);R(x+1+d1*y+d1*d2*(z+1),2);R(x+d1*y+d1*d2*(z+1),2)];
            Z(:,numpolig)=[R(x+d1*y+d1*d2*z,3);R(x+1+d1*y+d1*d2*z,3);R(x+1+d1*y+d1*d2*(z+1),3);R(x+d1*y+d1*d2*(z+1),3)];
   	   end%x
	  	end%y
	end%z
      for x=1:d1-1:d1
      for z=0:d3-2
         for y=0:d2-2
            numpolig=numpolig+1;
            X(:,numpolig)=[R(x+d1*y+d1*d2*z,1);R(x+d1*y+d1*d2*(z+1),1);R(x+d1*(y+1)+d1*d2*(z+1),1);R(x+d1*(y+1)+d1*d2*z,1)];
            Y(:,numpolig)=[R(x+d1*y+d1*d2*z,2);R(x+d1*y+d1*d2*(z+1),2);R(x+d1*(y+1)+d1*d2*(z+1),2);R(x+d1*(y+1)+d1*d2*z,2)];
            Z(:,numpolig)=[R(x+d1*y+d1*d2*z,3);R(x+d1*y+d1*d2*(z+1),3);R(x+d1*(y+1)+d1*d2*(z+1),3);R(x+d1*(y+1)+d1*d2*z,3)];
   	   end%x
	  	end%y
	end%z
  fill3(X,Y,Z,X);
  axis([-2,d1+2,-2,d2+2,0,d3+2]);
  %pause(0);
  M(k)=getframe;
  %%%%%%%%%%%%%%%%%%%%%%%%%%
  for z=0:(d3-1)%%%%%todos 0:d3-1
    for y=0:(d2-1)%%%todos 0:d2-1
      for x=1+1:d1-1%%%todos 1:d1
         DX=[0,0,0];
         %%%%%%%%%%%%%%%%%%% N %%%%%%%%%%%%%%%%%%
         if y~=d2-1
            DR=R(x+d1*y+d1*d2*z,:)-R(x+d1*(y+1)+d1*d2*z,:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-1)*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% S %%%%%%%%%%%%%%%%%%
         if y~=0
            DR=R(x+d1*y+d1*d2*z,:)-R(x+d1*(y-1)+d1*d2*z,:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-1)*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% E %%%%%%%%%%%%%%%%%%%
         if x~=d1
            DR=R(x+d1*y+d1*d2*z,:)-R((x+1)+d1*y+d1*d2*z,:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-1)*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% O %%%%%%%%%%%%%%%%%%%%
         if x~=1
            DR=R(x+d1*y+d1*d2*z,:)-R((x-1)+d1*y+d1*d2*z,:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-1)*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% NE %%%%%%%%%%%%%%%%%%
         if x~=d1 & y~=d2-1
            DR=R(x+d1*y+d1*d2*z,:)-R((x+1)+d1*(y+1)+d1*d2*z,:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(2))*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% NO %%%%%%%%%%%%%%%%%%
         if x~=1 & y~=d2-1
            DR=R(x+d1*y+d1*d2*z,:)-R((x-1)+d1*(y+1)+d1*d2*z,:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(2))*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% SE %%%%%%%%%%%%%%%%%%
         if x~=d1 & y~=0
            DR=R(x+d1*y+d1*d2*z,:)-R((x+1)+d1*(y-1)+d1*d2*z,:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(2))*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% SO %%%%%%%%%%%%%%%%%%
         if x~=1 & y~=0
            DR=R(x+d1*y+d1*d2*z,:)-R((x-1)+d1*(y-1)+d1*d2*z,:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(2))*r;%vector desplazamiento
         end
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %							para la capa z-1	si z distinta de 0  			%
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       if z~=0  
         DR=R(x+d1*y+d1*d2*z,:)-R(x+d1*y+d1*d2*(z-1),:);%vector posición relativa
         dr=norm(DR);
         r=DR/dr;%unitario en la dirección de desplazamiento
         DX=DX+(dr-1)*r;%vector desplazamiento
         %%%%%%%%%%%%%%%%%%% N %%%%%%%%%%%%%%%%%%
         if y~=d2-1
            DR=R(x+d1*y+d1*d2*z,:)-R(x+d1*(y+1)+d1*d2*(z-1),:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(2))*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% S %%%%%%%%%%%%%%%%%%
         if y~=0
            DR=R(x+d1*y+d1*d2*z,:)-R(x+d1*(y-1)+d1*d2*(z-1),:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(2))*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% E %%%%%%%%%%%%%%%%%%%
         if x~=d1
            DR=R(x+d1*y+d1*d2*z,:)-R((x+1)+d1*y+d1*d2*(z-1),:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(2))*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% O %%%%%%%%%%%%%%%%%%%%
         if x~=1
            DR=R(x+d1*y+d1*d2*z,:)-R((x-1)+d1*y+d1*d2*(z-1),:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(2))*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% NE %%%%%%%%%%%%%%%%%%
         if x~=d1 & y~=d2-1
            DR=R(x+d1*y+d1*d2*z,:)-R((x+1)+d1*(y+1)+d1*d2*(z-1),:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(3))*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% NO %%%%%%%%%%%%%%%%%%
         if x~=1 & y~=d2-1
            DR=R(x+d1*y+d1*d2*z,:)-R((x-1)+d1*(y+1)+d1*d2*(z-1),:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(3))*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% SE %%%%%%%%%%%%%%%%%%
         if x~=d1 & y~=0
            DR=R(x+d1*y+d1*d2*z,:)-R((x+1)+d1*(y-1)+d1*d2*(z-1),:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(3))*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% SO %%%%%%%%%%%%%%%%%%
         if x~=1 & y~=0
            DR=R(x+d1*y+d1*d2*z,:)-R((x-1)+d1*(y-1)+d1*d2*(z-1),:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(3))*r;%vector desplazamiento
         end
       end% if z~=0  
	    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %							para la capa z+1	si z distinta de d3-1 		 %
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       if z~=d3-1  
         DR=R(x+d1*y+d1*d2*z,:)-R(x+d1*y+d1*d2*(z+1),:);%vector posición relativa
         dr=norm(DR);
         r=DR/dr;%unitario en la dirección de desplazamiento
         DX=DX+(dr-1)*r;%vector desplazamiento
         %%%%%%%%%%%%%%%%%%% N %%%%%%%%%%%%%%%%%%
         if y~=d2-1
            DR=R(x+d1*y+d1*d2*z,:)-R(x+d1*(y+1)+d1*d2*(z+1),:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(2))*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% S %%%%%%%%%%%%%%%%%%
         if y~=0
            DR=R(x+d1*y+d1*d2*z,:)-R(x+d1*(y-1)+d1*d2*(z+1),:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(2))*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% E %%%%%%%%%%%%%%%%%%%
         if x~=d1
            DR=R(x+d1*y+d1*d2*z,:)-R((x+1)+d1*y+d1*d2*(z+1),:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(2))*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% O %%%%%%%%%%%%%%%%%%%%
         if x~=1
            DR=R(x+d1*y+d1*d2*z,:)-R((x-1)+d1*y+d1*d2*(z+1),:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(2))*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% NE %%%%%%%%%%%%%%%%%%
         if x~=d1 & y~=d2-1
            DR=R(x+d1*y+d1*d2*z,:)-R((x+1)+d1*(y+1)+d1*d2*(z+1),:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(3))*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% NO %%%%%%%%%%%%%%%%%%
         if x~=1 & y~=d2-1
            DR=R(x+d1*y+d1*d2*z,:)-R((x-1)+d1*(y+1)+d1*d2*(z+1),:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(3))*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% SE %%%%%%%%%%%%%%%%%%
         if x~=d1 & y~=0
            DR=R(x+d1*y+d1*d2*z,:)-R((x+1)+d1*(y-1)+d1*d2*(z+1),:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(3))*r;%vector desplazamiento
         end
         %%%%%%%%%%%%%%%%%%% SO %%%%%%%%%%%%%%%%%%
         if x~=1 & y~=0
            DR=R(x+d1*y+d1*d2*z,:)-R((x-1)+d1*(y-1)+d1*d2*(z+1),:);%vector posición relativa
            dr=norm(DR);
            r=DR/dr;%unitario en la dirección de desplazamiento
            DX=DX+(dr-sqrt(3))*r;%vector desplazamiento
         end
       end% if z~=d3-1  
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
       
	     V(x+d1*y+d1*d2*z,:)=V(x+d1*y+d1*d2*z,:)+(-K1*DX-K2*V(x+d1*y+d1*d2*z,:)+gravedad)*T;
        Rf(x+d1*y+d1*d2*z,:)=R(x+d1*y+d1*d2*z,:)+V(x+d1*y+d1*d2*z,:)*T;
      end%x
    end%y 
  end%z    
  R=Rf;
  pause(0);
end;
movie(M,5);