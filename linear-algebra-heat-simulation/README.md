# Heat Distribution and Temperature Propagation in MATLAB

This project simulates both **static heat distribution** and **time-dependent temperature propagation** on a metal plate using **finite difference methods** and matrix-based modeling. It was developed as part of Coursework 2 in the *Linear Algebra and Image Synthesis* course at INSA Lyon.

---

## Project Scope

The repository contains MATLAB code that implements:
- Discretization of a 2D Laplace equation for static temperature modeling  
- Time-based simulation of heat diffusion across a metallic plate  
- An active heating model with persistent temperature injection at fixed points  

All numerical simulations are visualized using surface plots and animation with MATLAB's graphical functions.

---

## Files

- `repartitionStatique.m` — Computes **static equilibrium temperature** by solving a linear system  
- `evolutionLibreTemperature.m` — Simulates **natural temperature evolution** from an initial condition  
- `chauffagePlaque.m` — Simulates **external heating** at fixed points over time  
- `README.md` — Project documentation

---

## Project Info

- **Project Name:** Heat Distribution and Propagation on a Plate  
- **Language:** MATLAB  
- **Authors:** Betul Aslan  

---

## Academic Info

- **Course:** Linear Algebra and Image Synthesis  
- **Institution:** INSA Lyon  
- **Department:** Computer Science  
- **Academic Year:** 2024–2025 Fall  
- **Assignment:** Coursework 2

---

## Mathematical Background

### 1. Static Heat Distribution
The model is based on the **Laplace equation** in 2D:
Δu = ∂²u/∂x² + ∂²u/∂y² = 0
Discretization via finite differences results in a linear system `A·X = B`, where `X` contains the temperature at each grid point.

### 2. Time-Dependent Heat Propagation
This uses the **heat equation**:
∂u/∂t = ∂²u/∂x² + ∂²u/∂y²
Temperature at each node is updated at every time step. Two cases are simulated:

- Free evolution from an initial temperature distribution
- Heating from specific points (I, J, K) at constant temperature (e.g., 500°C)

---

## Features & Implementation Notes

- Grid-based domain modeling (finite differences)  
- Boundary conditions with fixed and injected temperatures  
- Matrix-based heat propagation (via matrix exponential or iteration)  
- Visualization with `surf()` plots and `pause()` for animation  
- Convergence detection via error norm or equilibrium thresholds  
