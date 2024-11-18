function testMethodes()
    % Exemple 1 : Matrice 2x2
    A1 = [3, 2; 2, 3];
    disp('Test sur la matrice 2x2 :');
    executeTest(A1);

    % Exemple 2 : Matrice 3x3
    A2 = [4, 1, 2; 1, 5, 3; 2, 3, 6];  
    disp('Test sur la matrice 3x3 :');
    executeTest(A2);

    % Exemple 3 : Matrice 4x4
    A3 = [4, 1, 2, 3; 1, 5, 6, 7; 2, 6, 8, 9; 3, 7, 9, 10];
    disp('Test sur la matrice 4x4 :');
    executeTest(A3);
end

function executeTest(A)
    % Paramètres
    tol = 1e-6;                 % Tolérance pour la convergence
    max_iter = 10000;           % Nombre maximum d'itérations
    Y0 = rand(size(A, 1), 1);   % Vecteur de départ aléatoire pour l'itération
    valeurs_propres = [];       % Tableau pour stocker les valeurs propres calculées
    vecteurs_propres = [];      % Matrice pour stocker les vecteurs propres calculés

    disp('Matrice testée :');
    disp(A);
    A_original = A;

    for i = 1:size(A, 1)
        % Calcul des valeurs propres et vecteurs propres avec la méthode de puissance itérée
        [lambda, v] = puissanceIteree(A, Y0, tol, max_iter);
        valeurs_propres = [valeurs_propres; lambda];           % Stockage de la valeur propre calculée
        vecteurs_propres = [vecteurs_propres, v];              % Stockage du vecteur propre

        % Application de la déflation de Wielandt pour mettre à jour la matrice
        A = deflationWielandt(A, v, lambda); 
    end

    % Comparaison des valeurs propres calculées avec celles de MATLAB
    disp('Comparaison des valeurs propres :');
    [V_eig, D_eig] = eig(A_original); 
    valeurs_eig = diag(D_eig);  

    % Création d'un tableau pour comparer les valeurs propres calculées et celles de MATLAB
    eigenComparison = table(valeurs_propres, valeurs_eig, 'VariableNames', {'Méthodes', 'MATLAB'});
    disp(eigenComparison);
    disp('-------------------------');

    % Comparaison des vecteurs propres calculés et ceux de MATLAB
    disp('Comparaison des vecteurs propres :');
    disp('Vecteurs propres (Méthode) :');
    disp(vecteurs_propres);
    disp('Vecteurs propres (MATLAB) :');
    disp(V_eig);
end
