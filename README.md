# Third-Year Projects – Computer Engineering @ INSA Lyon

This repository contains selected coursework and term projects from the fall semester of the third year (2024) in the Computer Engineering program at INSA Lyon.

Each project is located in its own folder and includes a separate README with details, code files, and implementation explanations.

## Projects Overview

### 1. `coswot-pubsub-module/`  
**COSWOT: Publisher-Subscriber Communication System (in C)**  
A real-time Pub/Sub architecture for transmitting RDF-encoded sensor data via TCP sockets.  
Includes topic-based filtering and multithreaded client management.

**Main File:**
`publisher_subscriber_module.c`

### 2. `linear-algebra-iterative-methods/`
**Iterative Methods for Solving Linear Systems**  
Implementation and comparison of three iterative methods for solving systems of linear equations:

- Jacobi Method  
- Gauss-Seidel Method  
- Relaxation Method (with tunable parameter `w`)

**Files:**
- `methodeJacobi.m`
- `methodeGaussSeidel.m`
- `methodeRelaxation.m`
- `programmeTest.m`

---

### 3. `linear-algebra-heat-simulation/`  
**Heat Distribution and Temperature Propagation**  
Simulation of static and dynamic heat transfer on a metal plate using finite difference methods.  
Includes both natural temperature evolution and forced heating from fixed points.

**Files:**
- `repartitionStatique.m`
- `evolutionLibreTemperature.m`
- `chauffagePlaque.m`

---

### 4. `linear-algebra-eigenvalue-analysis/`  
**Eigenvalue Computation and Vibrational Analysis**  
Numerical methods for eigenvalue extraction, applied to:

- Matrix power iteration  
- Wielandt deflation  
- Drum membrane vibration modes  
- Image compression using Singular Value Decomposition (SVD)

**Files:**
- `puissanceIteree.m`
- `deflationWielandt.m`
- `vibrationTambour.m`
- `applicationBonus.m`  
- `testMethodes.m`

---

> For more details, refer to the README files inside each project folder.
