# Dominant Vertices and Attractors’ Landscape in Boolean Networks

This repository contains the full implementation for generating and analyzing **clover-type Boolean networks** with signed interactions. The simulations evaluate the **complete and induced dynamics**, compute **dominant sets**, and measure various indicators related to the attractors’ landscape.

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

This analysis supports the results presented in the paper:

> **Dominant Vertices and Attractors’ Landscape for Boolean Networks**  
> A. España, W. Fúnez, E. Ugalde

## File Structure

```
simulate_clover_dynamics     # Main simulation code for ensemble dynamics
ensemble_results.csv         # Output with all computed metrics (automatically generated)
```

## How It Works

The script simulates dynamics of networks of dimension `N` with probabilities `p` and `q`:

- `p`: probability of creating a connection from the root node to other nodes.
- `q`: probability that an interaction is **inhibitory** (sign = –1); otherwise, it's activatory (+1).

For each combination of `(N, p, q)`, it:

1. Builds the network (`A`)
2. Assigns interaction signs (`S`)
3. Computes full Boolean dynamics on all states
4. Constructs the reduced logic (`Φ`) via dominant nodes
5. Compares dynamics:
   - Full transition graph vs. Induced dynamics
6. Outputs average statistics across `num_graphs` realizations

## Output Format

The results are saved in `ensemble_results.csv` with the following columns:

| Column             | Description                                        |
|--------------------|----------------------------------------------------|
| `N`, `p`, `q`      | Network size and control parameters                |
| `F_*`              | Indicators for full dynamics (complete graph)      |
| `Phi_*`            | Indicators for induced logic (reduced dynamics)    |

Where `*` can be:
- `Nc`: number of attractors
- `mp`: mean period
- `mtm`: mean transient time
- `mtM`: max transient time
- `avg_basin`: average basin size

## Requirements

This code runs in Python and depends on:

```bash
numpy
pandas
matplotlib
networkx
```

Install using:

```bash
pip install numpy pandas matplotlib networkx
```

## Running the Code

Just execute the script directly:

```bash
python simulate_clover_dynamics.py
```

This will run all simulations and generate `ensemble_results.csv`.

## Example

### Step-by-step Simulation: Specific Clover-Type Boolean Network

This example reproduces the full and reduced (induced) dynamics of a Boolean network with a fixed "clover" topology. The goal is to walk through all steps necessary to compute the number of attractors, their periods, basin sizes, and transient times, using the specific network:

```
Edges and signs:
0 → 1  (–)
0 → 2  (–)
0 → 3  (+)
0 → 4  (+)
1 → 0  (+)
2 → 0  (+)
3 → 0  (+)
4 → 0  (–)
```

This network is manually encoded and analyzed using Python.

#### Step-by-step Process

**1. Define the Boolean Network**  
We construct a 5-node network (`N = 5`) using the specified edges. The adjacency matrix `A` contains 1s where a connection exists, and the sign matrix `S` assigns +1 or -1 depending on whether the interaction is activatory or inhibitory. The interaction matrix is:

```
M = A * S
```

**2. Simulate the Full Boolean Dynamics**  
We simulate the dynamics for all 32 initial states over T = 33 steps.

Each trajectory is updated using:
```
x(t+1) = sign(Mᵗ x(t)), where sign(0) = +1
```

We detect:
- Transient time: steps before a cycle
- Attractor: repeating state pattern
- Basin: number of initial conditions per attractor

Metrics:
- `Nc`: number of attractors
- `mp`: mean period
- `mtm`: mean transient
- `mtM`: max transient
- `avg_basin`: average basin size

**3. Compute Dominant Set**  
We find the dominant set `U`.  
For this case: `U = {1}` and depth `d = 1`.

**4. Build Induced Logic Network**  
We identify cycles returning to node 1.  
This yields recurrence length `ℓ = 3` and defines `Φ: B^ℓ → B`.

**5. Simulate the Induced Dynamics**  
We simulate all 8 possible histories of the dominant node.  
We again extract the same metrics.

#### Results

**Full Dynamics**
- `Nc`: 4
- `mp`: 2.0
- `mtm`: 4.88
- `mtM`: 5
- `avg_basin`: 8.0

**Induced Dynamics**
- `Nc`: 4
- `mp`: 2.0
- `mtm`: 4.5
- `mtM`: 5
- `avg_basin`: 2.0

The induced logic captures the same attractors and cycle structure but with compressed basin size and slightly shorter average transients.


## Reference

If you use this code, please cite the associated paper:

```
A. España, W. Fúnez, E. Ugalde. "Dominant Vertices and Attractors’ Landscape for Boolean Networks", 2025.
```
