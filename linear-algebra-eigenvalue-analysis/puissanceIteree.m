function [lambda, v, iter] = puissanceIteree(A, Y0, tol, max_iter)
    % A : matrice carrée
    % Y0 : vecteur initial non nul
    % tol : tolérance pour la convergence
    % lambda : valeur propre dominante
    % v : vecteur propre associé
    % max_iter : nombre maximum d'itérations
    % iter : nombre d'itérations réalisées

    Y = Y0;                 
    for iter = 1:max_iter
        X = Y / norm(Y);    % Normalisation du vecteur
        Y = A * X;          % Produit matriciel pour mettre à jour Y
        lambda = X' * Y;    % Estimation de la valeur propre dominante
 
        % Critère de convergence
        if norm(Y - lambda * X) < tol
            break;
        end
    end

    v = X;      % Vecteur propre associé à la valeur propre dominante
end
