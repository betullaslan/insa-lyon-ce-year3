function [X, iterations, erreur] = methodeRelaxation(A, B, precision, maxIterations, w)
 
    % A : matrice carrée (n, n)
    % B : vecteur (n, 1)
    % precision : critère d'arrêt (tolérance)
    % maxIterations : nombre maximum d'itérations
    % w : Facteur de relaxation
    % X : solution approximative
    % iterations : nombre d'itérations réalisées
    % erreur : norme de l'erreur finale
    
    % Initialisation des variables
    n = length(B);         % Taille du système
    X = zeros(n, 1);       % Initialisation du vecteur solution X à zéro
    erreur = inf;          % Initialisation de l'erreur
    iterations = 0;        % Compteur d'itérations

    % Boucle principale pour les itérations
    while erreur > precision && iterations < maxIterations
        iterations = iterations + 1;
        X_prev = X;

        % Mise à jour de chaque composante de X
        for i = 1:n
            % Calcul des termes de la somme inférieure (somme1)
            % Utilise les valeurs déjà mises à jour dans X
            somme1 = A(i, 1:i-1) * X(1:i-1);

            % Calcul des termes de la somme supérieure (somme2)
            % Utilise les valeurs de l'itération précédente X_prev
            somme2 = A(i, i+1:n) * X_prev(i+1:n);

            % Mise à jour de la composante X(i) avec le facteur de relaxation w
            X(i) = (1 - w) * X_prev(i) + w * (B(i) - somme1 - somme2) / A(i, i);
        end

        erreur = norm(A * X - B);   % Calcul de l'erreur
    end

    % Vérification de la convergence
    if iterations == maxIterations
        disp('Attention : La méthode de relaxation n’a pas convergé après le nombre maximum d’itérations.');
    end
end
