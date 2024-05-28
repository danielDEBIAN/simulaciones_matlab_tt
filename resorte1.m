%%simulacion de resorte simple
clearvars;
close all
clc
r=1;%longitud
T=0.001;%delta tiempo
K=100000;%k/m
amortiguamiento=1;
xi=0;
vi=10;
N=10000;
%for T=0.0001:.0001:0.001
    xi=0;
    xi=vi*T+xi;
    y=zeros(1,N);
    for k=1:N
        vf=vi+(-K*xi-amortiguamiento*vi)*T;%actualizacion de la velocidad
        xf=xi+vf*T;%actualizacion de la posicion
        y(k)=xf;
        xi=xf;
        vi=vf;
    end
    x=(1:N)*T;
    hold on
    plot(x,y,'.-');
%end
sound(y/max(y),10000)
