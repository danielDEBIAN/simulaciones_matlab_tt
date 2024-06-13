function SalvaDatos(NumGraf,p);%Solo para graficacion 
nom=sprintf('.\\Frames\\frame%0.3d.dat',NumGraf);
fid = fopen(nom,'w');
numPart=length(p);
fprintf(fid,'%d\n',numPart);%num puntos
for i=1:numPart%Primero escribe las coordenadas de las particulas     
   fprintf(fid,'%f ',p(i).r);fprintf(fid,'\n');
end
for i=1:numPart
   fprintf(fid,'%d ',p(i).numVec);%indice de la particula
   for j=1:p(i).numVec
      indVecino=p(i).n(j).ind;
      fprintf(fid,'%d ',indVecino);%escribe indices de vecinos      
   end
   fprintf(fid,'\n');%escribe retorno de carro
end
fclose(fid);