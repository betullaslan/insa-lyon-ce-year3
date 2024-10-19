% Programme pour tester et comparer les méthodes itératives

% Définition des paramètres de test
precision = 1e-4;          % critère d'arrêt (tolérance)
maxIterations = 500;       % nombre maximum d'itérations
w = 1.25;                  % facteur de relaxation

% Définir plusieurs matrices A et vecteurs B pour les tests
% Exemple 1 : Matrice bien conditionnée et diagonale dominante
A1 = [4, 1, 2; 1, 5, 1; 2, 1, 3];
B1 = [7; 8; 9];

% Exemple 2 : Matrice mal conditionnée avec des valeurs élevées dans les coins
A2 = [10, 2, 1; 2, 10, 3; 1, 2, 10];
B2 = [13; 16; 15];

% Exemple 3 : Matrice avec des valeurs élevées dans les coins haut droit et bas gauche
A3 = [10, 1, 2; 1, 15, 3; 2, 1, 20];
B3 = [14; 19; 25];

% Initialisation des résultats
matrices = {A1, A2, A3};
vecteurs = {B1, B2, B3};
methodes = {'Jacobi', 'Gauss-Seidel', 'Relaxation'};

% Boucle sur chaque matrice et vecteur pour tester les méthodes
for test = 1:length(matrices)
    fprintf('\n=== Test %d ===\n', test);
    A = matrices{test};
    B = vecteurs{test};
    fprintf('Matrice A :\n');
    disp(A);
    fprintf('Vecteur B :\n');
    disp(B);

    % Méthode de Jacobi
    fprintf('\nMéthode de Jacobi :\n');
    tic;
    [X_jacobi, iter_jacobi, err_jacobi] = methodeJacobi(A, B, precision, maxIterations);
    temps_jacobi = toc;
    fprintf('Solution :\n');
    disp(X_jacobi);
    fprintf('Itérations : %d, Erreur finale : %.5f, Temps : %.5f secondes\n', iter_jacobi, err_jacobi, temps_jacobi);

    % Méthode de Gauss-Seidel
    fprintf('\nMéthode de Gauss-Seidel :\n');
    tic;
    [X_gauss, iter_gauss, err_gauss] = methodeGaussSeidel(A, B, precision, maxIterations);
    temps_gauss = toc;
    fprintf('Solution :\n');
    disp(X_gauss);
    fprintf('Itérations : %d, Erreur finale : %.5f, Temps : %.5f secondes\n', iter_gauss, err_gauss, temps_gauss);

    % Méthode de Relaxation
    fprintf('\nMéthode de Relaxation (w = %.2f) :\n', w);
    tic;
    [X_relax, iter_relax, err_relax] = methodeRelaxation(A, B, precision, maxIterations, w);
    temps_relax = toc;
    fprintf('Solution :\n');
    disp(X_relax);
    fprintf('Itérations : %d, Erreur finale : %.5f, Temps : %.5f secondes\n', iter_relax, err_relax, temps_relax);

    % Comparaison des résultats
    fprintf('\nRésumé des performances :\n');
    fprintf('Méthode          | Itérations | Erreur finale | Temps (s)\n');
    fprintf('Jacobi           | %d         | %.5f        | %.5f\n', iter_jacobi, err_jacobi, temps_jacobi);
    fprintf('Gauss-Seidel     | %d         | %.5f        | %.5f\n', iter_gauss, err_gauss, temps_gauss);
    fprintf('Relaxation       | %d         | %.5f        | %.5f\n', iter_relax, err_relax, temps_relax);
end
