function GraficaAlambres(p);
clf
hold on
numPart=length(p);
for ind1=1:numPart    
   for j=1:p(ind1).numVec
      ind2=p(ind1).n(j).ind;
      if (ind2>ind1)
         if 1%j<3 
            X=[p(ind1).r(1),p(ind2).r(1)];
            Y=[p(ind1).r(2),p(ind2).r(2)];
            Z=[p(ind1).r(3),p(ind2).r(3)];
            plot3(X,Y,Z);
            %plot3(X(1),Y(1),Z(1),'o');
         end
      end   
   end
end
view(3)
axis equal
xlabel('x');   ylabel('y');   zlabel('z');
grid on
%axis ([-2,2,-2,2,-1,4]);
%camdolly(2,2,2,'fixtarget','data');
