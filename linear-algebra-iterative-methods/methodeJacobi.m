function [X, iterations, erreur] = methodeJacobi(A, B, precision, maxIterations)
    
    % A : matrice carrée (n, n)
    % B : vecteur (n, 1)
    % precision : critère d'arrêt (tolérance)
    % maxIterations : nombre maximum d'itérations
    % X : solution approximative
    % iterations : nombre d'itérations réalisées
    % erreur : norme de l'erreur finale

    % Initialisation des variables
    n = length(B);          % Taille du système
    X = zeros(n, 1);        % Initialisation du vecteur solution X à zéro
    X_prev = X;             % Copie pour l'itération précédente
    erreur = inf;           % Initialisation de l'erreur
    iterations = 0;         % Compteur d'itérations

    % Décomposition de la matrice A
    % D : Matrice diagonale de A contenant uniquement les éléments diagonaux
    % R : Matrice contenant le reste des éléments (A - D)
    D = diag(diag(A));
    R = A - D;

    while erreur > precision && iterations < maxIterations
        iterations = iterations + 1;

        % Calcul de la nouvelle approximation de X
        % D \ (vecteur) est utilisé pour éviter l'inversion explicite de D
        X = D \ (B - R * X_prev);

        erreur = norm(A * X - B);   % Calcul de l'erreur
        X_prev = X;
    end

    % Vérification de la convergence
    if iterations == maxIterations
        disp('Attention : La méthode de Jacobi n’a pas convergé après le nombre maximum d’itérations.');
    end
end
