% 1. Étape : Charger l'image
image = imread('ImageTest.png'); 
if size(image, 3) == 3
    image_gris = rgb2gray(image);   % Si l'image est en couleur, la convertir en niveaux de gris
else
    image_gris = image;             % Si l'image est déjà en niveaux de gris, l'utiliser directement
end
A = double(image_gris);     % Convertir l'image en une matrice de type double (valeurs entre 0 et 255)

% 2. Étape : Décomposition en valeurs singulières (SVD)
[U, S, V] = svd(A); 

% 3. Étape : Reconstruction progressive de l'image à l'aide de la formule SVD
[m, n] = size(A);      % Dimensions de la matrice
r = min(m, n);         % Nombre maximal de valeurs singulières
figure;

% Utiliser les 36 premières valeurs singulières pour la reconstruction progressive
for k = 1:36    
    A_k = zeros(m, n);    
    for i = 1:k
        A_k = A_k + S(i, i) * (U(:, i) * V(:, i)');
    end
    subplot(6, 6, k);   % Afficher les images dans une grille de 6x6
    imagesc(A_k);       % Afficher l'image reconstruite
    colormap gray;      % Afficher en niveaux de gris
    title(['k = ', num2str(k)]); 
end

% 4. Étape : Reconstruction complète de l'image en utilisant toutes les valeurs singulières
A_reconstruction_complete = U * S * V';

% 5. Étape : Visualisation de l'image originale et reconstruite
figure;
subplot(1, 2, 1);
imagesc(A); 
colormap gray;
title('Image originale'); 

subplot(1, 2, 2);
imagesc(A_reconstruction_complete); 
colormap gray;
title('Image complètement reconstruite'); 

% 6. Étape : Calculer la différence entre l'image originale et la reconstruction complète
erreur_reconstruction = A - A_reconstruction_complete;    % Différence entre les deux matrices
mse = mean(erreur_reconstruction(:).^2);                  % Calcul de l'erreur quadratique moyenne
rmse = sqrt(mse);                                         % Calcul de la racine de l'erreur quadratique moyenne

% Afficher les résultats
disp(['Erreur quadratique moyenne (MSE): ', num2str(mse)]);
disp(['Racine de l''erreur quadratique moyenne (RMSE): ', num2str(rmse)]);
