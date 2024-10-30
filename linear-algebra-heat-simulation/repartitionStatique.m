% Paramètres
Nx = 15;                
Ny = 40;                
maxIterations = 1000;  
tolerance = 1e-4;       

% Initialisation de la matrice des températures
Temperature = zeros(Nx, Ny);  

% Conditions aux limites
Temperature(:, 1) = 200; 
Temperature(:, end) = 200; 
Temperature(1, :) = 200;  
Temperature(end, :) = 200;  

% Points spécifiques avec des températures fixes
point_I = [12, 30];	      % Point I à 300°C
point_J = [8, 17];        % Point J à 300°C
point_K = [4, 2];         % Point K à 100°C

Temperature(point_I(1), point_I(2)) = 300;
Temperature(point_J(1), point_J(2)) = 300;
Temperature(point_K(1), point_K(2)) = 100;

% Méthode itérative de Gauss-Seidel pour résoudre le problème
for iteration = 1:maxIterations
    Temperature_old = Temperature;

    % Mise à jour des températures internes
    for i = 2:Nx-1
        for j = 2:Ny-1
            if (i == point_I(1) && j == point_I(2)) || ...
               (i == point_J(1) && j == point_J(2)) || ...
               (i == point_K(1) && j == point_K(2))
                continue;
            end
        
            % Calcul de la nouvelle température
            Temperature(i, j) = 0.25 * (Temperature_old(i+1, j) + Temperature_old(i-1, j) + ...
                                        Temperature_old(i, j+1) + Temperature_old(i, j-1));
        end
    end

    % Critère de convergence
    if max(max(abs(Temperature - Temperature_old))) < tolerance
        fprintf('Convergence atteinte après %d itérations\n', iteration);
        break;
    end
end

% Visualisation des résultats
surf(Temperature);  
xlabel('AXE X'); 
ylabel('AXE Y'); 
zlabel('Température (°C)');  
title('Répartition Statique de Température sur la Surface Métallique');
colormap jet;  
colorbar;  
