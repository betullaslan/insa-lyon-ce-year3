# Eigenvalue Computation and Vibrational Analysis in MATLAB

This project explores multiple numerical methods to compute **eigenvalues** and **eigenvectors** of matrices and applies these concepts to physical simulations such as **drum membrane vibration** and **image compression via singular value decomposition (SVD)**. It was developed as part of Coursework 3 in the *Linear Algebra and Image Synthesis* course at INSA Lyon.

---

## Project Scope

This repository includes original MATLAB implementations of:
- Power iteration and Wielandt deflation for eigenvalue extraction  
- Vibrational mode simulation of a discrete drum membrane model  
- Singular Value Decomposition (SVD) for progressive image reconstruction

All algorithms are tested using custom matrices and visualized via surface plots or grayscale images.

---

## Files

- `puissanceIteree.m` — Implements the **Power Iteration** method to compute the dominant eigenvalue and eigenvector  
- `deflationWielandt.m` — Implements **Wielandt’s Deflation** to compute multiple eigenvalues  
- `vibrationTambour.m` — Simulates **drum vibration modes** by solving a Laplacian eigenproblem  
- `applicationBonus.m` — Applies **SVD** for image compression and progressive reconstruction  
- `testMethodes.m` — A script to compare and validate the implemented algorithms  
- `README.md` — This documentation file

---

## Project Info

- **Project Name:** Eigenvalue Analysis and Applications  
- **Language:** MATLAB  
- **Authors:** Betul Aslan  
---

## Academic Info

- **Course:** Linear Algebra and Image Synthesis  
- **Institution:** INSA Lyon  
- **Department:** Computer Science  
- **Academic Year:** 2024–2025 Fall  
- **Assignment:** Coursework 3

---

## Methodological Background

### Power Iteration  
Estimates the **dominant eigenvalue** (largest in magnitude) using repeated matrix-vector multiplication followed by normalization.

### Wielandt Deflation  
Sequentially removes previously computed eigenvalues from the spectrum, allowing subsequent eigenvalues to be found using the same power iteration logic.

### Inverse Iteration (Mentioned)
By applying the power iteration to the inverse or shifted-inverse of a matrix, it enables estimation of the **smallest** or **targeted** eigenvalues.

### Vibrational Mode Simulation  
Solves the eigenvalue problem for a discrete Laplacian: A·u = −λ·u to compute standing wave modes (eigenfunctions) on a rectangular drum surface.

### SVD-Based Image Compression  
Uses the SVD decomposition: A = Σ σᵢ uᵢ vᵢᵗ to progressively reconstruct an image by increasing rank. Quality is assessed relative to the original matrix (image).

---

## Features

- Accurate computation of multiple eigenvalues and vectors  
- Visual simulation of vibrational modes using surface plots  
- Interactive progressive image reconstruction with SVD  
- Norm-based stopping conditions and vector orthogonality checks  
- Comparisons with MATLAB's built-in `eig` function for validation
