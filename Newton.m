function [n, xn, fm, dfm, E, respuesta] = Newton(func,x0, Tol, niter)
    syms x
    f(x) = str2sym(func);
    %f(x) = ((exp(x)) / x) + 3;
    df = diff(f);
    c = 0;
    fm(c + 1) = eval(subs(f, x0));
    fe = fm(c + 1);
    dfm = eval(subs(df, x0));
    dfe = dfm;
    E(c + 1) = Tol + 1;
    error = E(c + 1);
    xn = x0;

    % Inicializar la tabla con los valores iniciales
    tabla = table(c, xn, fe, dfm, error, 'VariableNames', {'i', 'xn', 'Fm', 'dfm', 'Error'});

    while error > Tol && c < niter
        xn = x0 - fe / dfe;
        fm(c + 2) = eval(subs(f, xn));
        fe = fm(c + 2);
        dfm = eval(subs(df, xn));
        dfe = dfm;
        E(c + 2) = abs(xn - x0);
        error = E(c + 2);
        x0 = xn;
        c = c + 1;

        % Agregar resultados a la tabla en cada iteración
        nueva_fila = table(c, xn, fe, dfm, error, 'VariableNames', {'i', 'xn', 'Fm', 'dfm', 'Error'});
        tabla = [tabla; nueva_fila];
        csv_file_path = "tablas/newton_tabla.csv";
        writetable(tabla, csv_file_path);
    end

    if fe == 0
        s = x0;
        n = c;
        respuesta = sprintf('%f es raiz de f(x) \n', x0);
    elseif error < Tol
        s = x0;
        n = c;
        respuesta = sprintf('%f es una aproximación de una raiz de f(x) con una tolerancia= %f \n', x0, Tol);
    elseif dfe == 0
        s = x0;
        n = c;
        respuesta = sprintf('%f es una posible raiz múltiple de f(x) \n', x0);
    else
        s = x0;
        n = c;
        respuesta = sprintf('Fracasó en %f iteraciones \n', niter);
    end
end