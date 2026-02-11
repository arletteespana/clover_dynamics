# Dominant Vertices and Attractors’ Landscape in Boolean Networks

This repository contains the full implementation (MATLAB/GNU Octave and Python) for generating and analyzing **clover-type Boolean networks** with signed interactions. The simulations evaluate the **complete and induced dynamics**, compute **dominant sets**, and measure various indicators related to the attractors’ landscape.

---

## Overview

The code supports:

- Random generation of **clover-type network topologies** with a distinguished root.
- Boolean dynamics with signed interactions (activatory or inhibitory).
- Construction of the **induced logical system** based on dominant vertices.
- Exhaustive analysis of both full and reduced dynamics:
  - Number of attractors (`Nc`)
  - Mean period (`mp`)
  - Mean/max transient time (`mtm`, `mtM`)
  - Average basin size (`avg_basin`)
- Ensemble averaging over multiple realizations.

---

## Repository Structure

clover_dynamics/

- matlab/
  - tree_clover_reduction.m        (Main MATLAB/Octave simulation script)
  - Bin.m                          (Binary state conversion helper)
  - AnalisisTransicion.m           (Attractor and basin analysis)

- simulate_clover_dynamics.py      (Python implementation – ensemble simulation)
- ensemble_results.csv             (Python output – automatically generated)
- results/                         (Optional output folder)

---

# MATLAB / GNU Octave Implementation

This implementation generates **tree-like (clover) directed networks**, assigns inhibitory interactions with probability `q`, and compares:

- The **full Boolean dynamics** on `2^N` states
- The **reduced induced dynamics** on `2^ℓ` states, where `ℓ` is the recurrence length of the clover structure

---

## Requirements (MATLAB / Octave)

- MATLAB (R20xx or newer), or
- GNU Octave

---

## Running in Octave

From the repository root:

    octave -qf matlab/tree_clover_reduction.m

---

## Running in MATLAB

Open MATLAB and run:

    run('matlab/tree_clover_reduction.m')

---

## What the MATLAB Script Does

For fixed parameters:

- `N` — number of nodes
- `p` — probability of creating branches from the root
- `q` — probability that an interaction is inhibitory

The script:

1. Generates a directed clover-type topology
2. Assigns signed interactions
3. Builds the full transition map on all `2^N` states
4. Constructs the reduced transition map on `2^ℓ` states
5. Computes attractor and basin statistics:
   - Number of basins (`Nc`)
   - Mean and standard deviation of periods
   - Mean and standard deviation of transient times
   - Maximum transient depth
6. Aggregates statistics across multiple realizations (`Ne` networks)

The resulting summary matrices are stored in the workspace and may optionally be saved to the `results/` directory.

---

# Python Implementation

The Python version performs:

- Random generation of **clover-type network topologies**
- Assignment of interaction signs (±1)
- Construction of the **full Boolean transition map**
- Construction of the **induced logical system (Φ)**
- Exhaustive state-space simulation
- Attractor and basin analysis
- Ensemble averaging across multiple realizations

---

## Installation (Python)

Clone the repository:

    git clone https://github.com/arletteespana/clover_dynamics.git
    cd clover_dynamics

Install dependencies:

    pip install numpy pandas matplotlib networkx

---

## Requirements (Python)

- numpy
- pandas
- matplotlib
- networkx

---

## Running the Python Code

    python simulate_clover_dynamics.py

This will execute all simulations and generate:

    ensemble_results.csv

---

## Output Format (Python)

The results are saved in `ensemble_results.csv` with the following columns:

- `N`, `p`, `q` — Network size and control parameters
- `F_*` — Indicators for full dynamics (complete graph)
- `Phi_*` — Indicators for induced logic (reduced dynamics)

Where `*` can be:

- `Nc` — number of attractors
- `mp` — mean period
- `mtm` — mean transient time
- `mtM` — maximum transient time
- `avg_basin` — average basin size

---

# Example (Python)

Specific clover-type Boolean network:

Edges and signs:

0 → 1  (–)  
0 → 2  (–)  
0 → 3  (+)  
0 → 4  (+)  
1 → 0  (+)  
2 → 0  (+)  
3 → 0  (+)  
4 → 0  (–)

Results:

Full Dynamics
- `Nc`: 4
- `mp`: 2.0
- `mtm`: 4.88
- `mtM`: 5
- `avg_basin`: 8.0

Induced Dynamics
- `Nc`: 4
- `mp`: 2.0
- `mtm`: 4.5
- `mtM`: 5
- `avg_basin`: 2.0

The induced logic captures the same attractors and cycle structure but with compressed basin size and slightly shorter average transients.

---

# Reference

If you use this code, please cite:

A. España, W. Fúnez, E. Ugalde. Dominant vertices and attractors’ landscape for Boolean networks. 2025. arXiv: 2509.03654 [math.DS]. url: https://arxiv.org/abs/2509.03654.
---

# License

This repository is released under the MIT License.
