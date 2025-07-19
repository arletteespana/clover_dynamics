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
code                         # Main simulation code for ensemble dynamics
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
python code.py
```

This will run all simulations and generate `ensemble_results.csv`.

## Reference

If you use this code, please cite the associated paper:

```
A. España, W. Fúnez, E. Ugalde. "Dominant Vertices and Attractors’ Landscape for Boolean Networks", 2025.
```
