function [n, xn, fm, E, tabla] = secante(x0, x1, Tol, niter)
    syms x

    f(x) = (abs(x)^(x-1)) - 2.5*x - 5;
    % Alternativas para f(x)
    % f(x) = log(sin(x)^2 + 1)-(1/2);
    % f(x) = sin(2*x)-(x/3)^3+0.1;

    c = 0;
    fm(c + 1) = eval(subs(f, x0));
    fs = eval(subs(f, x1));
    E(c + 1) = Tol + 1;
    error = E(c + 1);
    xn = x1 - ((fs * (x1 - x0)) / (fs - fm(c + 1)));

    % Inicializar la tabla con los valores iniciales
    tabla = table(c, xn, fs, error, 'VariableNames', {'i', 'xn', 'Fm', 'Error'});

    while error > Tol && fs ~= 0 && c < niter
        c = c + 1;
        x0 = x1;
        x1 = xn;
        fm(c + 1) = eval(subs(f, xn));
        fs = eval(subs(f, x1));
        xn = x1 - ((fs * (x1 - x0)) / (fs - fm(c)));
        E(c + 1) = abs(xn - x1);
        error = E(c + 1);

        % Agregar resultados a la tabla en cada iteración
        nueva_fila = table(c, xn, fs, error, 'VariableNames', {'i', 'xn', 'Fm', 'Error'});
        tabla = [tabla; nueva_fila];

        if (fs - fm(c)) == 0
            fprintf('No se puede continuar con el método ya que el denominador es cero. %f es una aproximación de una raíz de f(x) con una tolerancia= %f \n', xn, Tol);
            break;
        end
    end

    if fs == 0
        fprintf('%f es raíz de f(x) \n', xn);
    elseif error < Tol
        fprintf('%f es una aproximación de una raíz de f(x) con una tolerancia= %.10f \n', xn, Tol);
    else
        fprintf('Fracasó en %f iteraciones \n', niter);
    end

    n = c;
end
