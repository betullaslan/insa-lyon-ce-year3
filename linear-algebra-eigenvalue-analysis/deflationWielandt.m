function A_reduit = deflationWielandt(A, v, lambda)
    % A : matrice carrée
    % v : vecteur propre associé à la valeur propre dominante lambda
    % lambda : valeur propre dominante
    % A_reduit : matrice modifiée après déflation
    
    % Normalisation du vecteur propre v pour obtenir u 
    u = v' / (v' * v);
    
    % Construction de la nouvelle matrice réduite après la déflation
    A_reduit = A - lambda * (v * u);
end
