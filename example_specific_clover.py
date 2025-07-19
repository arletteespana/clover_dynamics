
import numpy as np
from itertools import product
from collections import defaultdict

def build_manual_clover():
    A = np.zeros((5, 5), dtype=int)
    S = np.zeros_like(A)
    edges = [
        (0, 1, -1), (0, 2, -1), (0, 3, 1), (0, 4, 1),
        (1, 0, 1), (2, 0, 1), (3, 0, 1), (4, 0, -1)
    ]
    for i, j, sign in edges:
        A[i, j] = 1
        S[i, j] = sign
    return A, S, A * S

def boolean_dynamics(M, x0, T):
    traj = [x0.copy()]
    x = x0.copy()
    for _ in range(T):
        x = np.sign(M.T @ x)
        x[x == 0] = 1
        traj.append(x.copy())
    return traj

def get_dominant_set_and_depth(A):
    N = A.shape[0]
    U = [0]
    depth = 0
    determined = set(U)
    while len(determined) < N:
        new_determined = set()
        for v in range(N):
            if v not in determined:
                inputs = np.where(A[:, v] != 0)[0]
                if all(i in determined for i in inputs):
                    new_determined.add(v)
        if not new_determined:
            break
        determined.update(new_determined)
        depth += 1
    return sorted(U), depth

def find_cycles_to_zero(A, ℓ_max=None):
    N = A.shape[0]
    if ℓ_max is None:
        ℓ_max = N + 1
    cycles = []
    def dfs(path):
        last = path[-1]
        if len(path) > ℓ_max:
            return
        for j in range(N):
            if A[last, j]:
                if j == 0 and len(path) > 1:
                    cycles.append(list(path) + [0])
                elif j not in path:
                    dfs(path + [j])
    dfs([0])
    return cycles

def build_phi_clover(A, S, ℓ):
    memory = {}
    for hist in product([-1, 1], repeat=ℓ):
        x = np.ones(A.shape[0], dtype=int)
        x[0] = hist[0]
        for t in range(1, ℓ):
            x[0] = hist[t]
            x = np.sign((A * S).T @ x)
            x[x == 0] = 1
        memory[hist] = x[0]
    return lambda h: memory[tuple(h)]

def summarize(attractors_dict, transients):
    periods = [len(set(x[1] for x in values)) for values in attractors_dict.values()]
    return {
        'Nc': len(attractors_dict),
        'mp': round(np.mean(periods), 2),
        'mtm': round(np.mean(transients), 2),
        'mtM': int(np.max(transients)),
        'avg_basin': round(np.mean([len(v) for v in attractors_dict.values()]), 2)
    }

def run_manual_example():
    A, S, M = build_manual_clover()
    T = 2**M.shape[0] + 1
    state_space = [np.array([1 if b == '1' else -1 for b in format(i, '05b')]) for i in range(32)]
    attractors_full = defaultdict(list)
    transients_full = []
    for x0 in state_space:
        traj = boolean_dynamics(M, x0, T)
        seen = {}
        for t, state in enumerate(traj):
            key = tuple(state)
            if key in seen:
                attractors_full[tuple(traj[seen[key]])].append((x0.tolist(), t))
                transients_full.append(t)
                break
            seen[key] = t
    metrics_full = summarize(attractors_full, transients_full)

    U, d = get_dominant_set_and_depth(A)
    ℓ = max(len(c) for c in find_cycles_to_zero(A)) if find_cycles_to_zero(A) else 1
    Phi = build_phi_clover(A, S, ℓ)
    state_space_induced = list(product([-1, 1], repeat=ℓ))
    attractors_induced = defaultdict(list)
    transients_induced = []
    for y0 in state_space_induced:
        history = list(y0)
        seen = {}
        for t in range(T):
            key = tuple(history)
            if key in seen:
                attractors_induced[tuple(history)].append((list(y0), t))
                transients_induced.append(t)
                break
            seen[key] = t
            y_next = Phi(history)
            history = [y_next] + history[:-1]
    metrics_induced = summarize(attractors_induced, transients_induced)

    print("=== Complete Dynamics ===")
    for k, v in metrics_full.items():
        print(f"{k}: {v}")
    print("
=== Induced Dynamics ===")
    for k, v in metrics_induced.items():
        print(f"{k}: {v}")

if __name__ == "__main__":
    run_manual_example()
