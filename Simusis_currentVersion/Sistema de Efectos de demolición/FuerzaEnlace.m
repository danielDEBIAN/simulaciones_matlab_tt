%%%%%%%%%%Calcula fuerza del enlace%%%%%%%%%%%%
%%%%%%%%%%entre particulas%%%%%%%%%%%%%%%%%%%%%
function fza=fuerzaEnlace(delta,ru,tipo);
fza=delta*(1.6325e+4)*ru;%Fuerza de enlace temporal
% if tipo==1
%     fza=delta*(1.6325e+11)*ru;%Fuerza de enlace del Acero
% elseif tipo==2
%     fza=delta*(1.2263e+9)*ru;%Fuerza de enlace del Concreto
% end

%fza=delta*(4.905e+9)*ru;
return
% % %concreto lineal
% % %%%%%%% ajuste a una parabola %%%%%%%%%%%
% % a= -1.8464e+005;
% % b=  3.0646e+010;
% % c= -6.5562e+012;
% % x=delta;
% % %fza=(a+b*x+c*x.^2)*ru;
% % return
% % %%%%%%%%%%%%%%%%%%
%200,000Kg/cm2 resistencia del concreto
%Area (50cm)^2/4=625cm^2
%200000*625*9.81=1.2263e+9 Newtons
