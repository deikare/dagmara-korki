%% minimum lokalne, ga z ograniczeniami nieliniowymi
clear
f = @(x) (x(2)^4 + x(1)^4 + (1 - x(1))^3 - x(2)^3); % x(1) == x1, x(2) == x2
nvars = 2;
options = optimoptions('ga', 'HybridFcn', @fmincon, 'FunctionTolerance', 1e-16, 'MaxGenerations', 1500 ,'MaxStallGenerations', 250);


[x, fval, exitflag, output] = ga(f, nvars, [], [], [], [], [], [], @nieliniowe_ogr_1_ga, options);
x
fval
exitflag

%% minimum lokalne nieograniczonej funkcji startując z poziomu x0 + pochodne
clear
x0 = [1, 0];
options = optimoptions(@fminunc, "Algorithm", "trust-region", "SpecifyObjectiveGradient", true, "HessianFcn", "objective");
handler_funkcji_celu = @(x) funkcja_celu_z_grad_i_hesjanem(x);

[x, fval, flaga, output] = fminunc(handler_funkcji_celu, x0, options);

%% minimum i maksimum globalne w przedziale z użyciem fminbnd
clear
% najpierw szukamy minimum
funkcja_celu_min = @(x) funkcja_do_fmin_bnd(x); %% tworzymy handler funkcji celu
lb = -1.2;
ub = 1.7;
options = optimset('MaxIter', 500, 'MaxFunEvals', 450, 'TolX', 1e-9, 'Display', 'final');
[x_min, fval_min, flaga_min] = fminbnd(funkcja_celu_min, lb, ub, options);
x_min
fval_min
flaga_min

% potem szukamy maximum - albo tworzymy plik z nową funkcją, albo
funkcja_celu_max = @(x) -funkcja_do_fmin_bnd(x); %% tworzymy handler funkcji celu - tym razem problem maks, więc minus przed funkcją celu
[x_max, fval_max, flaga_max] = fminbnd(funkcja_celu_max, lb, ub, options); %% fval_max jest wzięty z minimalizacji funkcji -f
x_max
fval_max = -fval_max % więc trzeba odwrócić znak fval_max
flaga_max


function [f, gradient, hesjan] = funkcja_celu_z_grad_i_hesjanem(x)
    f = x(2)^4 - x(1)^3 + (1-x(1))^4;
    
    gradient(1, 1) = 4*(x(1)-1)^3 - 3*x(1)^2; %% pierwszy element wektora gradientu
    gradient(2, 1) = 4*x(2)^3;
    
    hesjan(1, 1) = 12*(x(1)-1)^2 -6*x(1);
    hesjan(1, 2) = 0;
    hesjan(2, 1) = 0;
    hesjan(2, 2) = 12*x(2)^2;
end

function [c, ceq] = nieliniowe_ogr_1_ga(x)
    c = 3*x(1) + 4*x(1)*x(2) - 4;
    ceq = []; %% nie mamy ograniczenia równościowego
end