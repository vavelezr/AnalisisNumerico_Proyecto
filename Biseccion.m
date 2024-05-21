function [respuesta, s, E, fm] = Biseccion(func, xi, xs, Tol, niter)
    syms x

    respuesta = "Error: No se encontró una raíz en el intervalo de la función";
    s = NaN;  % Valor predeterminado para s
    E = NaN;  % Valor predeterminado para E
    fm = NaN;  % Valor predeterminado para fm


    f = str2sym(func);
    fi = eval(subs(f, xi));
    fs = eval(subs(f, xs));


    % Verificación si alguno de los límites es una raíz
    if fi == 0
        s = xi;
        E = 0;
        fprintf('%f es raíz de f(x)', xi);
    elseif fs == 0
        s = xs;
        E = 0;
        fprintf('%f es raíz de f(x)', xs);

    % Verificación de signos opuestos para el intervalo
    elseif fs * fi < 0
        c = 0;
        xm = (xi + xs) / 2;
        fm(c + 1) = eval(subs(f, xm)); % Aproximación
        fe = fm(c + 1);
        E(c + 1) = Tol + 1;
        error = E(c + 1);

        Iteration = [];
        a = [];
        b = [];
        Xm = [];
        func = [];
        Error = [];

        % Bucle principal de iteración
        while error > Tol && fe ~= 0 && c < niter % fm = 0, se encontró la raíz
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
            xa = xm; % Valor de la iteración anterior para calcular el error
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


        % Creación de la tabla de resultados
        tabla = table(Iteration', a', Xm', b', func', Error', 'VariableNames', {'Iteración', 'a', 'xi', 'b', 'fxi', 'Error'});
        csv_file_path = "tablas/biseccion_tabla.csv"; % Ruta para guardar la tabla de resultados
        
        writetable(tabla, csv_file_path);


        % Determinación de la respuesta final
        if fe == 0
            s = xm;
            respuesta = sprintf('%f es raíz de f(x)', xm);
        elseif error < Tol
            s = xm;
            respuesta = sprintf('%f es una aproximación de una raíz de f(x) con una tolerancia de %f', xm, Tol);
        else
            s = xm;
            respuesta = sprintf('Fracasó en %f iteraciones', niter);
        end 
    else
        respuesta = sprintf('Ha ocurrido un error: el intervalo es inadecuado, Reformula');
    end
end
