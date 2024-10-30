% Paramètres
n_x = 40;               % Nombre de colonnes (grille en x)
n_y = 15;               % Nombre de lignes (grille en y)
T = zeros(n_y, n_x);    % Températures initiales à 0°C partout

% Points où la chaleur est injectée (I, J, K)
T_chauffage = 500;                           % Température appliquée aux points I, J, K
points_chauffage = [12, 30; 8, 17; 4, 2];    % Coordonnées des points [ligne, colonne]

% Paramètres de convergence et de simulation
tolerance = 1e-4;
delta_t = 0.1; 
iterations = 1000; 

fig = figure;

% Simulation de la propagation de la chaleur
try
    for t = 1:iterations
        T_old = T;
        
        % Mise à jour des températures pour les points internes 
        for i = 2:n_y-1
            for j = 2:n_x-1
                T(i, j) = 0.25 * (T_old(i-1, j) + T_old(i+1, j) + ...
                                  T_old(i, j-1) + T_old(i, j+1));
            end
        end
        
        % Appliquer la température aux points I, J, K
        for k = 1:size(points_chauffage, 1)
            T(points_chauffage(k, 1), points_chauffage(k, 2)) = T_chauffage;
        end
        
        % Vérification de la convergence
        if max(max(abs(T - T_old))) < tolerance
            disp(['Simulation terminée à l''itération ', num2str(t)]);
            total_time = t * delta_t;
            disp(['Temps total pour atteindre l''équilibre: ', num2str(total_time), ' secondes']);
            break;
        end
        
        % Visualisation
        clf; 
        surf(T);
        title(['Chauffage de la Plaque - Itération ' num2str(t)]);
        xlabel('AXE X');
        ylabel('AXE Y');
        zlabel('Température (°C)');
        zlim([0, T_chauffage]); 
        xlim([1, n_x]); 
        ylim([1, n_y]); 
        colorbar;
        pause(0.1); 
        
        % Vérifie si la figure est fermée
        if ~isvalid(fig)
            disp('Animation interrompue : Fenêtre fermée.');
            break;
        end
    end
catch
    disp('Erreur : Animation terminée.');
end

% Si le maximum d'itérations est atteint
if t == iterations
    total_time = iterations * delta_t;
    disp(['Simulation terminée après le nombre maximum d''itérations.']);
    disp(['Temps total simulé: ', num2str(total_time), ' secondes']);
end
