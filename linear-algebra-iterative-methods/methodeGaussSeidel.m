function [X, iterations, erreur] = methodeGaussSeidel(A, B, precision, maxIterations)
  
    % A : matrice carrée (n, n)
    % B : vecteur (n, 1)
    % precision : critère d'arrêt (tolérance)
    % maxIterations : nombre maximum d'itérations
    % X : solution approximative
    % iterations : nombre d'itérations réalisées
    % erreur : norme de l'erreur finale
    
    % Initialisation des variables
    n = length(B);           % Taille du système
    X = zeros(n, 1);         % Initialisation du vecteur solution X à zéro
    erreur = inf;            % Initialisation de l'erreur
    iterations = 0;          % Compteur d'itérations

    % Boucle principale pour les itérations
    while erreur > precision && iterations < maxIterations
        iterations = iterations + 1;
        X_prev = X;

        % Mise à jour de chaque composante de X
        for i = 1:n
            % Calcul des termes de la somme inférieure (somme1)
            somme1 = A(i, 1:i-1) * X(1:i-1);

            % Calcul des termes de la somme supérieure (somme2)
            somme2 = A(i, i+1:n) * X_prev(i+1:n);

            X(i) = (B(i) - somme1 - somme2) / A(i, i);
        end

        erreur = norm(A * X - B);   % Calcul de l'erreur

    end

    % Vérification de la convergence
    if iterations == maxIterations
        disp('Attention : La méthode de Gauss-Seidel n’a pas convergé après le nombre maximum d’itérations.');
    end
end
