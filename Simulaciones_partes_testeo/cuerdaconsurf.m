%SIMULA CUERDA
K1 = 500;   % constante de resorte
K2 = 0.2;   % amortiguamiento
rompimiento = 100; % nivel de rompimiento
Fext = [0; -9.8; 0];    % Fuerza externa
T = 0.01;   % intervalo de tiempo
numPart = 10;
p = struct('r', cell(1, numPart), 'v', cell(1, numPart), 'fija', cell(1, numPart), 'n', cell(1, numPart), 'numVec', cell(1, numPart));
% Initialize particles
for x = 1:numPart
    p(x).r = [x; 0; 0];
    p(x).v = [0; 0; 0];
    p(x).fija = 0;
    w = 0;
    for nx = x - 1:2:x + 1 % vecinos de la particula + ella misma              
        if (1 <= nx && nx <= numPart)
            w = w + 1;
            p(x).n(w).ind = nx; % indice del vecino w
            p(x).n(w).disteq = 0.1;
        end
    end
    p(x).numVec = w;
end
p(1).fija = 1;
p(numPart).fija = 1;
pf = p; % auxiliar
% Initialize variables for plotting
numcalculos = 2000;
XX = zeros(1, numPart);
YY = zeros(1, numPart);
% Main simulation loop
for k = 1:numcalculos
    for in = 2:numPart-1
        if (in == floor(numPart / 3) && k < 70)
            Fext = [0; -30; 0];
        else
            Fext = [0; 0; 0];      
        end
        if (p(in).fija == 0)
            DX = [0; 0; 0];
            for w = 1:p(in).numVec
                if (p(in).n(w).ind ~= 0)
                    DR = p(in).r - p(p(in).n(w).ind).r;
                    dr = norm(DR);
                end 
                r = DR / dr;
                DX = DX + (dr - p(in).n(w).disteq) * r;
            end        
            pf(in).v = p(in).v + (-K1 * DX - K2 * p(in).v + Fext) * T;
            pf(in).r = p(in).r + pf(in).v * T;              
        end                  
    end
    p = pf;
    for x = 1:numPart
        XX(x) = p(x).r(1);
        YY(x) = p(x).r(2);
    end
    % Plot onto the SimulationAxes
    surf(XX, YY, zeros(numPart), 'FaceColor', 'interp', 'FaceLighting', 'phong');
    camlight('right');
    axis([-1, numPart + 0.5, -1, 1]);
    drawnow;
end
