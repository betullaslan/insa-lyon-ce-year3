N = 24;             % Grille de 24x24 (géométrie du tambour)
tol = 1e-6;         % Tolérance pour la convergence
max_iter = 1000;    % Nombre maximal d'itérations
Y0 = rand(N^2, 1);  % Vecteur initial aléatoire

% Création de la matrice Laplacienne (modèle du tambour)
A = zeros(N^2, N^2);            % Initialisation de la matrice carrée
for i = 1:N
    for j = 1:N
        idx = (i-1)*N + j;      % Indice linéaire pour la matrice
        % Points à l'intérieur du tambour
        if (i - N/2)^2 + (j - N/2)^2 <= (N/2)^2 
            A(idx, idx) = 4;                    % Point central
            if i > 1, A(idx, idx-N) = -1; end   % Voisin du haut
            if i < N, A(idx, idx+N) = -1; end   % Voisin du bas
            if j > 1, A(idx, idx-1) = -1; end   % Voisin de gauche
            if j < N, A(idx, idx+1) = -1; end   % Voisin de droite
        end
    end
end

% Étape 1 : Calcul des 50 plus petites valeurs propres et vecteurs propres 
valeurs_propres_petites = [];
vecteurs_propres_petits = [];
for i = 1:50
    [lambda, v, ~] = puissanceIteree(A, Y0, tol, max_iter);    
    valeurs_propres_petites = [valeurs_propres_petites; lambda];
    vecteurs_propres_petits = [vecteurs_propres_petits, v];
    A = deflationWielandt(A, v, lambda);                       
end

% Étape 2 : Calcul des 20 plus grandes valeurs propres
valeurs_propres_grandes = [];
vecteurs_propres_grands = [];
for i = 1:20
    [lambda, v, ~] = puissanceIteree(A, Y0, tol, max_iter); 
    lambda_grand = 1 / lambda; 
    valeurs_propres_grandes = [valeurs_propres_grandes; lambda_grand];
    vecteurs_propres_grands = [vecteurs_propres_grands, v];
    A = deflationWielandt(A, v, lambda_grand); 
end

% Étape 3 : Trouver la valeur propre la plus proche de 0.53 
c = 0.53; 
A_shifted = inv(A - c * eye(size(A))); 
[lambda_shifted, v, ~] = puissanceIteree(A_shifted, Y0, tol, max_iter);
lambda_proche = c + 1 / lambda_shifted; 
vecteur_proche = v;

% Visualisation des résultats
% Exemple d'une petite valeur propre
figure;
subplot(2, 2, 1);
vec = vecteurs_propres_petits(:, 1);
imagesc(reshape(vec, N, N));
colorbar;
title(['Exemple petite valeur propre : ', num2str(valeurs_propres_petites(1))]);

% Exemple d'une grande valeur propre
subplot(2, 2, 2);
vec = vecteurs_propres_grands(:, 1);
imagesc(reshape(vec, N, N));
colorbar;
title(['Exemple grande valeur propre : ', num2str(valeurs_propres_grandes(1))]);

% Exemple de la valeur propre proche de 0.53
subplot(2, 2, 3);
imagesc(reshape(vecteur_proche, N, N));
colorbar;
title(['Valeur propre proche de 0.53 : ', num2str(lambda_proche)]);

% Affichage des listes des valeurs propres
disp('50 plus petites valeurs propres :');
disp(valeurs_propres_petites');
disp('20 plus grandes valeurs propres :');
disp(valeurs_propres_grandes');
disp(['Valeur propre la plus proche de 0.53 : ', num2str(lambda_proche)]);
