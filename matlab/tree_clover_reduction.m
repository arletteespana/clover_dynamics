%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Summary (brief):
%%% This script generates random tree-like directed networks and, for several inhibition
%%% probabilities q, compares the original Boolean dynamics with a reduced dynamics .
%%% For each generated network it builds the transition maps, extracts attractor/basin
%%% statistics (e . g ., number of basins, periods, transients, maxima), and finally stores
%%% aggregated metrics across experiments for both the original and reduced models .
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Tree network, reduced network, and comparative basin analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
% clc;

%%% Global parameters
N =  10;        % Number of nodes
Ne = 50;        % Number of networks to generate
p = 0.3;        % Probability of creating branches
Ni = 2^N;       % Total number of possible configurations
B = (2.^(N-1:-1:0))';

%%% Inhibition probability values to evaluate
q_vals = [0.3, 0.6, 0.9];
Compila = zeros(length(q_vals), 6); % To store global summary

tic();

for nq = 1:length(q_vals)
    q = q_vals(nq);
    Resumen1 = zeros(Ne, 10); % For the original network
    Resumen2 = zeros(Ne, 10); % For the reduced network

    for ne = 1:Ne

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Tree network construction
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        At = zeros(N, N);
        s = find(rand(1, N-2) < p) + 2;
        l = length(s);

        if l > 0
            % First cycle
            for i = 1:s(1)-2
                At(i, i+1) = 1;
            endfor
            At(s(1)-1, 1) = 1;

            % Intermediate cycles
            for k = 1:l-1
                At(1, s(k)) = 1;
                for i = s(k):s(k+1)-2
                    At(i, i+1) = 1;
                endfor
                At(s(k+1)-1, 1) = 1;
            endfor

            % Last cycle
            At(1, s(l)) = 1;
            for i = s(l):N-1
                At(i, i+1) = 1;
            endfor
            At(N, 1) = 1;
        else
            % Single-cycle case
            for k = 1:N-1
                At(k, k+1) = 1;
            endfor
            At(N, 1) = 1;
        endif

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Original dynamics
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Q = (rand(N, N) < q);
        M = At - 2 * At .* Q;
        T = zeros(Ni, 2);

        for n = 1:Ni
            T(n, 1) = n - 1;
            x = Bin(n - 1, N);
            x = 2 * x - 1;
            y = x * M;
            y = (y > 0) - (y < 0) + x .* (y == 0);
            y = (y + 1) / 2;
            m = y * B;
            T(n, 2) = m;
        endfor

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Reduced dynamics
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        sc = [2 s N+1];
        lc = sc(2:l+2) - sc(1:l+1) + 1;
        qc = zeros(1, l+1);
        ml = max(lc);

        for k = 1:l+1
            qt = M(1, sc(k));
            for j = 1:lc(k)-2
                qt = qt * M(sc(k)+j-1, sc(k)+j);
            endfor
            qc(k) = qt * M(sc(k+1)-1, 1);
        endfor

        S = zeros(1, ml);
        for k = 1:ml
            sk = find(lc == k);
            S(k) = sum(qc(sk));
        endfor

        ni = 2^ml;
        BI = (2.^(ml-1:-1:0))';
        Tr = zeros(ni, 2);

        for n = 1:ni
            Tr(n, 1) = n - 1;
            x = Bin(n - 1, ml);
            x = 2 * x - 1;
            if S * (x') == 0
                f = x(1);
            else
                f = (S * (x') > 0) - (S * (x') < 0);
            endif
            y = ([f x(1:ml-1)] + 1) / 2;
            m = y * BI;
            Tr(n, 2) = m;
        endfor

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Dynamics analysis
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ST = AnalisisTransicion(T);
        STr = AnalisisTransicion(Tr);

        oST = sortrows(ST, [2 3]);     % Sort by column 2 (period)
        oSTr = sortrows(STr, [2 3]);

        % Metrics for the original network
        c1 = size(oST, 1);

        mp = mean(oST(:, 2));
        sp = std(oST(:, 2));
        mtc = mean(oST(:, 3));
        stc = std(oST(:, 3));
        mtm = mean(oST(:, 4));
        stm = std(oST(:, 4));
        mtM = mean(oST(:, 5));
        stM = std(oST(:, 5));
        Resumen1(ne, :) = [c1, mp, sp, mtc, stc, mtm, stm, mtM, stM, ml];

        % Metrics for the reduced network
        c2 = size(oSTr, 1);

        mpr = mean(oSTr(:, 2));
        spr = std(oSTr(:, 2));
        mtcr = mean(oSTr(:, 3));
        stcr = std(oSTr(:, 3));
        mtmr = mean(oSTr(:, 4));
        stmr = std(oSTr(:, 4));
        mtMr = mean(oSTr(:, 5));
        stMr = std(oSTr(:, 5));
        Resumen2(ne, :) = [c2, mpr, spr, mtcr, stcr, mtmr, stmr, mtMr, stMr, ml];

  endfor % end of Ne networks
    numc=Resumen1(:,1);        % Contains the number of basins per experiment
    maxc=max(numc);            % The maximum number of basins
    enm=find(numc < maxc);     % Non-maximum experiments
    numcnm=numc(enm);          % Number of basins excluding the maximum
    maxc2=max(numcnm);         % The second maximum number of basins
    e2nm=find(numcnm < maxc2); % Experiments below the 2nd maximum
    numc2nm=numcnm(e2nm);      % Number of basins excluding the two maxima
    mc1=mean(numc2nm);         % Mean number of basins in the bulk
    sc1=std(numc2nm);          % Standard deviation of the number of basins in the bulk
    Mc1=[maxc maxc2 sum(numc==maxc) sum(numc==maxc2)]; % Values and frequency of the two maxima

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    numc=Resumen2(:,1);        % Contains the number of basins per experiment
    maxc=max(numc);            % The maximum number of basins
    enm=find(numc < maxc);     % Non-maximum experiments
    numcnm=numc(enm);          % Number of basins excluding the maximum
    maxc2=max(numcnm);         % The second maximum number of basins
    e2nm=find(numcnm < maxc2); % Experiments below the 2nd maximum
    numc2nm=numcnm(e2nm);      % Number of basins excluding the two maxima
    mc2=mean(numc2nm);         % Mean number of basins in the bulk
    sc2=std(numc2nm);          % Standard deviation of the number of basins in the bulk
    Mc2=[maxc maxc2 sum(numc==maxc) sum(numc==maxc2)]; % Values and frequency of the two maxima

    % Save averages into Compila
    Compila1(nq, :) = [q mc1 sc1 Mc1 mean(Resumen1, 1)];
    Compila2(nq, :) = [q mc2 sc2 Mc2 mean(Resumen2, 1)];
endfor % end of q_vals

toc();
