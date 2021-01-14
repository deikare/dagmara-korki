clear %czyści workspace

%% zad1 - programowanie liniowe
% min: f(x) = -5x1 + 10x2 * 8x3 - 5x4

f = [-5 10 8 -5 0]; %funkcje celu przekazujemy w postaci wektora wspołczynników

%2gie ograniczenie należy przekształcić do postaci -4x1 + 5x2 - 3x3 + 4x5
% <= -20

% macierze A oraz wektor pionowy b (A * x <= b) tworzymy w ten sposób, że każda linijka
% A oraz b jest interpretowana przez nas jako jedne ograniczenie

% -4x1 -5x3 + 4x4 + 5x5 <= 30
% -4x1 + 5x2 - 3x3 + 4x5 <= -20

A = [-4 0 -5 4 5; -4 5 -3 0 4];
b = [30; -20];

Aeq = [-1 1 0 -1 0];
beq = [5];

lb = [0; 0; 0; 0; 0];
ub = []; % puszczamy pusty wektor, ponieważ nie mamy ograniczeń

[x, fval, flaga, output] = linprog(f, A, b, Aeq, beq, lb, ub);

x
fval = -fval %minus przy fvalue, bo fval zdefiniowane jako problem minimimalizacji
flaga

%% zad 2 - używanie fminbnd
f = @(x) -cos(x./4) + x .* sin(x); %% definiujemy funkcję celu jako handler funkcji
options = optimset('Display', 'final', 'TolFun', 1e-12, 'MaxIter', 700, 'MaxFunEvals', 1000);
[x1, fval1, flaga1] = fminbnd(f, 4, 8, options);
[x2, fval2, flaga2] = fminbnd(f, 8, 11, options);
[x3, fval3, flaga3] = fminbnd(f, 11, 14, options);
[x4, fval4, flaga4] = fminbnd(f, 14, 17, options);
[x5, fval5, flaga5] = fminbnd(f, 17, 20, options);

x0 = 4;
fval0 = f(x0);

x6 = 20;
fval6 = f(x6);

X = [x0; x1; x2; x3; x4; x5; x6]; %%grupujemy grupujemy wszystkie rozw. razem
Fval = [-fval0;-fval1; -fval2; -fval3; -fval4; -fval5; -fval6];
Flagi = [1; flaga1; flaga2; flaga3; flaga4; flaga5; 1];
lb = [4; 4; 8; 11; 14; 17; 20];
ub = [4; 8; 11; 14; 17; 20; 20];

rozw = [X, Fval, Flagi, lb, ub]; %wstawiamy kolumnami do macierzy rozw
rozw_posortowane = sortrows(rozw, 2, 'descend'); % sortujemy rozwiązanie względem ...
                                                % ... kolumny wartości funkcji malejąco
xmax = rozw_posortowane(1, 1)
fmax = rozw_posortowane(1, 2)