% Paramètres
Nx = 15; 
Ny = 40; 
maxIterations = 1000; 
tolerance = 1e-4;

% Initialisation de la matrice des températures
Temperature = 200 * ones(Nx, Ny); 

% Points spécifiques avec des températures fixes
point_I = [12, 30];   
point_J = [8, 17];      
point_K = [4, 2];       

Temperature(point_I(1), point_I(2)) = 300; 
Temperature(point_J(1), point_J(2)) = 300; 
Temperature(point_K(1), point_K(2)) = 100; 

% Simulation de la dynamique thermique
for iteration = 1:maxIterations
    Temperature_old = Temperature; 
    
    % Mise à jour des températures internes
    for i = 2:Nx-1
        for j = 2:Ny-1
            % Ignorer les bords et les points fixes
            if i == 1 || i == Nx || j == 1 || j == Ny || ...
               (i == point_I(1) && j == point_I(2)) || ...
               (i == point_J(1) && j == point_J(2)) || ...
               (i == point_K(1) && j == point_K(2))
                continue;
            end
            
            Temperature(i, j) = 0.25 * (Temperature_old(i+1, j) + ...
                                        Temperature_old(i-1, j) + ...
                                        Temperature_old(i, j+1) + ...
                                        Temperature_old(i, j-1));
        end
    end
    
    % Vérification de la convergence
    if max(max(abs(Temperature - Temperature_old))) < tolerance
        fprintf('Convergence atteinte après %d''itérations\n', iteration);
        break;
    end
    
    % Visualisation
    surf(Temperature);
    xlabel('AXE X'); 
    ylabel('AXE Y'); 
    zlabel('Température (°C)');  
    title(['Évolution Libre de la Température - Itération : ', num2str(iteration)]);
    colormap jet;  
    colorbar;
    pause(0.1); 
end

% Si le nombre d'itérations maximum est atteint, afficher un message
if iteration == maxIterations
    fprintf('Le nombre maximal d''itérations a été atteint sans convergence.\n');
end
