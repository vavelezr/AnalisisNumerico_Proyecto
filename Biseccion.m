function [respuesta, s, E, fm] = Biseccion(func, xi, xs, Tol, niter)
    syms x

    respuesta = "Error: No se encontró una raíz en el intervalo de la función";
    s = NaN;  % Valor predeterminado para s
    E = NaN;  % Valor predeterminado para E
    fm = NaN;  % Valor predeterminado para fm

    f = str2sym(func);
    fi = eval(subs(f, xi));
    fs = eval(subs(f, xs));

    % se evalua la funcion en el intervalo, para ver si alguno es la raiz
    if fi == 0
        s = xi;
        E = 0;
        fprintf('%f es raiz de f(x)', xi);
    elseif fs == 0
        s = xs;
        E = 0;
        fprintf('%f es raiz de f(x)', xs);
    %signos opuestos para la evaluacion del intervalo
    elseif fs * fi < 0
        c = 0;
        xm = (xi + xs) / 2;
        fm(c + 1) = eval(subs(f, xm)); %aproximacion
        fe = fm(c + 1);
        E(c + 1) = Tol + 1;
        error = E(c + 1);

        Iteration = [];
        a = [];
        b = [];
        Xm = [];
        func = [];
        Error = [];

        while error > Tol && fe ~= 0 && c < niter % fm = 0, se hayo la raiz
            Iteration = [Iteration, c];
            a = [a, xi];
            b = [b, xs];
            Xm = [Xm, xm];
            func = [func, fe];
            Error = [Error, error];

            if fi * fe < 0 %[xa, xm]
                xs = xm;
                fs = eval(subs(f, xs));
            else %[xm, xb]
                xi = xm;
                fi = eval(subs(f, xi));
            end
            xa = xm; % valor iteracion anterior para calcular error
            xm = (xi + xs) / 2;
            fm(c + 2) = eval(subs(f, xm));
            fe = fm(c + 2);

            if (error == 1)
                E(c + 2) = abs((xm - xa) / xm);
                error = E(c + 2);
            else
                E(c + 2) = abs(xm - xa);
                error = E(c + 2);
            end

            c = c + 1;

        end

        tabla = table(Iteration', a', Xm', b', func', Error', 'VariableNames', {'Iteration', 'a', 'xi', 'b', 'fxi', 'Error'});
        csv_file_path = "tablas/biseccion_tabla.csv";
        writetable(tabla, csv_file_path);

        if fe == 0
            s = xm;
            respuesta = sprintf('%f es raiz de f(x)', xm);
        elseif error < Tol
            s = xm;
            respuesta = sprintf('%f es una aproximación de una raiz de f(x) con una tolerancia= %f', xm, Tol);
        else
            s = xm;
            respuesta = sprintf('Fracasó en %f iteraciones', niter);
        end
    else
        respuesta = sprintf('Error: el intervalo es inadecuado, verifica que exista una raiz en el intervalo');
    end
end