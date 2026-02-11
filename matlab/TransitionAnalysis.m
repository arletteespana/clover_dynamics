%%%%% Brief summary:
%%%%% This function analyzes a state-transition table (TT) of a discrete dynamical system.
%%%%% It identifies attractors (basins of attraction), computes each basin's asymptotic period,
%%%%% basin size, and depth statistics (average and maximum distance to the attractor entry).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function S = AnalisisTransicion(TT)
N = size(TT);
L = N(1);

%%%%% Labeling of initial conditions by:
%%%%% 1) label of the basin they belong to
%%%%% 2) asymptotic period
%%%%% 3) distance to the entry point of the periodic attractor

basin = zeros(L,4);
basin(:,1) = (0:L-1)';
res = (0:L-1);
l = L;
while l > 0,
  n = min(res);
  clear orbit;
  orbit(1) = n;
  T = 1;
  d = 1;
  while d > 0,
    T = T + 1;
    n = TT(n+1,2);
    orbit(T) = n;
    d = min(abs(n - orbit(1:T-1)));
  endwhile
  fin = max(find(orbit(1:T-1) == n));       % Time of entry into the attractor
  p = T - fin;                               % Asymptotic period
  basin(orbit+1,2) = min(orbit(T-p:T-1));    % Attractor identifier
  basin(orbit+1,3) = p;                      % Asymptotic period
  for t = 1:T,
    s = orbit(t);
    basin(s+1,4) = max(fin - t, 0);          % Distance to the entry point
  endfor
  res = setdiff(res, orbit);
  l = length(res);
endwhile

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Basin of attraction characteristics
target = union(basin(:,2), basin(:,2));
c = length(target);
S = zeros(c,5);

for k = 1:c,
  b = target(k);
  S(k,1) = b;                                % Basin label
  S(k,2) = basin(b+1,3);                     % Period
  fuente = find(basin(:,2) == b);            % The basin (set of states)
  S(k,3) = length(fuente);                   % Basin size
  S(k,4) = sum(basin(fuente,4)) / S(k,3);    % Average basin depth
  S(k,5) = max(basin(fuente,4));             % Maximum basin depth
endfor
