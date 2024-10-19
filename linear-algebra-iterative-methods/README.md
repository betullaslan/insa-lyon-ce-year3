# Iterative Methods for Solving Linear Systems in MATLAB

This project implements and compares three classical **iterative methods** for solving linear systems of the form `AX = B`. It was developed as part of Coursework 1 in the *Linear Algebra and Image Synthesis* course at INSA Lyon.

---

## Project Scope

This repository includes only the MATLAB code written to implement the iterative solution methods for linear systems, as part of the TP1 assignment.  
All iterative solving functions and the comparison test script were written from scratch.

The implemented methods are:
- Jacobi method  
- Gauss-Seidel method  
- Relaxation method  

Each method is tested using a custom driver script that allows parameter tuning and performance comparison.

## Files

- `methodeJacobi.m` — Implementation of the **Jacobi** method  
- `methodeGaussSeidel.m` — Implementation of the **Gauss-Seidel** method  
- `methodeRelaxation.m` — Implementation of the **Relaxation** method with a tunable parameter `w`  
- `programmeTest.m` — Test program that calls the above functions and compares their results

---

## Project Info

- **Project Name:** Iterative Methods for Linear Systems  
- **Language:** MATLAB  
- **Authors:** Betul Aslan

---

## Academic Info

- **Course:** Linear Algebra and Image Synthesis
- **Institution:** INSA Lyon  
- **Department:** Computer Science  
- **Academic Year:** 2024–2025 Fall  
- **Assignment:** Coursework 1

---

## Theoretical Background

The methods solve a system `AX = B` where:

- `A` is a square matrix of size `n × n`
- `B` is a known vector
- `X` is the unknown solution

All three methods rely on decomposing matrix `A` into its diagonal (`D`), lower (`L`), and upper (`U`) parts:

- **Jacobi**: uses `M = D`  
- **Gauss-Seidel**: uses `M = D + L`  
- **Relaxation**: introduces a parameter `w` and uses `M = D + wL`

The Relaxation method generalizes Gauss-Seidel:
- `w = 1` → Gauss-Seidel  
- `w < 1` → under-relaxation  
- `w > 1` → over-relaxation  
- The method converges if `0 < w < 2`

---

## Features & Implementation Notes

- **No matrix inversion** is used. All solvers compute values element-wise.  
- **Stopping condition** is based on residual norm: `||AX - B|| < tolerance`.  
- **Iteration limit** is enforced to avoid infinite loops in case of divergence.  
- **Test script** allows switching methods, matrix types, and precision levels.
