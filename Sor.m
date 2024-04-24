function [radio, E, s] = Sor(x0, A, b, Tol, niter, w, error_control)
    A = double(A);
    b = double(b);
    x0 = double(x0);
    w = double(w);

    D = diag(diag(A));
    L = -tril(A, -1);
    U = -triu(A, 1);

    c = 0;
    error_control = Tol + 1;
    E = zeros(1, niter + 1);
    E(1) = error_control;
    Xt = zeros(length(x0), niter + 1);
    Xt(:, 1) = x0;
    n = zeros(1, niter + 1);
    n(1) = c;

    while error_control > Tol && c < niter
        T = inv(D - w * L) * ((1 - w) * D + w * U);
        C = w * inv(D - w * L) * b;
        x1 = T * x0 + C;

        c = c + 1;
        n(c) = c;
        Xt(:, c) = x1;

        if error_control == 1
            E(c) = norm((x1 - x0) ./ x1, 'inf');
        else
            E(c) = norm(x1 - x0, 'inf');
        end

        error_control = E(c);
        x0 = x1;
    end

    radio = max(abs(eig(T)));

    if error_control < Tol
        s = x0;
        fprintf('Es una aproximación de la solución del sistema con una tolerancia = %f\n', Tol);
    else
        s = x0;
        fprintf('Fracasó en %d iteraciones\n', niter);
    end   

    % Recortar matrices a la cantidad de iteraciones realmente ejecutadas
    Xt = Xt(:, 1:c);
    E = E(1:c);
    n = n(1:c);

    % Creación de tabla para CSV
    XtT = Xt';  % Transponer para que cada fila sea una iteración
    data = [n', XtT, E'];
    colNames = ['Iteración', arrayfun(@(x) sprintf('X%d', x), 1:size(XtT,2), 'UniformOutput', false), 'Error'];
    tabla = array2table(data, 'VariableNames', colNames);

    csv_file_path = "tablas/tabla_sor.csv";
    writetable(tabla, csv_file_path);
end
